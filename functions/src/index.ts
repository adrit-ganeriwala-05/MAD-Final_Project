import * as admin from 'firebase-admin';
import { onCall } from 'firebase-functions/v2/https';
import { onDocumentCreated } from 'firebase-functions/v2/firestore';
import { optimiseActivities } from './optimiser/optimiser';
import { Activity, OptimiseRequest, UserPreferences } from './types/models';

admin.initializeApp();

const db = admin.firestore();

/** Scores and reorders a trip's activities using the optimiser algorithm. */
export const optimiseItinerary = onCall(
  { region: 'us-central1' },
  async (request) => {
    const { tripId } = request.data as OptimiseRequest;

    const tripDoc = await db.collection('trips').doc(tripId).get();
    if (!tripDoc.exists) {
      throw new Error(`Trip ${tripId} not found`);
    }

    const tripData = tripDoc.data() as Record<string, unknown>;
    const memberIds = (tripData['memberIds'] as string[]) ?? [];
    if (memberIds.length === 0) {
      throw new Error('Trip has no members');
    }

    const firstMemberId = memberIds[0];
    const userDoc = await db.collection('users').doc(firstMemberId).get();
    const userData = userDoc.exists
      ? (userDoc.data() as Record<string, unknown>)
      : {};

    const travelPrefs = userData['travelPreferences'] as
      | Record<string, unknown>
      | undefined;

    const prefs: UserPreferences = {
      defaultDailyBudget:
        (userData['defaultDailyBudget'] as number | undefined) ?? 20000,
      pace:
        (travelPrefs?.['pace'] as UserPreferences['pace'] | undefined) ??
        'moderate',
    };

    const activitiesSnap = await db
      .collection('trips')
      .doc(tripId)
      .collection('activities')
      .get();

    const activities: Activity[] = activitiesSnap.docs.map((doc) => {
      const data = doc.data();
      return {
        activityId: doc.id,
        title: (data['title'] as string) ?? '',
        estimatedCost: (data['estimatedCost'] as number) ?? 0,
        durationMinutes: (data['durationMinutes'] as number) ?? 0,
        category: (data['category'] as string) ?? '',
        position: (data['position'] as number) ?? 0,
      };
    });

    const optimised = optimiseActivities(activities, prefs);

    const batch = db.batch();
    for (const activity of optimised) {
      const ref = db
        .collection('trips')
        .doc(tripId)
        .collection('activities')
        .doc(activity.activityId);
      batch.update(ref, {
        scoreDistance: activity.scoreDistance ?? null,
        scoreBudget: activity.scoreBudget ?? null,
        scoreTimeFit: activity.scoreTimeFit ?? null,
        updatedAt: admin.firestore.FieldValue.serverTimestamp(),
      });
    }

    batch.update(db.collection('trips').doc(tripId), {
      optimisedOrder: optimised.map((a) => a.activityId),
      updatedAt: admin.firestore.FieldValue.serverTimestamp(),
    });

    await batch.commit();
    return { success: true, activitiesScored: optimised.length };
  },
);

// ── FCM: notify trip members when a new activity is added ─────────────────────

export const onActivityAdded = onDocumentCreated(
  {
    document: 'trips/{tripId}/activities/{activityId}',
    region: 'us-central1',
  },
  async (event) => {
    const tripId = event.params.tripId;
    const data = event.data?.data();
    if (!data) return;

    const title = (data['title'] as string) ?? 'New Activity';
    const createdBy = (data['createdBy'] as string) ?? '';

    let creatorName = 'Someone';
    try {
      const userDoc = await db.collection('users').doc(createdBy).get();
      creatorName = (userDoc.data()?.['displayName'] as string) ?? 'Someone';
    } catch (_) {
      // ignore
    }

    await admin.messaging().sendToTopic(
      `trip_${tripId}`,
      {
        notification: {
          title: '✈️ New Activity Added',
          body: `${creatorName} added "${title}" to the itinerary`,
        },
        data: {
          tripId,
          type: 'activity_added',
        },
      },
    );

    console.log(`FCM: sent activity notification for trip ${tripId}`);
  },
);

// ── FCM: notify trip members when a new chat message is sent ──────────────────

export const onMessageSent = onDocumentCreated(
  {
    document: 'trips/{tripId}/messages/{messageId}',
    region: 'us-central1',
  },
  async (event) => {
    const tripId = event.params.tripId;
    const data = event.data?.data();
    if (!data) return;

    const senderName = (data['senderName'] as string) ?? 'Someone';
    const text = (data['text'] as string) ?? '';
    const preview = text.length > 50 ? `${text.substring(0, 50)}…` : text;

    await admin.messaging().sendToTopic(
      `trip_${tripId}`,
      {
        notification: {
          title: `💬 ${senderName}`,
          body: preview,
        },
        data: {
          tripId,
          type: 'message_sent',
        },
      },
    );

    console.log(`FCM: sent chat notification for trip ${tripId}`);
  },
);
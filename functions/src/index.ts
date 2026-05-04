// functions/src/index.ts

import * as admin from 'firebase-admin';
import { onCall } from 'firebase-functions/v2/https';

import { optimiseActivities } from './optimiser/optimiser';
import { Activity, OptimiseRequest, UserPreferences } from './types/models';

admin.initializeApp();

const db = admin.firestore();

/** Scores and reorders a trip's activities using the optimiser algorithm. */
export const optimiseItinerary = onCall(
  { region: 'us-central1' },
  async (request) => {
    const { tripId } = request.data as OptimiseRequest;

    // Read trip to get member list
    const tripDoc = await db.collection('trips').doc(tripId).get();
    if (!tripDoc.exists) {
      throw new Error(`Trip ${tripId} not found`);
    }
    const tripData = tripDoc.data() as Record<string, unknown>;
    const memberIds = (tripData['memberIds'] as string[]) ?? [];

    if (memberIds.length === 0) {
      throw new Error('Trip has no members');
    }

    // Read first member's preferences
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

    // Read all activities
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

    // Score and sort
    const optimised = optimiseActivities(activities, prefs);

    // Batch-write scores back to activity documents and optimisedOrder to trip
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

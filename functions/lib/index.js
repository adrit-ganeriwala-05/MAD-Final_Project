"use strict";
var __createBinding = (this && this.__createBinding) || (Object.create ? (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    var desc = Object.getOwnPropertyDescriptor(m, k);
    if (!desc || ("get" in desc ? !m.__esModule : desc.writable || desc.configurable)) {
      desc = { enumerable: true, get: function() { return m[k]; } };
    }
    Object.defineProperty(o, k2, desc);
}) : (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    o[k2] = m[k];
}));
var __setModuleDefault = (this && this.__setModuleDefault) || (Object.create ? (function(o, v) {
    Object.defineProperty(o, "default", { enumerable: true, value: v });
}) : function(o, v) {
    o["default"] = v;
});
var __importStar = (this && this.__importStar) || (function () {
    var ownKeys = function(o) {
        ownKeys = Object.getOwnPropertyNames || function (o) {
            var ar = [];
            for (var k in o) if (Object.prototype.hasOwnProperty.call(o, k)) ar[ar.length] = k;
            return ar;
        };
        return ownKeys(o);
    };
    return function (mod) {
        if (mod && mod.__esModule) return mod;
        var result = {};
        if (mod != null) for (var k = ownKeys(mod), i = 0; i < k.length; i++) if (k[i] !== "default") __createBinding(result, mod, k[i]);
        __setModuleDefault(result, mod);
        return result;
    };
})();
Object.defineProperty(exports, "__esModule", { value: true });
exports.onMessageSent = exports.onActivityAdded = exports.optimiseItinerary = void 0;
const admin = __importStar(require("firebase-admin"));
const https_1 = require("firebase-functions/v2/https");
const firestore_1 = require("firebase-functions/v2/firestore");
const optimiser_1 = require("./optimiser/optimiser");
admin.initializeApp();
const db = admin.firestore();
/** Scores and reorders a trip's activities using the optimiser algorithm. */
exports.optimiseItinerary = (0, https_1.onCall)({ region: 'us-central1' }, async (request) => {
    var _a, _b, _c, _d, _e, _f;
    const { tripId } = request.data;
    const tripDoc = await db.collection('trips').doc(tripId).get();
    if (!tripDoc.exists) {
        throw new Error(`Trip ${tripId} not found`);
    }
    const tripData = tripDoc.data();
    const memberIds = (_a = tripData['memberIds']) !== null && _a !== void 0 ? _a : [];
    if (memberIds.length === 0) {
        throw new Error('Trip has no members');
    }
    const firstMemberId = memberIds[0];
    const userDoc = await db.collection('users').doc(firstMemberId).get();
    const userData = userDoc.exists
        ? userDoc.data()
        : {};
    const travelPrefs = userData['travelPreferences'];
    const prefs = {
        defaultDailyBudget: (_b = userData['defaultDailyBudget']) !== null && _b !== void 0 ? _b : 20000,
        pace: (_c = travelPrefs === null || travelPrefs === void 0 ? void 0 : travelPrefs['pace']) !== null && _c !== void 0 ? _c : 'moderate',
    };
    const activitiesSnap = await db
        .collection('trips')
        .doc(tripId)
        .collection('activities')
        .get();
    const activities = activitiesSnap.docs.map((doc) => {
        var _a, _b, _c, _d, _e;
        const data = doc.data();
        return {
            activityId: doc.id,
            title: (_a = data['title']) !== null && _a !== void 0 ? _a : '',
            estimatedCost: (_b = data['estimatedCost']) !== null && _b !== void 0 ? _b : 0,
            durationMinutes: (_c = data['durationMinutes']) !== null && _c !== void 0 ? _c : 0,
            category: (_d = data['category']) !== null && _d !== void 0 ? _d : '',
            position: (_e = data['position']) !== null && _e !== void 0 ? _e : 0,
        };
    });
    const optimised = (0, optimiser_1.optimiseActivities)(activities, prefs);
    const batch = db.batch();
    for (const activity of optimised) {
        const ref = db
            .collection('trips')
            .doc(tripId)
            .collection('activities')
            .doc(activity.activityId);
        batch.update(ref, {
            scoreDistance: (_d = activity.scoreDistance) !== null && _d !== void 0 ? _d : null,
            scoreBudget: (_e = activity.scoreBudget) !== null && _e !== void 0 ? _e : null,
            scoreTimeFit: (_f = activity.scoreTimeFit) !== null && _f !== void 0 ? _f : null,
            updatedAt: admin.firestore.FieldValue.serverTimestamp(),
        });
    }
    batch.update(db.collection('trips').doc(tripId), {
        optimisedOrder: optimised.map((a) => a.activityId),
        updatedAt: admin.firestore.FieldValue.serverTimestamp(),
    });
    await batch.commit();
    return { success: true, activitiesScored: optimised.length };
});
// ── FCM: notify trip members when a new activity is added ─────────────────────
exports.onActivityAdded = (0, firestore_1.onDocumentCreated)({
    document: 'trips/{tripId}/activities/{activityId}',
    region: 'us-central1',
}, async (event) => {
    var _a, _b, _c, _d, _e;
    const tripId = event.params.tripId;
    const data = (_a = event.data) === null || _a === void 0 ? void 0 : _a.data();
    if (!data)
        return;
    const title = (_b = data['title']) !== null && _b !== void 0 ? _b : 'New Activity';
    const createdBy = (_c = data['createdBy']) !== null && _c !== void 0 ? _c : '';
    let creatorName = 'Someone';
    try {
        const userDoc = await db.collection('users').doc(createdBy).get();
        creatorName = (_e = (_d = userDoc.data()) === null || _d === void 0 ? void 0 : _d['displayName']) !== null && _e !== void 0 ? _e : 'Someone';
    }
    catch (_) {
        // ignore
    }
    await admin.messaging().send({
        topic: `trip_${tripId}`,
        notification: {
            title: '✈️ New Activity Added',
            body: `${creatorName} added "${title}" to the itinerary`,
        },
        data: {
            tripId,
            type: 'activity_added',
        },
    });
    console.log(`FCM: sent activity notification for trip ${tripId}`);
});
// ── FCM: notify trip members when a new chat message is sent ──────────────────
exports.onMessageSent = (0, firestore_1.onDocumentCreated)({
    document: 'trips/{tripId}/messages/{messageId}',
    region: 'us-central1',
}, async (event) => {
    var _a, _b, _c;
    const tripId = event.params.tripId;
    const data = (_a = event.data) === null || _a === void 0 ? void 0 : _a.data();
    if (!data)
        return;
    const senderName = (_b = data['senderName']) !== null && _b !== void 0 ? _b : 'Someone';
    const text = (_c = data['text']) !== null && _c !== void 0 ? _c : '';
    const preview = text.length > 50 ? `${text.substring(0, 50)}…` : text;
    await admin.messaging().send({
        topic: `trip_${tripId}`,
        notification: {
            title: `💬 ${senderName}`,
            body: preview,
        },
        data: {
            tripId,
            type: 'message_sent',
        },
    });
    console.log(`FCM: sent chat notification for trip ${tripId}`);
});
//# sourceMappingURL=index.js.map
// functions/src/types/models.ts

/** A single itinerary activity, mirroring the Firestore schema. */
export interface Activity {
  activityId: string;
  title: string;
  /** Estimated cost in cents. */
  estimatedCost: number;
  durationMinutes: number;
  category: string;
  position: number;
  scoreDistance?: number;
  scoreBudget?: number;
  scoreTimeFit?: number;
}

/** Travel preferences stored on the user document. */
export interface UserPreferences {
  /** Default daily budget in cents. */
  defaultDailyBudget: number;
  pace: 'relaxed' | 'moderate' | 'intense';
}

/** Payload for the optimiseItinerary callable function. */
export interface OptimiseRequest {
  tripId: string;
}

// functions/src/optimiser/optimiser.ts
// Pure scoring logic — no Firebase imports, fully unit-testable.

import { Activity, UserPreferences } from '../types/models';

/**
 * Scores an activity by budget fit.
 * Returns 0–100. 100 for free, 0 if cost exceeds 2× daily budget.
 */
export function scoreBudget(estimatedCost: number, dailyBudget: number): number {
  if (estimatedCost <= 0) return 100;
  if (dailyBudget <= 0) return 0;
  if (estimatedCost >= 2 * dailyBudget) return 0;
  return Math.round(100 * (1 - estimatedCost / (2 * dailyBudget)));
}

/**
 * Scores an activity by duration fit for the user's travel pace.
 * Returns 0–100.
 * - relaxed: prefers ≤120 min, penalises >240 min
 * - moderate: prefers ≤240 min, penalises >480 min
 * - intense: prefers ≤480 min, penalises >960 min
 */
export function scoreTimeFit(durationMinutes: number, pace: string): number {
  switch (pace) {
    case 'relaxed': {
      if (durationMinutes <= 120) return 100;
      if (durationMinutes > 240) return 0;
      return Math.round(100 * (1 - (durationMinutes - 120) / 120));
    }
    case 'intense': {
      if (durationMinutes <= 480) return 100;
      if (durationMinutes > 960) return 0;
      return Math.round(100 * (1 - (durationMinutes - 480) / 480));
    }
    default: {
      // moderate
      if (durationMinutes <= 240) return 100;
      if (durationMinutes > 480) return 0;
      return Math.round(100 * (1 - (durationMinutes - 240) / 240));
    }
  }
}

/**
 * Scores an activity by position variety within the itinerary.
 * Returns 0–100. First and last positions score highest.
 * Formula: 100 - |index/total - 0.5| * 40
 */
export function scoreDistance(index: number, total: number): number {
  if (total === 0) return 100;
  return Math.round(100 - Math.abs(index / total - 0.5) * 40);
}

/**
 * Scores all activities, sorts by average score descending, and
 * returns the scored array.
 */
export function optimiseActivities(
  activities: Activity[],
  prefs: UserPreferences,
): Activity[] {
  if (activities.length === 0) return [];

  const scored = activities.map((activity, index) => ({
    ...activity,
    scoreDistance: scoreDistance(index, activities.length),
    scoreBudget: scoreBudget(activity.estimatedCost, prefs.defaultDailyBudget),
    scoreTimeFit: scoreTimeFit(activity.durationMinutes, prefs.pace),
  }));

  return scored.sort((a, b) => {
    const avgA =
      ((a.scoreDistance ?? 0) + (a.scoreBudget ?? 0) + (a.scoreTimeFit ?? 0)) /
      3;
    const avgB =
      ((b.scoreDistance ?? 0) + (b.scoreBudget ?? 0) + (b.scoreTimeFit ?? 0)) /
      3;
    return avgB - avgA;
  });
}

"use strict";
// functions/src/optimiser/optimiser.ts
// Pure scoring logic — no Firebase imports, fully unit-testable.
Object.defineProperty(exports, "__esModule", { value: true });
exports.scoreBudget = scoreBudget;
exports.scoreTimeFit = scoreTimeFit;
exports.scoreDistance = scoreDistance;
exports.optimiseActivities = optimiseActivities;
/**
 * Scores an activity by budget fit.
 * Returns 0–100. 100 for free, 0 if cost exceeds 2× daily budget.
 */
function scoreBudget(estimatedCost, dailyBudget) {
    if (estimatedCost <= 0)
        return 100;
    if (dailyBudget <= 0)
        return 0;
    if (estimatedCost >= 2 * dailyBudget)
        return 0;
    return Math.round(100 * (1 - estimatedCost / (2 * dailyBudget)));
}
/**
 * Scores an activity by duration fit for the user's travel pace.
 * Returns 0–100.
 * - relaxed: prefers ≤120 min, penalises >240 min
 * - moderate: prefers ≤240 min, penalises >480 min
 * - intense: prefers ≤480 min, penalises >960 min
 */
function scoreTimeFit(durationMinutes, pace) {
    switch (pace) {
        case 'relaxed': {
            if (durationMinutes <= 120)
                return 100;
            if (durationMinutes > 240)
                return 0;
            return Math.round(100 * (1 - (durationMinutes - 120) / 120));
        }
        case 'intense': {
            if (durationMinutes <= 480)
                return 100;
            if (durationMinutes > 960)
                return 0;
            return Math.round(100 * (1 - (durationMinutes - 480) / 480));
        }
        default: {
            // moderate
            if (durationMinutes <= 240)
                return 100;
            if (durationMinutes > 480)
                return 0;
            return Math.round(100 * (1 - (durationMinutes - 240) / 240));
        }
    }
}
/**
 * Scores an activity by position variety within the itinerary.
 * Returns 0–100. First and last positions score highest.
 * Formula: 100 - |index/total - 0.5| * 40
 */
function scoreDistance(index, total) {
    if (total === 0)
        return 100;
    return Math.round(100 - Math.abs(index / total - 0.5) * 40);
}
/**
 * Scores all activities, sorts by average score descending, and
 * returns the scored array.
 */
function optimiseActivities(activities, prefs) {
    if (activities.length === 0)
        return [];
    const scored = activities.map((activity, index) => (Object.assign(Object.assign({}, activity), { scoreDistance: scoreDistance(index, activities.length), scoreBudget: scoreBudget(activity.estimatedCost, prefs.defaultDailyBudget), scoreTimeFit: scoreTimeFit(activity.durationMinutes, prefs.pace) })));
    return scored.sort((a, b) => {
        var _a, _b, _c, _d, _e, _f;
        const avgA = (((_a = a.scoreDistance) !== null && _a !== void 0 ? _a : 0) + ((_b = a.scoreBudget) !== null && _b !== void 0 ? _b : 0) + ((_c = a.scoreTimeFit) !== null && _c !== void 0 ? _c : 0)) /
            3;
        const avgB = (((_d = b.scoreDistance) !== null && _d !== void 0 ? _d : 0) + ((_e = b.scoreBudget) !== null && _e !== void 0 ? _e : 0) + ((_f = b.scoreTimeFit) !== null && _f !== void 0 ? _f : 0)) /
            3;
        return avgB - avgA;
    });
}
//# sourceMappingURL=optimiser.js.map
"use strict";
// functions/src/optimiser/optimiser.test.ts
Object.defineProperty(exports, "__esModule", { value: true });
const optimiser_1 = require("./optimiser");
// ── scoreBudget ───────────────────────────────────────────────────────────────
test('scoreBudget returns 100 for free activity', () => {
    expect((0, optimiser_1.scoreBudget)(0, 10000)).toBe(100);
});
test('scoreBudget returns 0 for activity costing 3x daily budget', () => {
    expect((0, optimiser_1.scoreBudget)(30000, 10000)).toBe(0);
});
test('scoreBudget returns mid-range score for activity at daily budget', () => {
    // cost == dailyBudget → 100 * (1 - 1/2) = 50
    expect((0, optimiser_1.scoreBudget)(10000, 10000)).toBe(50);
});
// ── scoreTimeFit ──────────────────────────────────────────────────────────────
test('scoreTimeFit returns higher score for short activity with relaxed pace', () => {
    const shortScore = (0, optimiser_1.scoreTimeFit)(60, 'relaxed');
    const longScore = (0, optimiser_1.scoreTimeFit)(300, 'relaxed');
    expect(shortScore).toBeGreaterThan(longScore);
});
test('scoreTimeFit returns 100 for short moderate activity', () => {
    expect((0, optimiser_1.scoreTimeFit)(120, 'moderate')).toBe(100);
});
test('scoreTimeFit returns 0 for very long activity with relaxed pace', () => {
    expect((0, optimiser_1.scoreTimeFit)(500, 'relaxed')).toBe(0);
});
// ── scoreDistance ─────────────────────────────────────────────────────────────
test('scoreDistance returns 100 for single activity', () => {
    expect((0, optimiser_1.scoreDistance)(0, 0)).toBe(100);
});
// ── optimiseActivities ────────────────────────────────────────────────────────
test('optimiseActivities returns activities sorted by average score descending', () => {
    const activities = [
        {
            activityId: '1',
            title: 'Expensive long activity',
            estimatedCost: 50000,
            durationMinutes: 480,
            category: 'adventure',
            position: 1,
        },
        {
            activityId: '2',
            title: 'Cheap short activity',
            estimatedCost: 500,
            durationMinutes: 60,
            category: 'food',
            position: 2,
        },
    ];
    const prefs = {
        defaultDailyBudget: 10000,
        pace: 'moderate',
    };
    const result = (0, optimiser_1.optimiseActivities)(activities, prefs);
    // Cheap/short should outscore expensive/long
    expect(result[0].activityId).toBe('2');
});
test('optimiseActivities handles empty array', () => {
    const prefs = { defaultDailyBudget: 10000, pace: 'moderate' };
    expect((0, optimiser_1.optimiseActivities)([], prefs)).toEqual([]);
});
test('optimiseActivities handles single activity', () => {
    const activities = [
        {
            activityId: 'solo',
            title: 'Solo activity',
            estimatedCost: 5000,
            durationMinutes: 120,
            category: 'sightseeing',
            position: 1,
        },
    ];
    const prefs = { defaultDailyBudget: 10000, pace: 'moderate' };
    const result = (0, optimiser_1.optimiseActivities)(activities, prefs);
    expect(result).toHaveLength(1);
    expect(result[0].activityId).toBe('solo');
});
//# sourceMappingURL=optimiser.test.js.map
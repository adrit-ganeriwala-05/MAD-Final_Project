// functions/src/optimiser/optimiser.test.ts

import {
  optimiseActivities,
  scoreBudget,
  scoreDistance,
  scoreTimeFit,
} from './optimiser';
import { Activity, UserPreferences } from '../types/models';

// ── scoreBudget ───────────────────────────────────────────────────────────────

test('scoreBudget returns 100 for free activity', () => {
  expect(scoreBudget(0, 10000)).toBe(100);
});

test('scoreBudget returns 0 for activity costing 3x daily budget', () => {
  expect(scoreBudget(30000, 10000)).toBe(0);
});

test('scoreBudget returns mid-range score for activity at daily budget', () => {
  // cost == dailyBudget → 100 * (1 - 1/2) = 50
  expect(scoreBudget(10000, 10000)).toBe(50);
});

// ── scoreTimeFit ──────────────────────────────────────────────────────────────

test('scoreTimeFit returns higher score for short activity with relaxed pace', () => {
  const shortScore = scoreTimeFit(60, 'relaxed');
  const longScore = scoreTimeFit(300, 'relaxed');
  expect(shortScore).toBeGreaterThan(longScore);
});

test('scoreTimeFit returns 100 for short moderate activity', () => {
  expect(scoreTimeFit(120, 'moderate')).toBe(100);
});

test('scoreTimeFit returns 0 for very long activity with relaxed pace', () => {
  expect(scoreTimeFit(500, 'relaxed')).toBe(0);
});

// ── scoreDistance ─────────────────────────────────────────────────────────────

test('scoreDistance returns 100 for single activity', () => {
  expect(scoreDistance(0, 0)).toBe(100);
});

// ── optimiseActivities ────────────────────────────────────────────────────────

test('optimiseActivities returns activities sorted by average score descending', () => {
  const activities: Activity[] = [
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
  const prefs: UserPreferences = {
    defaultDailyBudget: 10000,
    pace: 'moderate',
  };
  const result = optimiseActivities(activities, prefs);
  // Cheap/short should outscore expensive/long
  expect(result[0].activityId).toBe('2');
});

test('optimiseActivities handles empty array', () => {
  const prefs: UserPreferences = { defaultDailyBudget: 10000, pace: 'moderate' };
  expect(optimiseActivities([], prefs)).toEqual([]);
});

test('optimiseActivities handles single activity', () => {
  const activities: Activity[] = [
    {
      activityId: 'solo',
      title: 'Solo activity',
      estimatedCost: 5000,
      durationMinutes: 120,
      category: 'sightseeing',
      position: 1,
    },
  ];
  const prefs: UserPreferences = { defaultDailyBudget: 10000, pace: 'moderate' };
  const result = optimiseActivities(activities, prefs);
  expect(result).toHaveLength(1);
  expect(result[0].activityId).toBe('solo');
});

const { readFileSync } = require('fs');
const { resolve } = require('path');

const {
  initializeTestEnvironment,
  assertFails,
  assertSucceeds,
} = require('@firebase/rules-unit-testing');

const PROJECT_ID = 'tropicaguide-test';
const RULES_PATH = resolve(__dirname, '../../firebase/firestore.rules');

let testEnv;

beforeAll(async () => {
  testEnv = await initializeTestEnvironment({
    projectId: PROJECT_ID,
    firestore: {
      rules: readFileSync(RULES_PATH, 'utf8'),
      host: '127.0.0.1',
      port: 8080,
    },
  });
});

afterAll(async () => {
  await testEnv.cleanup();
});

afterEach(async () => {
  await testEnv.clearFirestore();
});

// ── Helper to seed a trip ────────────────────────────────────────────────────

async function seedTrip(tripId, memberIds, createdBy) {
  await testEnv.withSecurityRulesDisabled(async (context) => {
    await context.firestore().collection('trips').doc(tripId).set({
      title: 'Test Trip',
      memberIds,
      createdBy,
      status: 'planning',
      createdAt: new Date(),
      updatedAt: new Date(),
    });
  });
}

// ── Users collection ─────────────────────────────────────────────────────────

describe('users collection', () => {
  test('signed-in user can read any profile', async () => {
    const ctx = testEnv.authenticatedContext('alice');
    await assertSucceeds(
      ctx.firestore().collection('users').doc('bob').get()
    );
  });

  test('unauthenticated user cannot read profiles', async () => {
    const ctx = testEnv.unauthenticatedContext();
    await assertFails(
      ctx.firestore().collection('users').doc('alice').get()
    );
  });

  test('user can create their own profile', async () => {
    const ctx = testEnv.authenticatedContext('alice');
    await assertSucceeds(
      ctx.firestore().collection('users').doc('alice').set({
        uid: 'alice',
        email: 'alice@example.com',
        createdAt: new Date(),
        updatedAt: new Date(),
      })
    );
  });

  test('user cannot create another user profile', async () => {
    const ctx = testEnv.authenticatedContext('alice');
    await assertFails(
      ctx.firestore().collection('users').doc('bob').set({
        uid: 'bob',
        email: 'bob@example.com',
        createdAt: new Date(),
        updatedAt: new Date(),
      })
    );
  });
});

// ── Trips collection ─────────────────────────────────────────────────────────

describe('trips collection', () => {
  test('trip member can read trip', async () => {
    await seedTrip('trip1', ['alice'], 'alice');
    const ctx = testEnv.authenticatedContext('alice');
    await assertSucceeds(
      ctx.firestore().collection('trips').doc('trip1').get()
    );
  });

  test('non-member cannot read trip', async () => {
    await seedTrip('trip1', ['alice'], 'alice');
    const ctx = testEnv.authenticatedContext('bob');
    await assertFails(
      ctx.firestore().collection('trips').doc('trip1').get()
    );
  });

  test('signed-in user can create trip with themselves as member', async () => {
    const ctx = testEnv.authenticatedContext('alice');
    await assertSucceeds(
      ctx.firestore().collection('trips').doc('trip2').set({
        title: 'New Trip',
        memberIds: ['alice'],
        createdBy: 'alice',
        createdAt: new Date(),
        updatedAt: new Date(),
      })
    );
  });

  test('user cannot create trip without including themselves', async () => {
    const ctx = testEnv.authenticatedContext('alice');
    await assertFails(
      ctx.firestore().collection('trips').doc('trip3').set({
        title: 'Bad Trip',
        memberIds: ['bob'],
        createdBy: 'alice',
        createdAt: new Date(),
        updatedAt: new Date(),
      })
    );
  });

  test('only creator can delete trip', async () => {
    await seedTrip('trip1', ['alice', 'bob'], 'alice');
    const bobCtx = testEnv.authenticatedContext('bob');
    await assertFails(
      bobCtx.firestore().collection('trips').doc('trip1').delete()
    );
    const aliceCtx = testEnv.authenticatedContext('alice');
    await assertSucceeds(
      aliceCtx.firestore().collection('trips').doc('trip1').delete()
    );
  });
});

// ── Activities subcollection ─────────────────────────────────────────────────

describe('activities subcollection', () => {
  test('member can create activity', async () => {
    await seedTrip('trip1', ['alice'], 'alice');
    const ctx = testEnv.authenticatedContext('alice');
    await assertSucceeds(
      ctx.firestore()
        .collection('trips').doc('trip1')
        .collection('activities').doc('act1')
        .set({
          title: 'Snorkelling',
          proposedBy: 'alice',
          createdBy: 'alice',
          position: 1,
          createdAt: new Date(),
          updatedAt: new Date(),
        })
    );
  });

  test('non-member cannot read activities', async () => {
    await seedTrip('trip1', ['alice'], 'alice');
    const ctx = testEnv.authenticatedContext('bob');
    await assertFails(
      ctx.firestore()
        .collection('trips').doc('trip1')
        .collection('activities').doc('act1')
        .get()
    );
  });
});

// ── Checklist subcollection ──────────────────────────────────────────────────

describe('checklist subcollection', () => {
  test('member can create checklist item', async () => {
    await seedTrip('trip1', ['alice'], 'alice');
    const ctx = testEnv.authenticatedContext('alice');
    await assertSucceeds(
      ctx.firestore()
        .collection('trips').doc('trip1')
        .collection('checklist').doc('item1')
        .set({
          label: 'Sunscreen',
          isChecked: false,
          createdBy: 'alice',
          position: 1,
          createdAt: new Date(),
          updatedAt: new Date(),
        })
    );
  });

  test('non-member cannot toggle checklist item', async () => {
    await seedTrip('trip1', ['alice'], 'alice');
    const ctx = testEnv.authenticatedContext('bob');
    await assertFails(
      ctx.firestore()
        .collection('trips').doc('trip1')
        .collection('checklist').doc('item1')
        .update({ isChecked: true })
    );
  });
});
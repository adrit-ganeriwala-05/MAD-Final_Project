/**
 * Seed script for the Firebase Local Emulator Suite.
 *
 * Run with: node firebase/emulator/seed.js
 *
 * Populates:
 *   - 2 users (alice, bob)
 *   - 2 trips (alice owns both; bob is member of trip 2)
 *   - 3 activities on trip 1
 *   - 4 checklist items on trip 1
 *
 * Requires emulators to be running:
 *   firebase emulators:start --only auth,firestore,storage
 */

const { initializeApp } = require('firebase-admin/app');
const { getFirestore, Timestamp } = require('firebase-admin/firestore');
const { getAuth } = require('firebase-admin/auth');

process.env.FIRESTORE_EMULATOR_HOST = '127.0.0.1:8080';
process.env.FIREBASE_AUTH_EMULATOR_HOST = '127.0.0.1:9099';

initializeApp({ projectId: 'tropicaguide-adrit-2026' });

const db = getFirestore();
const auth = getAuth();

const now = Timestamp.now();

async function seed() {
  console.log('🌱 Seeding emulator...');

  // ── Create auth users ────────────────────────────────────────────────────
  let aliceUid, bobUid;

  try {
    const alice = await auth.createUser({
      email: 'alice@demo.com',
      password: 'demo1234',
      displayName: 'Alice Demo',
    });
    aliceUid = alice.uid;
    console.log(`✅ Created user alice → ${aliceUid}`);
  } catch (e) {
    if (e.code === 'auth/email-already-exists') {
      const alice = await auth.getUserByEmail('alice@demo.com');
      aliceUid = alice.uid;
      console.log(`ℹ️  alice already exists → ${aliceUid}`);
    } else throw e;
  }

  try {
    const bob = await auth.createUser({
      email: 'bob@demo.com',
      password: 'demo1234',
      displayName: 'Bob Demo',
    });
    bobUid = bob.uid;
    console.log(`✅ Created user bob → ${bobUid}`);
  } catch (e) {
    if (e.code === 'auth/email-already-exists') {
      const bob = await auth.getUserByEmail('bob@demo.com');
      bobUid = bob.uid;
      console.log(`ℹ️  bob already exists → ${bobUid}`);
    } else throw e;
  }

  // ── User profiles ────────────────────────────────────────────────────────
  await db.collection('users').doc(aliceUid).set({
    uid: aliceUid,
    email: 'alice@demo.com',
    displayName: 'Alice Demo',
    photoUrl: null,
    budgetCurrency: 'USD',
    defaultDailyBudget: 20000,
    travelPreferences: { pace: 'moderate', interests: ['beach', 'food'] },
    createdAt: now,
    updatedAt: now,
  });

  await db.collection('users').doc(bobUid).set({
    uid: bobUid,
    email: 'bob@demo.com',
    displayName: 'Bob Demo',
    photoUrl: null,
    budgetCurrency: 'USD',
    defaultDailyBudget: 15000,
    travelPreferences: { pace: 'relaxed', interests: ['culture', 'hiking'] },
    createdAt: now,
    updatedAt: now,
  });

  console.log('✅ User profiles written');

  // ── Trip 1 — Cancún (alice only) ─────────────────────────────────────────
  const trip1Ref = db.collection('trips').doc('trip-cancun-demo');
  await trip1Ref.set({
    tripId: 'trip-cancun-demo',
    title: 'Cancún Spring Break',
    destination: 'Cancún, Mexico',
    coverImagePath: 'assets/seed_images/destinations/cancun.jpg',
    startDate: Timestamp.fromDate(new Date('2026-06-01')),
    endDate: Timestamp.fromDate(new Date('2026-06-07')),
    totalBudget: 150000,
    currency: 'USD',
    memberIds: [aliceUid],
    memberProfiles: {
      [aliceUid]: { displayName: 'Alice Demo', photoUrl: null },
    },
    createdBy: aliceUid,
    optimisedOrder: [],
    status: 'planning',
    createdAt: now,
    updatedAt: now,
  });

  // Activities for trip 1
  const activities = [
    {
      id: 'act-snorkel',
      title: 'Snorkelling at Isla Mujeres',
      description: 'Crystal clear waters, stunning coral reefs.',
      category: 'adventure',
      locationName: 'Isla Mujeres',
      estimatedCost: 8000,
      durationMinutes: 240,
      imageAssetPath: 'assets/seed_images/activities/snorkel.jpg',
      position: 1,
      scoreDistance: 85,
      scoreBudget: 70,
      scoreTimeFit: 90,
    },
    {
      id: 'act-tacos',
      title: 'Street Tacos Tour',
      description: 'Local taco crawl through downtown Cancún.',
      category: 'food',
      locationName: 'Downtown Cancún',
      estimatedCost: 2000,
      durationMinutes: 90,
      imageAssetPath: 'assets/seed_images/activities/tacos.jpg',
      position: 2,
      scoreDistance: 60,
      scoreBudget: 95,
      scoreTimeFit: 80,
    },
    {
      id: 'act-chichen',
      title: 'Chichen Itza Day Trip',
      description: 'UNESCO world heritage site, guided tour.',
      category: 'sightseeing',
      locationName: 'Chichen Itza',
      estimatedCost: 12000,
      durationMinutes: 480,
      imageAssetPath: 'assets/seed_images/activities/chichen.jpg',
      position: 3,
      scoreDistance: 40,
      scoreBudget: 55,
      scoreTimeFit: 65,
    },
  ];

  for (const act of activities) {
    await trip1Ref.collection('activities').doc(act.id).set({
      ...act,
      proposedBy: aliceUid,
      createdBy: aliceUid,
      startTime: null,
      imageStorageUrl: null,
      createdAt: now,
      updatedAt: now,
    });
  }

  // Checklist for trip 1
  const checklistItems = [
    { id: 'item-sunscreen', label: 'Sunscreen SPF 50+', category: 'packing', position: 1 },
    { id: 'item-passport', label: 'Passport', category: 'document', position: 2 },
    { id: 'item-insurance', label: 'Travel insurance', category: 'document', position: 3 },
    { id: 'item-swimwear', label: 'Swimwear', category: 'packing', position: 4 },
  ];

  for (const item of checklistItems) {
    await trip1Ref.collection('checklist').doc(item.id).set({
      ...item,
      isChecked: false,
      assignedTo: null,
      dueDate: null,
      createdBy: aliceUid,
      createdAt: now,
      updatedAt: now,
    });
  }

  console.log('✅ Trip 1 (Cancún) seeded with activities and checklist');

  // ── Trip 2 — Bali (alice + bob) ──────────────────────────────────────────
  const trip2Ref = db.collection('trips').doc('trip-bali-demo');
  await trip2Ref.set({
    tripId: 'trip-bali-demo',
    title: 'Bali Retreat',
    destination: 'Bali, Indonesia',
    coverImagePath: 'assets/seed_images/destinations/bali.jpg',
    startDate: Timestamp.fromDate(new Date('2026-09-15')),
    endDate: Timestamp.fromDate(new Date('2026-09-22')),
    totalBudget: 200000,
    currency: 'USD',
    memberIds: [aliceUid, bobUid],
    memberProfiles: {
      [aliceUid]: { displayName: 'Alice Demo', photoUrl: null },
      [bobUid]: { displayName: 'Bob Demo', photoUrl: null },
    },
    createdBy: aliceUid,
    optimisedOrder: [],
    status: 'planning',
    createdAt: now,
    updatedAt: now,
  });

  console.log('✅ Trip 2 (Bali) seeded');
  console.log('');
  console.log('🎉 Seed complete!');
  console.log('   alice@demo.com / demo1234');
  console.log('   bob@demo.com   / demo1234');
  console.log('   Open http://localhost:4000 to inspect the data.');
}

seed().catch((err) => {
  console.error('❌ Seed failed:', err);
  process.exit(1);
});
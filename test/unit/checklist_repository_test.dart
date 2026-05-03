import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tropicaguide/features/checklist/data/checklist_repository.dart';

void main() {
  group('ChecklistRepository', () {
    late FakeFirebaseFirestore fakeFirestore;
    late ChecklistRepository repo;

    setUp(() {
      fakeFirestore = FakeFirebaseFirestore();
      repo = ChecklistRepository(fakeFirestore);
    });

    test('addItem creates a document in the checklist subcollection', () async {
      await repo.addItem(
        tripId: 'trip1',
        label: 'Sunscreen',
        category: 'packing',
        userId: 'user1',
      );
      final snap = await fakeFirestore
          .collection('trips')
          .doc('trip1')
          .collection('checklist')
          .get();
      expect(snap.docs.length, 1);
      expect(snap.docs.first.data()['label'], 'Sunscreen');
      expect(snap.docs.first.data()['isChecked'], false);
    });

    test('deleteItem removes a document', () async {
      await repo.addItem(
        tripId: 'trip1',
        label: 'Passport',
        category: 'document',
        userId: 'user1',
      );
      final snap = await fakeFirestore
          .collection('trips')
          .doc('trip1')
          .collection('checklist')
          .get();
      final itemId = snap.docs.first.id;
      await repo.deleteItem(tripId: 'trip1', itemId: itemId);
      final after = await fakeFirestore
          .collection('trips')
          .doc('trip1')
          .collection('checklist')
          .get();
      expect(after.docs.isEmpty, true);
    });

    test('checklistStream emits items in position order', () async {
      await repo.addItem(
        tripId: 'trip1',
        label: 'Item A',
        category: 'packing',
        userId: 'user1',
      );
      final stream = repo.checklistStream('trip1');
      final items = await stream.first;
      expect(items.length, 1);
      expect(items.first.label, 'Item A');
    });
  });
}

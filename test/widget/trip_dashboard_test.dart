import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tropicaguide/core/theme/app_theme.dart';
import 'package:tropicaguide/core/ui/empty_state.dart';
import 'package:tropicaguide/features/trips/domain/trip.dart';
import 'package:tropicaguide/features/trips/presentation/trip_dashboard_screen.dart';
import 'package:tropicaguide/features/trips/presentation/trips_notifier.dart';

void main() {
  group('TripDashboardScreen', () {
    testWidgets('shows empty state when trips list is empty', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            tripsStreamProvider.overrideWith(
              (ref) => Stream.value(<Trip>[]),
            ),
          ],
          child: MaterialApp(
            theme: AppTheme.light,
            home: const TripDashboardScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(EmptyState), findsOneWidget);
      expect(find.text('No trips yet'), findsOneWidget);
    });

    testWidgets('shows trip card when trips list has items', (tester) async {
      final trip = Trip(
        tripId: 'test-trip',
        title: 'Test Trip',
        destination: 'Bali',
        memberIds: const ['uid1'],
        createdBy: 'uid1',
        status: 'planning',
        totalBudget: 100000,
        currency: 'USD',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            tripsStreamProvider.overrideWith(
              (ref) => Stream.value([trip]),
            ),
          ],
          child: MaterialApp(
            theme: AppTheme.light,
            home: const TripDashboardScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Test Trip'), findsOneWidget);
      expect(find.text('Bali'), findsOneWidget);
    });
  });
}

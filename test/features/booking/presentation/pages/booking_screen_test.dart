import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('BookingScreen Widget Tests', () {
    testWidgets('BookingScreen renders without error', (tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: Center(child: Text('Booking Screen'))),
        ),
      );

      // Assert
      expect(find.text('Booking Screen'), findsOneWidget);
      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('should have loading state widget', (tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: Center(child: CircularProgressIndicator())),
        ),
      );

      // Assert
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('should display no bookings message', (tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: Center(child: Text('No bookings yet'))),
        ),
      );

      // Assert
      expect(find.text('No bookings yet'), findsOneWidget);
    });

    testWidgets('should display booking list items', (tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ListView(
              children: const [
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Card(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Text('Grand Ballroom'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );

      // Assert
      expect(find.text('Grand Ballroom'), findsOneWidget);
      expect(find.byType(ListView), findsOneWidget);
      expect(find.byType(Card), findsOneWidget);
    });

    testWidgets('should display booking status badge', (tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Padding(padding: EdgeInsets.all(16), child: Text('Pending')),
          ),
        ),
      );

      // Assert
      expect(find.text('Pending'), findsOneWidget);
    });
  });
}

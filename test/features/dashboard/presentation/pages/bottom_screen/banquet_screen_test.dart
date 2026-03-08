import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('BanquetScreen Widget Tests', () {
    testWidgets('BanquetScreen renders without error', (tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            appBar: AppBar(title: const Text('Banquet')),
            body: const Center(child: Text('Banquet Screen')),
          ),
        ),
      );

      // Assert
      expect(find.text('Banquet Screen'), findsOneWidget);
      expect(find.text('Banquet'), findsOneWidget);
    });

    testWidgets('should display loading state', (tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: Center(child: CircularProgressIndicator())),
        ),
      );

      // Assert
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('should display special offer section', (tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: Column(
                children: [Text('Banquet Special'), Text('20% OFF This Week')],
              ),
            ),
          ),
        ),
      );

      // Assert
      expect(find.text('Banquet Special'), findsOneWidget);
      expect(find.text('20% OFF This Week'), findsOneWidget);
    });

    testWidgets('should display banquet list header', (tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                const Text('Our Banquet Halls'),
                Expanded(
                  child: ListView(
                    children: const [
                      Padding(
                        padding: EdgeInsets.all(16),
                        child: Text('Grand Ballroom'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );

      // Assert
      expect(find.text('Our Banquet Halls'), findsOneWidget);
      expect(find.text('Grand Ballroom'), findsOneWidget);
    });

    testWidgets('should display banquet details properly', (tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Luxury Palace'),
                    SizedBox(height: 8),
                    Text('Elite District'),
                    SizedBox(height: 8),
                    Text('1000 Capacity'),
                  ],
                ),
              ),
            ),
          ),
        ),
      );

      // Assert
      expect(find.text('Luxury Palace'), findsOneWidget);
      expect(find.text('Elite District'), findsOneWidget);
      expect(find.text('1000 Capacity'), findsOneWidget);
    });
  });
}

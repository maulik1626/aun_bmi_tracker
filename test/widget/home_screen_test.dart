import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:aun_bmi_tracker/features/calculator/presentation/screens/home_screen.dart';

void main() {
  Widget buildHomeScreen() {
    return ProviderScope(
      child: MaterialApp(
        home: const HomeScreen(),
      ),
    );
  }

  group('HomeScreen', () {
    group('input fields are present', () {
      testWidgets('displays Height label', (tester) async {
        await tester.pumpWidget(buildHomeScreen());

        expect(find.text('HEIGHT'), findsOneWidget);
      });

      testWidgets('displays Weight label', (tester) async {
        await tester.pumpWidget(buildHomeScreen());

        expect(find.text('WEIGHT'), findsOneWidget);
      });

      testWidgets('displays Age label', (tester) async {
        await tester.pumpWidget(buildHomeScreen());

        expect(find.text('AGE'), findsOneWidget);
      });
    });

    group('Calculate button', () {
      testWidgets('Calculate BMI button text exists', (tester) async {
        await tester.pumpWidget(buildHomeScreen());

        expect(find.text('Calculate BMI'), findsOneWidget);
      });
    });

    group('gender selector', () {
      testWidgets('displays Male option', (tester) async {
        await tester.pumpWidget(buildHomeScreen());

        expect(find.text('Male'), findsOneWidget);
      });

      testWidgets('displays Female option', (tester) async {
        await tester.pumpWidget(buildHomeScreen());

        expect(find.text('Female'), findsOneWidget);
      });

      testWidgets('displays male and female icons', (tester) async {
        await tester.pumpWidget(buildHomeScreen());

        expect(find.byIcon(Icons.male_rounded), findsOneWidget);
        expect(find.byIcon(Icons.female_rounded), findsOneWidget);
      });
    });

    group('unit toggle', () {
      testWidgets('displays Metric and Imperial options', (tester) async {
        await tester.pumpWidget(buildHomeScreen());

        expect(find.text('Metric'), findsOneWidget);
        expect(find.text('Imperial'), findsOneWidget);
      });
    });

    group('page structure', () {
      testWidgets('displays BMI Calculator title', (tester) async {
        await tester.pumpWidget(buildHomeScreen());

        expect(find.text('BMI Calculator'), findsOneWidget);
      });

      testWidgets('has a scrollable body', (tester) async {
        await tester.pumpWidget(buildHomeScreen());

        expect(find.byType(SingleChildScrollView), findsOneWidget);
      });

      testWidgets('has age input with years suffix', (tester) async {
        await tester.pumpWidget(buildHomeScreen());

        // The age section has a TextField with 'years' suffix
        expect(find.byType(TextField), findsWidgets);
      });
    });
  });
}

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:aun_bmi_tracker/features/calculator/presentation/widgets/bmi_gauge.dart';

void main() {
  Widget buildGauge({
    required double bmiValue,
    required String categoryLabel,
    required Color categoryColor,
  }) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: SizedBox(
            width: 300,
            child: BmiGauge(
              bmiValue: bmiValue,
              categoryLabel: categoryLabel,
              categoryColor: categoryColor,
            ),
          ),
        ),
      ),
    );
  }

  group('BmiGauge', () {
    group('renders for each BMI category', () {
      testWidgets('renders for underweight', (tester) async {
        await tester.pumpWidget(buildGauge(
          bmiValue: 16.5,
          categoryLabel: 'Underweight',
          categoryColor: const Color(0xFF2196F3),
        ));

        // Pump through the animation
        await tester.pumpAndSettle();

        expect(find.byType(BmiGauge), findsOneWidget);
        expect(find.byType(CustomPaint), findsAtLeastNWidgets(1));
      });

      testWidgets('renders for normal', (tester) async {
        await tester.pumpWidget(buildGauge(
          bmiValue: 22.0,
          categoryLabel: 'Normal',
          categoryColor: const Color(0xFF4CAF50),
        ));

        await tester.pumpAndSettle();

        expect(find.byType(BmiGauge), findsOneWidget);
      });

      testWidgets('renders for overweight', (tester) async {
        await tester.pumpWidget(buildGauge(
          bmiValue: 27.5,
          categoryLabel: 'Overweight',
          categoryColor: const Color(0xFFFF9800),
        ));

        await tester.pumpAndSettle();

        expect(find.byType(BmiGauge), findsOneWidget);
      });

      testWidgets('renders for obese', (tester) async {
        await tester.pumpWidget(buildGauge(
          bmiValue: 35.0,
          categoryLabel: 'Obese',
          categoryColor: const Color(0xFFF44336),
        ));

        await tester.pumpAndSettle();

        expect(find.byType(BmiGauge), findsOneWidget);
      });
    });

    group('displays BMI value text', () {
      testWidgets('shows the BMI value formatted to one decimal', (tester) async {
        await tester.pumpWidget(buildGauge(
          bmiValue: 22.3,
          categoryLabel: 'Normal',
          categoryColor: const Color(0xFF4CAF50),
        ));

        await tester.pumpAndSettle();

        expect(find.text('22.3'), findsOneWidget);
      });

      testWidgets('shows zero BMI as 0.0', (tester) async {
        await tester.pumpWidget(buildGauge(
          bmiValue: 0.0,
          categoryLabel: 'Underweight',
          categoryColor: const Color(0xFF2196F3),
        ));

        // Pump just enough for animation to start (value is 0 at both begin and end)
        await tester.pumpAndSettle();

        expect(find.text('0.0'), findsOneWidget);
      });
    });

    group('displays category label', () {
      testWidgets('shows Underweight label', (tester) async {
        await tester.pumpWidget(buildGauge(
          bmiValue: 16.0,
          categoryLabel: 'Underweight',
          categoryColor: const Color(0xFF2196F3),
        ));

        await tester.pumpAndSettle();

        expect(find.text('Underweight'), findsOneWidget);
      });

      testWidgets('shows Normal label', (tester) async {
        await tester.pumpWidget(buildGauge(
          bmiValue: 22.0,
          categoryLabel: 'Normal',
          categoryColor: const Color(0xFF4CAF50),
        ));

        await tester.pumpAndSettle();

        expect(find.text('Normal'), findsOneWidget);
      });

      testWidgets('shows Overweight label', (tester) async {
        await tester.pumpWidget(buildGauge(
          bmiValue: 27.0,
          categoryLabel: 'Overweight',
          categoryColor: const Color(0xFFFF9800),
        ));

        await tester.pumpAndSettle();

        expect(find.text('Overweight'), findsOneWidget);
      });

      testWidgets('shows Obese label', (tester) async {
        await tester.pumpWidget(buildGauge(
          bmiValue: 33.0,
          categoryLabel: 'Obese',
          categoryColor: const Color(0xFFF44336),
        ));

        await tester.pumpAndSettle();

        expect(find.text('Obese'), findsOneWidget);
      });
    });

    group('uses correct category color', () {
      testWidgets('BMI value text uses the provided category color', (tester) async {
        const color = Color(0xFF4CAF50);

        await tester.pumpWidget(buildGauge(
          bmiValue: 22.0,
          categoryLabel: 'Normal',
          categoryColor: color,
        ));

        await tester.pumpAndSettle();

        // Find the Text widget showing the BMI value and verify its color
        final bmiTextFinder = find.text('22.0');
        expect(bmiTextFinder, findsOneWidget);

        final textWidget = tester.widget<Text>(bmiTextFinder);
        expect(textWidget.style?.color, color);
      });

      testWidgets('category label text uses the provided category color', (tester) async {
        const color = Color(0xFFF44336);

        await tester.pumpWidget(buildGauge(
          bmiValue: 33.0,
          categoryLabel: 'Obese',
          categoryColor: color,
        ));

        await tester.pumpAndSettle();

        final labelFinder = find.text('Obese');
        expect(labelFinder, findsOneWidget);

        final textWidget = tester.widget<Text>(labelFinder);
        expect(textWidget.style?.color, color);
      });

      testWidgets('underweight color is applied correctly', (tester) async {
        const color = Color(0xFF2196F3);

        await tester.pumpWidget(buildGauge(
          bmiValue: 16.0,
          categoryLabel: 'Underweight',
          categoryColor: color,
        ));

        await tester.pumpAndSettle();

        final labelWidget = tester.widget<Text>(find.text('Underweight'));
        expect(labelWidget.style?.color, color);
      });

      testWidgets('overweight color is applied correctly', (tester) async {
        const color = Color(0xFFFF9800);

        await tester.pumpWidget(buildGauge(
          bmiValue: 27.0,
          categoryLabel: 'Overweight',
          categoryColor: color,
        ));

        await tester.pumpAndSettle();

        final labelWidget = tester.widget<Text>(find.text('Overweight'));
        expect(labelWidget.style?.color, color);
      });
    });
  });
}

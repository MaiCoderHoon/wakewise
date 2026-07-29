import 'package:flutter_test/flutter_test.dart';
import 'package:wakewise/main.dart';

void main() {
  testWidgets('WakeWise App renders design system showcase screen', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const WakewiseApp());
    await tester.pumpAndSettle();

    // Verify title text is present
    expect(find.text('WakeWise'), findsOneWidget);
    expect(find.text('Good Morning, Alex'), findsOneWidget);

    // Verify buttons are rendered
    expect(find.text('Set New AI Alarm (Clicks: 0)'), findsOneWidget);
  });
}

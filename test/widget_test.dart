import 'package:flutter_test/flutter_test.dart';

import 'package:glim/main.dart';

void main() {
  testWidgets('App launches smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const GlimApp());
    // App should launch without errors
    expect(find.text('Glim'), findsNothing);
  });
}

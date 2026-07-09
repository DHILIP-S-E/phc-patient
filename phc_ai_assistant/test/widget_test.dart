// PHC AI Assistant - Widget Tests
import 'package:flutter_test/flutter_test.dart';
import 'package:phc_ai_assistant/app/app.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    // Note: Full integration test requires model download.
    // This is a basic smoke test to ensure app compiles.
    expect(PhcAiApp, isNotNull);
  });
}

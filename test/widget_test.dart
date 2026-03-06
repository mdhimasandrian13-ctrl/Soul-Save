import 'package:flutter_test/flutter_test.dart';
import 'package:soul_save/main.dart';

void main() {
  testWidgets('Soul Save smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const SoulSaveApp());
  });
}
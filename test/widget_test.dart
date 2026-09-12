import 'package:flutter_test/flutter_test.dart';
import 'package:itantra/main.dart';

void main() {
  testWidgets('iTantra App loads successfully', (WidgetTester tester) async {
    await tester.pumpWidget(const ITantraApp());
    expect(find.textContaining('iTantra'), findsWidgets);
  });
}

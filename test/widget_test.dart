import 'package:flutter_test/flutter_test.dart';
import 'package:fajr/main.dart';

void main() {
  testWidgets('App renders without crashing', (WidgetTester tester) async {
    await tester.pumpWidget(const FajrApp());
    expect(find.text('Fajr'), findsOneWidget);
  });
}

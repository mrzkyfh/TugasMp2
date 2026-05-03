import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:fluenta/main.dart';

void main() {
  testWidgets('App renders splash and navigates to auth', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const ProviderScope(child: FluentaApp()));

    expect(find.byKey(const ValueKey('fluenta-logo')), findsOneWidget);

    await tester.pump(const Duration(seconds: 2));
    await tester.pump();

    expect(find.text('Learn a language for free.\nForever.'), findsOneWidget);
  });
}

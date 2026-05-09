import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:fluenta/main.dart';

void main() {
  testWidgets('App renders splash and navigates to auth', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: FluentaApp()));

    expect(find.byKey(const ValueKey('fluenta-logo')), findsOneWidget);
    expect(find.text('Fluenta'), findsOneWidget);
    expect(find.text('Mulai Sekarang'), findsOneWidget);

    await tester.tap(find.text('Mulai Sekarang'));
    await tester.pumpAndSettle();

    expect(find.text('Siapa nama kamu?'), findsOneWidget);
  });
}

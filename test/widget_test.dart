import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:delivery/main.dart';
import 'package:delivery/sign_in_screen.dart';

void main() {
  testWidgets('App starts and shows Sign In screen', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that the SignInScreen is present.
    expect(find.byType(SignInScreen), findsOneWidget);

    // Verify that the "Sign In" button is visible.
    expect(find.byType(ElevatedButton), findsOneWidget);
  });
}
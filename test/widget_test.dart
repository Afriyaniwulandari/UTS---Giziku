import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:demo/main.dart';

void main() {
  testWidgets('Aplikasi GiziKu berjalan tanpa error', (
    WidgetTester tester,
  ) async {
    // Jalankan aplikasi utama
    await tester.pumpWidget(const GiziAmanApp());

    // Pastikan widget utama (MaterialApp) muncul
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}

import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hospital/finance/Payments.dart';
import 'package:hospital/finance/salary_charge.dart';
import 'package:hospital/lab/samples.dart';
import 'package:hospital/screens/Home.dart';
import 'package:hospital/screens/doctor_schedule_info.dart';
import 'package:hospital/screens/patients/widgets/Idcard.dart';
import 'package:hospital/screens/schedule.dart';

final theme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    brightness: Brightness.light,
    seedColor: const Color.fromARGB(255, 120, 33, 243),
  ),
  textTheme: GoogleFonts.latoTextTheme(),
);

void main() {
  runApp(
    const ProviderScope(child: MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Hospital system',
    theme: theme,
      home: Home()
    );
  }
}




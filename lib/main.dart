import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:we_teach/presentation/features/auth/signup/provider/auth_provider.dart';
import 'package:we_teach/presentation/features/profile/change_password/provider/change_password_provider.dart';
import 'package:we_teach/presentation/features/auth/onboarding/screens/onboarding_screen.dart';
import 'package:we_teach/presentation/features/profile/manage_profile/provider/manage_profile_provider.dart';
import 'package:we_teach/presentation/features/profile/payment/provider/payment_provider.dart';
import 'package:we_teach/presentation/features/profile/payment/screens/add_payment_option%20screen.dart';
import 'package:we_teach/presentation/features/profile/payment/screens/payment_options_screen.dart';
import 'package:we_teach/presentation/features/profile/personal_info/provider/personal_info_provider.dart';
import 'package:we_teach/presentation/features/profile/professional_details/provider/professional_details_provider.dart';
import 'package:we_teach/presentation/features/profile/shared/widgets/payment_card.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ChangePasswordProvider()),
        ChangeNotifierProvider(create: (_) => UserProfileProvider()),
        ChangeNotifierProvider(create: (_) => PersonalInfoProvider()),
        ChangeNotifierProvider(create: (_) => ProfessionalInfoProvider()),
        ChangeNotifierProvider(create: (_) => PaymentProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: OnboardingScreen(),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:we_teach/presentation/features/auth/forgot_password/screens/forgot_password_screen.dart';
import 'package:we_teach/presentation/features/auth/profile/screens/account_profile.dart';
import 'package:we_teach/presentation/features/auth/profile/screens/add_location.dart';
import 'package:we_teach/presentation/features/auth/profile/screens/add_profile_pic.dart';
import 'package:we_teach/presentation/features/auth/profile/screens/add_qualifications.dart';
import 'package:we_teach/presentation/features/auth/profile/screens/finished_profile.dart';
import 'package:we_teach/presentation/features/auth/profile/screens/profile_popup.dart';
import 'package:we_teach/presentation/features/auth/signin/screens/signin_number.dart';
import 'package:we_teach/presentation/features/auth/signin/screens/signin_screen.dart';
import 'package:we_teach/presentation/features/auth/signup/provider/auth_provider.dart';
import 'package:we_teach/presentation/features/auth/signup/screens/create_password_screen.dart';
import 'package:we_teach/presentation/features/auth/signup/screens/otp_screen.dart';
import 'package:we_teach/presentation/features/auth/signup/screens/signup_number.dart';
import 'package:we_teach/presentation/features/home/home_screen/provider/job_details_provider.dart';
import 'package:we_teach/presentation/features/home/home_screen/provider/save_job_provider.dart';
import 'package:we_teach/presentation/features/home/home_screen/provider/user_details_provider.dart';
import 'package:we_teach/presentation/features/home/home_screen/screens/home_screen.dart';
import 'package:we_teach/presentation/features/jobs/provider/view_job_provider.dart';
import 'package:we_teach/presentation/features/live_profile/provider/live_profile_provider.dart';
import 'package:we_teach/presentation/features/live_profile/provider/profile_details_provider.dart';
import 'package:we_teach/presentation/features/my_jobs/provider/my_jobs_provider.dart';
import 'package:we_teach/presentation/features/notifications/provider/notifications_provider.dart';
import 'package:we_teach/presentation/features/payment/provider/job_payment_provider.dart';
import 'package:we_teach/presentation/features/profile/change_password/provider/change_password_provider.dart';
import 'package:we_teach/presentation/features/auth/onboarding/screens/onboarding_screen.dart';
import 'package:we_teach/presentation/features/auth/signup/screens/create_account_screen.dart';
import 'package:we_teach/presentation/features/profile/manage_profile/provider/manage_profile_provider.dart';
import 'package:we_teach/presentation/features/profile/payment/provider/payment_provider.dart';
import 'package:we_teach/presentation/features/profile/personal_info/provider/personal_info_provider.dart';
import 'package:we_teach/presentation/features/profile/professional_details/provider/professional_details_provider.dart';
import 'package:we_teach/presentation/features/publicity_history/provider/publicity_history_provider.dart';
import 'package:we_teach/presentation/features/school/provider/school_photos_provider.dart';
import 'package:we_teach/presentation/features/school/provider/view_school_provider.dart';
import 'package:we_teach/presentation/features/search/provider/job_search_provider.dart';
import 'package:we_teach/presentation/theme/theme.dart';
import 'package:we_teach/services/local_notification_service.dart';
import 'package:we_teach/services/secure_storage_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  LocalNotificationService.initialize();
  final SecureStorageService secureStorageService = SecureStorageService();
  final String? lastVisitedScreen =
      await secureStorageService.getLastVisitedScreen();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ChangePasswordProvider()),
        ChangeNotifierProvider(create: (_) => UserProfileProvider()),
        ChangeNotifierProvider(create: (_) => PersonalInfoProvider()),
        ChangeNotifierProvider(create: (_) => ProfessionalInfoProvider()),
        ChangeNotifierProvider(create: (_) => PaymentProvider()),
        ChangeNotifierProvider(create: (_) => UserDetailsProvider()),
        ChangeNotifierProvider(create: (_) => JobDetailsProvider()),
        ChangeNotifierProvider(create: (_) => JobPaymentProvider()),
        ChangeNotifierProvider(create: (_) => ViewJobProvider()),
        ChangeNotifierProvider(create: (_) => ViewSchoolProvider()),
        ChangeNotifierProvider(create: (_) => SchoolPhotosProvider()),
        ChangeNotifierProvider(create: (_) => JobSaveProvider()),
        ChangeNotifierProvider(create: (_) => MyJobsProvider()),
        ChangeNotifierProvider(create: (_) => ProfileDetailsProvider()),
        ChangeNotifierProvider(create: (_) => LiveProfileProvider()),
        ChangeNotifierProvider(create: (_) => PublicityHistoryProvider()),
        ChangeNotifierProvider(create: (_) => JobSearchProvider()),
        ChangeNotifierProvider(create: (_) => NotificationsProvider()),
      ],
      child: MyApp(lastVisitedScreen: lastVisitedScreen),
    ),
  );
}

class MyApp extends StatelessWidget {
  final String? lastVisitedScreen;

  const MyApp({super.key, this.lastVisitedScreen});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme, // Set the theme
      home: _getInitialScreen(),
    );
  }

  Widget _getInitialScreen() {
    switch (lastVisitedScreen) {
      case 'CreateAccountScreen':
        return const CreateAccountScreen();
      case 'SignupNumberScreen':
        return const SignupNumberScreen();
      case 'SignInScreen':
        return const SignInScreen();
      case 'SignInNumberScreen':
        return const SignInNumberScreen();
      case 'ForgotPasswordScreen':
        return const ForgotPasswordScreen();
      case 'HomeScreen': // Added case for HomeScreen
        return const HomeScreen(); // Added line to return HomeScreen
      case 'OtpVerificationScreen': // Added case for OtpVerificationScreen
        return FutureBuilder<String?>(
          future: SecureStorageService()
              .getEmail(), // Retrieve email from secure storage
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return const Center(child: Text("Error loading email"));
            } else {
              return OtpVerificationScreen(
                isFromSignIn: false, // Adjust based on your logic
                email: snapshot.data, // Pass the retrieved email
                phoneNumber:
                    null, // Pass the appropriate phone number if needed
              );
            }
          },
        );
      case 'CreatePasswordScreen': // Added case for CreatePasswordScreen
        return FutureBuilder<int?>(
          future: SecureStorageService()
              .getOtpCode(), // Retrieve OTP from secure storage
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return const Center(child: Text("Error loading OTP"));
            } else {
              return CreatePasswordScreen(
                isFromSignup: true, // Adjust based on your logic
                //otp: snapshot.data ?? 0, // Pass the retrieved OTP, default to 0 if null
              );
            }
          },
        );
      case 'AccountProfileScreen':
        // Use FutureBuilder to get the user ID from secure storage
        return FutureBuilder<int?>(
          future: SecureStorageService().getUserId(), // Retrieve user ID
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return const Center(child: Text("Error loading user ID"));
            } else {
              return AccountProfileScreen(); // Pass the user ID if needed
            }
          },
        );
      case 'AddProfilePhotoScreen':
        return const AddProfilePhotoScreen();
      case 'QualificationsScreen': // Add this case for QualificationsScreen
        return const QualificationsScreen();
      case 'AddLocationScreen': // Add this case for QualificationsScreen
        return const AddLocationScreen();
      case 'ProfileCompleteScreen': // Add this case for ProfileCompleteScreen
        return const ProfileCompleteScreen(); // Navigate to ProfileCompleteScreen
      case 'ProfilePopup': // Add this case for ProfilePopup
        return const ProfilePopup(); // Navigate to ProfilePopup
      default:
        return const OnboardingScreen();
    }
  }
}

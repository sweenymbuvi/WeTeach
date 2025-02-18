import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:we_teach/presentation/features/auth/signin/screens/signin_screen.dart';
import 'package:we_teach/presentation/features/auth/signup/screens/create_account_screen.dart';
import 'package:we_teach/presentation/shared/widgets/my_button.dart';
import 'package:we_teach/presentation/shared/widgets/stat_widget.dart';
import 'package:we_teach/presentation/theme/theme.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              const Spacer(),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'Welcome',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'We connect skilled professionals to\npurpose-led institutions',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              const Spacer(),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Color(0xFFC9C9C9)),
                  color: Colors.white,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 32.0,
                      horizontal: 16.0), // Increased horizontal padding
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment
                            .spaceEvenly, // Push content to the right
                        children: [
                          Expanded(
                            child: StatWidget(
                              iconPath: SvgPicture.asset(
                                'assets/svg/school.svg',
                                height: 24.0,
                              ),
                              value: '4,004',
                              label: 'Schools on Platform',
                            ),
                          ),
                          const SizedBox(width: 20), // Space between widgets
                          Expanded(
                            child: StatWidget(
                              iconPath: SvgPicture.asset(
                                'assets/svg/briefcase.svg',
                                height: 24.0,
                              ),
                              value: '24,804',
                              label: 'Jobs Posted',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      const SizedBox(width: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment
                            .spaceEvenly, // Push content to the right
                        children: [
                          Expanded(
                            child: StatWidget(
                              iconPath: SvgPicture.asset(
                                'assets/svg/user.svg',
                                height: 24.0,
                              ),
                              value: '16,288',
                              label: 'Teachers on Platform',
                            ),
                          ),
                          const SizedBox(width: 20), // Space between widgets
                          Expanded(
                            child: StatWidget(
                              iconPath: SvgPicture.asset(
                                'assets/svg/handshake.svg',
                                height: 24.0,
                              ),
                              value: '22,012',
                              label: 'Jobs Matched',
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 40),
              CustomButton(
                text: 'Get Started',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CreateAccountScreen(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Already have an account?',
                    style: TextStyle(color: Colors.grey),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SignInScreen(),
                        ),
                      );
                    },
                    child: const Text(
                      'Sign In',
                      style: TextStyle(color: AppTheme.primaryColor),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

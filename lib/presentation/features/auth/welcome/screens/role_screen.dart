import 'package:flutter/material.dart';
import 'package:we_teach/presentation/features/auth/signup/screens/create_account_screen.dart';
import 'package:we_teach/presentation/shared/widgets/role_card_widget.dart';

class RoleScreen extends StatefulWidget {
  const RoleScreen({super.key});

  @override
  _RoleScreenState createState() => _RoleScreenState();
}

class _RoleScreenState extends State<RoleScreen> {
  String selectedRole = "Teacher";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.blue),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              Text(
                "Create Account As a",
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              RoleCard(
                title: "Teacher",
                description:
                    "View open job opportunities suited for what you are good at",
                isSelected: selectedRole == "Teacher",
                onTap: () {
                  setState(() {
                    selectedRole = "Teacher";
                  });
                },
              ),
              const SizedBox(height: 12),
              RoleCard(
                title: "School",
                description:
                    "Post job openings and view teachers on platform matching your needs",
                isSelected: selectedRole == "School",
                onTap: () {
                  setState(() {
                    selectedRole = "School";
                  });
                },
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CreateAccountScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const SizedBox(
                  width: double.infinity,
                  child: Text(
                    'Continue',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}

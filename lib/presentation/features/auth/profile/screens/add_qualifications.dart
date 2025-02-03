import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:we_teach/presentation/features/auth/profile/screens/add_location.dart';
import 'package:we_teach/presentation/features/auth/welcome/widgets/my_button.dart';
import 'package:provider/provider.dart';
import 'package:we_teach/presentation/features/auth/signup/provider/auth_provider.dart';

class QualificationsScreen extends StatefulWidget {
  const QualificationsScreen({super.key});

  @override
  _QualificationsScreenState createState() => _QualificationsScreenState();
}

class _QualificationsScreenState extends State<QualificationsScreen> {
  final List<String> selectedSubjects = [];
  List<Map<String, dynamic>> subjectCategories =
      []; // Store subject categories fetched from API
  Map<String, int> subjectIdMapping = {}; // Mapping of subject names to IDs

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchSubjectCategories();
    });
  }

  Future<void> _fetchSubjectCategories() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final categories = await authProvider.fetchSubjectCategories();

    setState(() {
      subjectCategories =
          categories; // Update the state with fetched categories

      // Create a mapping of subject names to IDs
      subjectIdMapping = {};
      for (var category in categories) {
        for (var subject in category['subjects']) {
          subjectIdMapping[subject['name']] = subject['id'];
        }
      }
    });
  }

  void _onSubjectSelected(String subject, bool isSelected) {
    setState(() {
      if (isSelected) {
        selectedSubjects.add(subject);
      } else {
        selectedSubjects.remove(subject);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    const currentPage = 2; // Adjust this as per your logic for tracking pages

    // Define the desired order of categories
    final List<String> categoryOrder = [
      "Languages",
      "Sciences",
      "Humanities",
      "Applied Technical",
      "Others"
    ];

    // Sort subject categories based on the predefined order
    List<Map<String, dynamic>> sortedCategories = [];
    for (var categoryName in categoryOrder) {
      final category = subjectCategories.firstWhere(
        (cat) => cat['name'] == categoryName,
        orElse: () => {}, // Return an empty map instead of null
      );
      if (category.isNotEmpty) {
        // Check if the category is not empty
        sortedCategories.add(category);
      }
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            pinned: true,
            floating: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              Padding(
                padding: EdgeInsets.only(
                  right: screenWidth * 0.04,
                  top: screenHeight * 0.02,
                ),
                child: Row(
                  children: List.generate(4, (index) {
                    return Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: screenWidth * 0.01),
                      width: screenWidth * 0.025,
                      height: screenWidth * 0.025,
                      decoration: BoxDecoration(
                        color: index <= currentPage
                            ? const Color(0xFFAC00E6)
                            : const Color(0xFFF0F0F0),
                        shape: BoxShape.circle,
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Add your Qualifications",
                        style: GoogleFonts.inter(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 16),
                      RichText(
                        text: TextSpan(
                          text: "Select your subject(s) ",
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                          children: [
                            TextSpan(
                              text: "*",
                              style: GoogleFonts.inter(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.red,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Kindly select only the subjects you are professionally trained to teach in a high school and can prove by certification.",
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF7D7D7D),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Display subjects by sorted category
                      for (var category in sortedCategories)
                        SubjectCategory(
                          title: category['name'], // Category name
                          subjects: category['subjects']
                              .map<String>((subject) => subject['name']
                                  as String) // Ensure the type is String
                              .toList(), // List of subject names
                          selectedSubjects: selectedSubjects,
                          onSelectionChanged: _onSubjectSelected,
                        ),
                      const SizedBox(height: 24),
                      CustomButton(
                        onPressed: selectedSubjects.isNotEmpty
                            ? () async {
                                final authProvider = Provider.of<AuthProvider>(
                                    context,
                                    listen: false);
                                int userId = authProvider
                                    .userId!; // Ensure userId is available

                                // Convert selected subjects to qualification IDs
                                List<int> selectedQualificationIds =
                                    selectedSubjects.map((subject) {
                                  return subjectIdMapping[
                                      subject]!; // Get the corresponding ID
                                }).toList();

                                // Call the updateTeacherProfile method
                                final success =
                                    await authProvider.updateTeacherProfile(
                                  userId: userId,
                                  qualifications:
                                      selectedQualificationIds, // Pass the selected qualifications
                                );

                                if (success) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            AddLocationScreen()),
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                          "Failed to update qualifications."),
                                    ),
                                  );
                                }
                              }
                            : null, // Disables button if no subjects are selected
                        text: "Finish",
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SubjectCategory extends StatelessWidget {
  final String title;
  final List<String> subjects;
  final List<String> selectedSubjects;
  final Function(String, bool) onSelectionChanged;

  const SubjectCategory({
    required this.title,
    required this.subjects,
    required this.selectedSubjects,
    required this.onSelectionChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1F1F1F),
          ),
        ),
        const SizedBox(height: 8), // Add some space after the title
        Divider(
          color: const Color(0xFFEBEBEB),
          thickness: 1,
        ), // Divider after the title
        const SizedBox(height: 8), // Add some space before the subjects
        Wrap(
          spacing: 12.0,
          runSpacing: 8.0,
          children: subjects.map((subject) {
            final isSelected = selectedSubjects.contains(subject);
            return GestureDetector(
              onTap: () {
                onSelectionChanged(subject, !isSelected);
              },
              child: Chip(
                label: Text(
                  subject,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: isSelected ? Color(0xFFAC00E6) : Color(0xFF333333),
                  ),
                ),
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                  side: BorderSide(
                    color: isSelected ? Color(0xFFAC00E6) : Color(0xFFF5F5F5),
                    width: 1.0,
                  ),
                ),
                deleteIcon: isSelected
                    ? Icon(Icons.close, size: 16, color: Color(0xFFAC00E6))
                    : null,
                onDeleted: isSelected
                    ? () => onSelectionChanged(subject, false)
                    : null,
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 16), // Add some space after the subjects
      ],
    );
  }
}

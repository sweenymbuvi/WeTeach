import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:we_teach/presentation/features/auth/profile/screens/add_location.dart';
import 'package:we_teach/presentation/features/auth/welcome/widgets/my_button.dart';

class QualificationsScreen extends StatelessWidget {
  const QualificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    const currentPage = 2; // Adjust this as per your logic for tracking pages

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            pinned: false,
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
                        color: index <=
                                currentPage // Fill bubbles for index 0 and 1
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
                      SubjectCategory(
                        title: "Languages",
                        subjects: [
                          "English",
                          "Kiswahili",
                          "French",
                          "Chinese",
                          "German",
                        ],
                        selectedSubjects: ["English", "Kiswahili"],
                      ),
                      const SizedBox(height: 16),
                      SubjectCategory(
                        title: "Sciences",
                        subjects: [
                          "Math",
                          "Physics",
                          "Chemistry",
                          "Biology",
                          "Home Science",
                          "Computer Studies",
                        ],
                      ),
                      const SizedBox(height: 16),
                      SubjectCategory(
                        title: "Humanities",
                        subjects: [
                          "Geography",
                          "History",
                        ],
                      ),
                      const SizedBox(height: 24),
                      Text(
                        "Additional Skills",
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF1F1F1F),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Kindly select any other extra-curricular skills you might have. These are not compulsory.",
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF7D7D7D),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Divider(
                        color: const Color(0xFFEBEBEB),
                        thickness: 1,
                      ),
                      const SizedBox(height: 16),
                      SkillCategory(
                        skills: [
                          "Games Coaching",
                          "Music and Arts",
                          "Computer Studies",
                          "Special Needs",
                        ],
                      ),
                      const SizedBox(height: 24),
                      CustomButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AddLocationScreen(),
                            ),
                          );
                        },
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

class SubjectCategory extends StatefulWidget {
  final String title;
  final List<String> subjects;
  final List<String> selectedSubjects;

  const SubjectCategory({
    required this.title,
    required this.subjects,
    this.selectedSubjects = const [],
    super.key,
  });

  @override
  _SubjectCategoryState createState() => _SubjectCategoryState();
}

class _SubjectCategoryState extends State<SubjectCategory> {
  late List<String> selectedSubjects;

  @override
  void initState() {
    super.initState();
    selectedSubjects = List.from(widget.selectedSubjects);
  }

  void _toggleSelection(String subject) {
    setState(() {
      if (selectedSubjects.contains(subject)) {
        selectedSubjects.remove(subject);
      } else {
        selectedSubjects.add(subject);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.title,
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1F1F1F),
          ),
        ),
        SizedBox(height: 8),
        Divider(
          color: const Color(0xFFEBEBEB),
          thickness: 1,
        ),
        SizedBox(height: 8),
        Wrap(
          spacing: 12.0,
          runSpacing: 8.0,
          children: widget.subjects.map((subject) {
            final isSelected = selectedSubjects.contains(subject);
            return GestureDetector(
              onTap: () => _toggleSelection(subject),
              child: Chip(
                label: Text(
                  subject,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: isSelected ? Color(0xFFAC00E6) : Color(0xFF333333),
                  ),
                ),
                backgroundColor: isSelected ? Colors.white : Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                  side: BorderSide(
                    color: isSelected ? Color(0xFFAC00E6) : Color(0xFFF5F5F5),
                    width: 1.0,
                  ),
                ),
                deleteIcon: isSelected
                    ? Icon(
                        Icons.close,
                        size: 16,
                        color: Color(0xFFAC00E6),
                      )
                    : null,
                onDeleted: isSelected ? () => _toggleSelection(subject) : null,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class SkillCategory extends StatefulWidget {
  final List<String> skills;

  const SkillCategory({required this.skills, super.key});

  @override
  _SkillCategoryState createState() => _SkillCategoryState();
}

class _SkillCategoryState extends State<SkillCategory> {
  late List<String> selectedSkills;

  @override
  void initState() {
    super.initState();
    selectedSkills = [];
  }

  void _toggleSelection(String skill) {
    setState(() {
      if (selectedSkills.contains(skill)) {
        selectedSkills.remove(skill);
      } else {
        selectedSkills.add(skill);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12.0,
      runSpacing: 8.0,
      children: widget.skills.map((skill) {
        final isSelected = selectedSkills.contains(skill);
        return GestureDetector(
          onTap: () => _toggleSelection(skill),
          child: Chip(
            label: Text(
              skill,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: isSelected ? Color(0xFFAC00E6) : Color(0xFF333333),
              ),
            ),
            backgroundColor: isSelected ? Colors.white : Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24.0),
              side: BorderSide(
                color: isSelected ? Color(0xFFAC00E6) : Color(0xFFF5F5F5),
                width: 1.0,
              ),
            ),
            deleteIcon: isSelected
                ? Icon(
                    Icons.close,
                    size: 16,
                    color: Color(0xFFAC00E6),
                  )
                : null,
            onDeleted: isSelected ? () => _toggleSelection(skill) : null,
          ),
        );
      }).toList(),
    );
  }
}

class SkillChip extends StatelessWidget {
  final String label;

  const SkillChip({required this.label, super.key});

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(
        label,
        style: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: Color(0xFF333333),
        ),
      ),
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24.0),
        side: BorderSide(color: Color(0xFFF5F5F5), width: 1.0),
      ),
    );
  }
}

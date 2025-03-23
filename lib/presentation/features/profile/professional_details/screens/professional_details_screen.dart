import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:we_teach/gen/assets.gen.dart';
import 'package:we_teach/presentation/features/profile/shared/widgets/action_buttons.dart';
import 'package:we_teach/presentation/features/profile/shared/widgets/profile_card.dart';
import 'package:we_teach/presentation/features/profile/shared/widgets/text_field.dart';
import 'package:we_teach/presentation/features/profile/professional_details/provider/professional_details_provider.dart';

class ProfessionalDetailsScreen extends StatefulWidget {
  @override
  State<ProfessionalDetailsScreen> createState() =>
      _ProfessionalDetailsScreenState();
}

class _ProfessionalDetailsScreenState extends State<ProfessionalDetailsScreen> {
  bool isLoading = false; // Add loading state
  final TextEditingController institutionLevelController =
      TextEditingController();
  final TextEditingController teachingExperienceController =
      TextEditingController();
  final TextEditingController additionalSkillsController =
      TextEditingController();

  String? selectedLevel;
  final Map<String, int> institutionLevels = {
    'ECDE': 1,
    'Primary School': 2,
    'High School': 3,
    'Junior Secondary': 4,
  };

  List<String> subjectsTaught = []; // List to hold subjects taught
  Map<String, int> subjectIdMapping = {}; // Mapping of subject names to IDs

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  void _initializeData() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final provider =
          Provider.of<ProfessionalInfoProvider>(context, listen: false);
      await provider.fetchPersonalInfo();

      if (provider.userData != null) {
        setState(() {
          final currentLevelName = provider.userData?['institution_level_name'];
          selectedLevel = currentLevelName;

          institutionLevelController.text = currentLevelName ?? 'Not available';
          teachingExperienceController.text =
              '${provider.userData?['experience'] ?? '0'} years';

          final qualifications = provider.userData?['qualifications'] ?? [];
          subjectsTaught =
              List<String>.from(qualifications); // Initialize subjects taught

          // Set additional skills if available
          final skills = provider.userData?['additional_skills'] ?? [];
          additionalSkillsController.text = skills.join(', ');
        });
      }
    });
  }

  int? getInstitutionLevelId(String? levelName) {
    if (levelName == null) return null;
    return institutionLevels[levelName];
  }

  void _addSubject() async {
    final provider =
        Provider.of<ProfessionalInfoProvider>(context, listen: false);
    await provider.fetchSubjectCategories();

    setState(() {
      subjectIdMapping = {}; // Reset the mapping
      for (var category in provider.subjectCategories) {
        for (var subject in category['subjects']) {
          subjectIdMapping[subject['name']] = subject['id'];
        }
      }
    });

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: Colors.white,
              title: Text('Select Subjects'),
              content: SingleChildScrollView(
                child: Column(
                  children: provider.subjectCategories.map((category) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          category['name'],
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Divider(
                          color: const Color(0xFFEBEBEB),
                          thickness: 1,
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 12.0,
                          runSpacing: 8.0,
                          children: category['subjects'].map<Widget>((subject) {
                            final isSelected =
                                subjectsTaught.contains(subject['name']);
                            return GestureDetector(
                              onTap: () {
                                setDialogState(() {
                                  if (isSelected) {
                                    subjectsTaught.remove(subject['name']);
                                  } else {
                                    subjectsTaught.add(subject['name']);
                                  }
                                });
                                setState(() {}); // Update parent state
                              },
                              child: Chip(
                                label: Text(
                                  subject['name'],
                                  style: GoogleFonts.inter(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: isSelected
                                        ? Color(0xFF000EF8)
                                        : Color(0xFF333333),
                                  ),
                                ),
                                backgroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16.0),
                                  side: BorderSide(
                                    color: isSelected
                                        ? Color(0xFF000EF8)
                                        : Color(0xFFF5F5F5),
                                    width: 1.0,
                                  ),
                                ),
                                deleteIcon: isSelected
                                    ? Icon(Icons.close,
                                        size: 16, color: Color(0xFF000EF8))
                                    : null,
                                onDeleted: isSelected
                                    ? () {
                                        setDialogState(() {
                                          subjectsTaught
                                              .remove(subject['name']);
                                        });
                                        setState(() {}); // Update parent state
                                      }
                                    : null,
                              ),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 16),
                      ],
                    );
                  }).toList(),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Done'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back, color: Color(0xFF1E1E1E)),
                onPressed: () => Navigator.of(context).pop(),
                padding: const EdgeInsets.all(0),
              ),
              const SizedBox(width: 8),
              Text(
                "Professional Details",
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1E1E1E),
                ),
              ),
            ],
          ),
        ),
        centerTitle: false,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0, top: 10),
            child: IconButton(
              icon: SvgPicture.asset(
                Assets.svg.edit, // Use the generated asset class
                height: 24,
                width: 24,
              ),
              onPressed: () {},
            ),
          ),
        ],
      ),
      body: Consumer<ProfessionalInfoProvider>(
        builder: (context, provider, child) {
          return LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 24),
                      const ProfileCard(),
                      const SizedBox(height: 24),

                      // Institution Level Dropdown
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                "Institution Level",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  fontFamily: 'Inter',
                                  color: Color(0xFF1F1F1F),
                                ),
                              ),
                              Text(
                                " *",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  fontFamily: 'Inter',
                                  color: Colors.red,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          DropdownButtonFormField<String>(
                            value: selectedLevel,
                            onChanged: (String? newValue) {
                              setState(() {
                                selectedLevel = newValue;
                              });
                            },
                            items: institutionLevels.keys
                                .map((level) => DropdownMenuItem<String>(
                                      value: level,
                                      child: Text(level,
                                          style: GoogleFonts.inter()),
                                    ))
                                .toList(),
                            hint: Text(
                              'Select institution level',
                              style: GoogleFonts.inter(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: const Color(0xFF828282),
                              ),
                            ),
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: const Color(0xFFFDFDFF),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  color: const Color(0xFFBDBDBD),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Teaching Experience Field
                      CustomTextField(
                        label: "Teaching Experience",
                        controller: teachingExperienceController,
                      ),
                      const SizedBox(height: 16),

                      // Subjects Taught Section
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                "Subjects Taught",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  fontFamily: 'Inter',
                                  color: Color(0xFF1F1F1F),
                                ),
                              ),
                              Text(
                                " *",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  fontFamily: 'Inter',
                                  color: Colors.red,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            height: 50,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: Color(0xFFBDBDBD), width: 1),
                              borderRadius: BorderRadius.circular(8),
                              color: Color(0xFFFDFDFF),
                            ),
                            child: Row(
                              children: [
                                // Add Subject Icon Button at the start
                                IconButton(
                                  icon: SvgPicture.asset(
                                    Assets.svg
                                        .edit, // Use the generated asset class
                                    height: 24,
                                    width: 24,
                                  ),
                                  onPressed: _addSubject,
                                  padding: EdgeInsets.zero,
                                  constraints: BoxConstraints(),
                                ),
                                const SizedBox(
                                    width:
                                        8), // Add some spacing after the icon
                                Expanded(
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      children: subjectsTaught.map((subject) {
                                        return Padding(
                                          padding:
                                              const EdgeInsets.only(right: 8.0),
                                          child: Chip(
                                            label: Text(
                                              subject,
                                              style: GoogleFonts.inter(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w400,
                                                color: Color(0xFF333333),
                                              ),
                                            ),
                                            backgroundColor: Colors.white,
                                            shape: RoundedRectangleBorder(
                                              // Changed from StadiumBorder to RoundedRectangleBorder
                                              borderRadius:
                                                  BorderRadius.circular(16.0),
                                              side: BorderSide(
                                                color: Color(0xFFF5F5F5),
                                                width: 1.0,
                                              ),
                                            ),
                                            deleteIcon: Icon(
                                                Icons
                                                    .close, // Added specific delete icon styling
                                                size: 16,
                                                color: Color(0xFF000EF8)),
                                            onDeleted: () {
                                              setState(() {
                                                subjectsTaught.remove(subject);
                                              });
                                            },
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 150),

                      ActionButtons(
                        isLoading: isLoading, // Pass loading state
                        onDiscard: () {
                          Navigator.pop(context);
                        },
                        onSave: () async {
                          setState(() {
                            isLoading = true; // Start loading
                          });

                          final institutionLevelId =
                              getInstitutionLevelId(selectedLevel);

                          if (institutionLevelId == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content:
                                    Text('Please select an institution level'),
                              ),
                            );
                            setState(() {
                              isLoading =
                                  false; // Stop loading if validation fails
                            });
                            return;
                          }

                          final experienceText = teachingExperienceController
                              .text
                              .replaceAll(RegExp(r'[^0-9]'), '');
                          final experience = int.tryParse(experienceText) ?? 0;

                          // Ensure qualifications is never null
                          List<int> selectedQualificationIds = subjectsTaught
                              .map((subject) => subjectIdMapping[subject])
                              .whereType<int>()
                              .toList();

                          bool success = await provider.updateProfessionalInfo(
                            institutionLevel: institutionLevelId,
                            experience: experience,
                            qualifications:
                                selectedQualificationIds, // Always send a list (never null)
                          );

                          setState(() {
                            isLoading = false; // Stop loading
                          });

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                success
                                    ? 'Professional details updated successfully!'
                                    : provider.errorMessage ??
                                        'Failed to update professional details.',
                              ),
                              backgroundColor:
                                  success ? Colors.green : Colors.red,
                            ),
                          );

                          if (success) {
                            Navigator.pop(context);
                          }
                        },
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    institutionLevelController.dispose();
    teachingExperienceController.dispose();
    additionalSkillsController.dispose();
    super.dispose();
  }
}

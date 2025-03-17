import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:we_teach/presentation/features/search/provider/job_search_provider.dart';
import 'package:we_teach/presentation/features/profile/shared/widgets/action_buttons.dart';

class TeacherSearchBottomSheet extends StatefulWidget {
  final ScrollController scrollController;
  const TeacherSearchBottomSheet({super.key, required this.scrollController});

  @override
  State<TeacherSearchBottomSheet> createState() =>
      _TeacherSearchBottomSheetState();
}

class _TeacherSearchBottomSheetState extends State<TeacherSearchBottomSheet> {
  List<String> schoolGender = ["Boys", "Girls", "Mixed Gender"];
  List<String> schoolTypes = ["Day", "Boarding", "Mixed"];
  List<String> subjects = [
    "English",
    "Kiswahili",
    "French",
    "Chinese",
    "German",
    "Math",
    "Physics"
  ];

  List<String> selectedLocations = [];
  List<String> selectedSchoolGender = [];
  List<String> selectedSchoolTypes = [];
  List<String> selectedSubjects = [];

  // List of predefined locations
  final List<String> predefinedLocations = ["Nairobi", "Nakuru", "Kisumu"];
  String _locationQuery = '';

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: widget.scrollController,
      child: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
          color: Colors.white,
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title and Close Button
              Row(
                children: [
                  Text(
                    "Filter Jobs",
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF1E1E1E),
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon:
                        const Icon(Icons.close, size: 24, color: Colors.black),
                  ),
                ],
              ),
              const Divider(color: Color(0xFFFAFAFA), thickness: 1),
              const SizedBox(height: 10),

              // Location Input
              Text(
                "Location",
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF1C1C1C),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                onChanged: (value) {
                  setState(() {
                    _locationQuery = value; // Update the location query
                  });
                },
                decoration: InputDecoration(
                  hintText: "Specify location",
                  hintStyle: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF828282),
                  ),
                  prefixIcon: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: SvgPicture.asset(
                      'assets/svg/lens.svg',
                      width: 20,
                      height: 20,
                    ),
                  ),
                  filled: true,
                  fillColor: const Color(0xFFFDFDFF),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide(
                      color: const Color(0xFF476BE8).withOpacity(0.11),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),

              // Display selected locations and filtered locations based on query
              Wrap(
                spacing: 8,
                runSpacing: 12,
                children: [
                  // Show already selected locations
                  ...selectedLocations.map((location) => _buildFilterChip(
                      location, selectedLocations,
                      isLocation: true)),

                  // Show filtered locations based on query
                  if (_locationQuery.isNotEmpty)
                    ...predefinedLocations
                        .where((location) =>
                            location
                                .toLowerCase()
                                .contains(_locationQuery.toLowerCase()) &&
                            !selectedLocations.contains(location))
                        .map((location) => _buildFilterChip(
                            location, selectedLocations,
                            isLocation: true)),
                ],
              ),
              const SizedBox(height: 20),

              // School Type Section
              Text(
                "School Type",
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF1C1C1C),
                ),
              ),
              const SizedBox(height: 10),
              // School Gender Chips
              Wrap(
                spacing: 8,
                runSpacing: 12,
                children: schoolGender
                    .map((gender) =>
                        _buildFilterChip(gender, selectedSchoolGender))
                    .toList(),
              ),
              const SizedBox(height: 10),
              // School Types Chips
              Wrap(
                spacing: 8,
                runSpacing: 12,
                children: schoolTypes
                    .map((type) => _buildFilterChip(type, selectedSchoolTypes))
                    .toList(),
              ),
              const SizedBox(height: 20),

              // Subjects Section
              Text(
                "Subjects",
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF1C1C1C),
                ),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 12,
                children: subjects
                    .map((subject) =>
                        _buildFilterChip(subject, selectedSubjects))
                    .toList(),
              ),
              const SizedBox(height: 20),

              // Action Buttons
              ActionButtons(
                onDiscard: () {
                  // Clear filters
                  setState(() {
                    selectedLocations.clear();
                    selectedSchoolGender.clear();
                    selectedSchoolTypes.clear();
                    selectedSubjects.clear();
                  });
                },
                onSave: () {
                  // Apply filters by updating the provider
                  final provider =
                      Provider.of<JobSearchProvider>(context, listen: false);
                  provider.applyFilters(
                    locations: selectedLocations,
                    schoolGenders: selectedSchoolGender,
                    schoolTypes: selectedSchoolTypes,
                    subjects: selectedSubjects,
                  );
                  Navigator.pop(context); // Close the bottom sheet
                },
                saveButtonText: "Apply Filters",
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  /// Builds a Filter Chip for selection
  Widget _buildFilterChip(String label, List<String> selectedList,
      {bool isLocation = false}) {
    final bool isSelected = selectedList.contains(label);
    return GestureDetector(
      onTap: () {
        setState(() {
          if (isSelected) {
            selectedList.remove(label);
          } else {
            selectedList.add(label);
          }
        });
      },
      child: Chip(
        label: Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color:
                isSelected ? const Color(0xFFAC00E6) : const Color(0xFF333333),
          ),
        ),
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
          side: BorderSide(
            color:
                isSelected ? const Color(0xFFAC00E6) : const Color(0xFFF5F5F5),
            width: 1.0,
          ),
        ),
        deleteIcon: isSelected
            ? const Icon(Icons.close, size: 16, color: Color(0xFFAC00E6))
            : null,
        onDeleted: isSelected
            ? () {
                setState(() {
                  selectedList.remove(label);
                });
              }
            : null,
      ),
    );
  }
}

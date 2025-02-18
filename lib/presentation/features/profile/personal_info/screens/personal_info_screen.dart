import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart'; // Import the image_picker package
import 'package:we_teach/presentation/features/profile/personal_info/provider/personal_info_provider.dart';
import 'package:we_teach/presentation/features/profile/shared/widgets/text_field.dart';
import 'package:we_teach/presentation/features/profile/shared/widgets/action_buttons.dart';
import 'dart:io';

class PersonalInfoScreen extends StatefulWidget {
  @override
  _PersonalInfoScreenState createState() => _PersonalInfoScreenState();
}

class _PersonalInfoScreenState extends State<PersonalInfoScreen> {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  String? selectedCountyId;
  String? selectedSubCountyId;
  String? currentCountyName;
  String? currentSubCountyName;
  String? imagePath; // Add a field to hold the image path
  File? _selectedImage; // Field to hold the selected image file
  bool isLoading = false; // Track loading state

  @override
  void initState() {
    super.initState();
    final userProfileProvider =
        Provider.of<PersonalInfoProvider>(context, listen: false);

    // Fetch counties first
    userProfileProvider.fetchCounties();

    // Wait for the first frame to execute state updates
    WidgetsBinding.instance.addPostFrameCallback((_) {
      userProfileProvider.fetchPersonalInfo().then((_) {
        final userData = userProfileProvider.userData;
        if (userData != null) {
          _fullNameController.text = userData['full_name'] ?? '';
          _emailController.text = userData['primary_email'] ?? '';
          _phoneNumberController.text = userData['phone_number'] ?? '';

          setState(() {
            imagePath = userData['image']; // Update safely
          });

          if (userData['county'] != null) {
            setState(() {
              selectedCountyId = userData['county']['id'].toString();
              currentCountyName = userData['county']['name'];
            });

            if (userData['sub_county'] != null) {
              setState(() {
                selectedSubCountyId = userData['sub_county']['id'].toString();
                currentSubCountyName = userData['sub_county']['name'];
              });

              userProfileProvider.fetchSubCounties(selectedCountyId!);
            }
          }
        }
      });
    });
  }

  Future<void> _pickImage(BuildContext context) async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _selectedImage = File(image.path); // Update the selected image
      });
    }
  }

  Widget _buildDropdowns(PersonalInfoProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // County Dropdown
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  "County of Residence",
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
              value: selectedCountyId,
              onChanged: (String? newValue) {
                setState(() {
                  selectedCountyId = newValue;
                  selectedSubCountyId =
                      null; // Reset sub-county when county changes
                  currentSubCountyName = null;
                });
                if (newValue != null) {
                  provider.fetchSubCounties(newValue);
                }
              },
              items: [
                if (currentCountyName != null && selectedCountyId != null)
                  DropdownMenuItem(
                    value: selectedCountyId,
                    child: Text(currentCountyName!),
                  ),
                ...provider.counties.entries.map((entry) {
                  return DropdownMenuItem(
                    value: entry.value,
                    child: Text(entry.key),
                  );
                }),
              ],
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
              hint: Text(
                currentCountyName ??
                    'Select County', // Set hint to fetched county name
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF828282),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 16),
        // Sub-county Dropdown
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  "Sub-county",
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
              value: selectedSubCountyId,
              onChanged: (String? newValue) {
                setState(() {
                  selectedSubCountyId = newValue;
                });
              },
              items: [
                if (currentSubCountyName != null && selectedSubCountyId != null)
                  DropdownMenuItem(
                    value: selectedSubCountyId,
                    child: Text(currentSubCountyName!),
                  ),
                ...provider.subCounties.entries.map((entry) {
                  return DropdownMenuItem(
                    value: entry.value,
                    child: Text(entry.key),
                  );
                }),
              ],
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
              hint: Text(
                currentSubCountyName ??
                    'Select Sub-county', // Set hint to fetched sub-county name
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF828282),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final userProfileProvider = Provider.of<PersonalInfoProvider>(context);

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
                "Profile",
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
            child: GestureDetector(
              onTap: () =>
                  _pickImage(context), // Call the method to pick an image
              child: SvgPicture.asset(
                'assets/svg/edit.svg',
                height: 40,
                width: 40,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            Stack(
              children: [
                SvgPicture.asset(
                  'assets/svg/ellipse.svg',
                  height: 120,
                  width: 120,
                  fit: BoxFit.cover,
                ),
                Positioned.fill(
                  child: Align(
                    alignment: Alignment.center,
                    child: ClipOval(
                      child: CircleAvatar(
                        radius: 55,
                        backgroundImage: _selectedImage != null
                            ? FileImage(_selectedImage!) as ImageProvider
                            : (userProfileProvider.userData?['image'] != null
                                ? NetworkImage(
                                    userProfileProvider.userData!['image'])
                                : const AssetImage("assets/images/man.png")),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: CircleAvatar(
                    radius: 18,
                    backgroundColor: Colors.white,
                    child: GestureDetector(
                      onTap: () => _pickImage(
                          context), // Call the method to pick an image
                      child: SvgPicture.asset(
                        'assets/svg/edit.svg',
                        height: 30,
                        width: 30,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Text(
              userProfileProvider.userData?['full_name'] ?? 'Unknown User',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(
              '${userProfileProvider.userData?['institution_level_name'] ?? 'Unknown Institution Level'} Teacher',
              style: TextStyle(color: Colors.grey[600]),
            ),
            Text(
              userProfileProvider.userData?['joined_date'] != null
                  ? "Joined ${userProfileProvider.userData!['joined_date']}"
                  : 'Joined recently',
              style: TextStyle(color: Colors.grey[600], fontSize: 12),
            ),
            SizedBox(height: 16),
            Divider(color: Color(0xFFEBEBEB), thickness: 1),
            SizedBox(height: 30),
            CustomTextField(
              label: "Full Name",
              controller: _fullNameController,
            ),
            CustomTextField(
              label: "Email",
              controller: _emailController,
            ),
            CustomTextField(
              label: "Phone Number",
              controller: _phoneNumberController,
            ),
            SizedBox(height: 16),
            _buildDropdowns(
                userProfileProvider), // Dropdowns for county and sub-county
            SizedBox(height: 30),
            ActionButtons(
              isLoading: isLoading, // Pass loading state
              onDiscard: () {
                Navigator.pop(context);
              },
              onSave: () async {
                setState(() {
                  isLoading = true; // Start loading
                });

                bool success = await userProfileProvider.updatePersonalInfo(
                  fullName: _fullNameController.text,
                  primaryEmail: _emailController.text,
                  phoneNumber: _phoneNumberController.text,
                  county:
                      selectedCountyId != null && selectedCountyId!.isNotEmpty
                          ? int.parse(selectedCountyId!)
                          : null,
                  subCounty: selectedSubCountyId != null &&
                          selectedSubCountyId!.isNotEmpty
                      ? int.parse(selectedSubCountyId!)
                      : null,
                  image: _selectedImage != null ? _selectedImage!.path : null,
                );

                setState(() {
                  isLoading = false; // Stop loading
                });

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(success
                        ? 'Profile updated successfully!'
                        : 'Failed to update profile.'),
                    backgroundColor: success ? Colors.green : Colors.red,
                  ),
                );

                if (success) {
                  Navigator.pop(
                      context); // Pop the screen if the update was successful
                }
              },
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneNumberController.dispose();
    super.dispose();
  }
}

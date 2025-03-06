import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
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
  File? _selectedImage;
  bool isLoading = false;
  bool _dataInitialized = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeData();
    });
  }

  void _initializeData() async {
    final userProfileProvider =
        Provider.of<PersonalInfoProvider>(context, listen: false);
    await userProfileProvider.fetchCounties();
    await userProfileProvider.fetchPersonalInfo();
    final userData = userProfileProvider.userData;
    if (userData != null) {
      _fullNameController.text = userData['full_name'] ?? '';
      _emailController.text = userData['primary_email'] ?? '';
      _phoneNumberController.text = userData['phone_number'] ?? '';

      if (userData['county'] != null) {
        currentCountyName = userData['county'].toString();
        for (var entry in userProfileProvider.counties.entries) {
          if (entry.key == currentCountyName) {
            selectedCountyId = entry.value;
            break;
          }
        }
      }

      if (selectedCountyId != null) {
        await userProfileProvider.fetchSubCounties(selectedCountyId!);
        if (userData['sub_county'] != null) {
          currentSubCountyName = userData['sub_county'].toString();
          for (var entry in userProfileProvider.subCounties.entries) {
            if (entry.key == currentSubCountyName) {
              selectedSubCountyId = entry.value;
              break;
            }
          }
        }
      }
      setState(() {
        _dataInitialized = true;
      });
    }
  }

  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
    }
  }

  Widget _buildDropdowns(PersonalInfoProvider provider) {
    final List<DropdownMenuItem<String>> countyItems = provider.counties.entries
        .map((entry) => DropdownMenuItem<String>(
              value: entry.value,
              child: Text(entry.key),
            ))
        .toList();

    final List<DropdownMenuItem<String>> subCountyItems =
        provider.subCounties.entries
            .map((entry) => DropdownMenuItem<String>(
                  value: entry.value,
                  child: Text(entry.key),
                ))
            .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // County Dropdown
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text("County of Residence",
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF1F1F1F))),
                Text(" *",
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Colors.red)),
              ],
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: selectedCountyId,
              onChanged: (String? newValue) {
                setState(() {
                  selectedCountyId = newValue;
                  selectedSubCountyId = null;
                  provider.fetchSubCounties(newValue!);
                });
              },
              items: countyItems,
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color(0xFFFDFDFF),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: const Color(0xFFBDBDBD)),
                ),
              ),
              hint: Text(currentCountyName ?? 'Select County',
                  style: GoogleFonts.inter(
                      fontSize: 16, color: const Color(0xFF828282))),
            ),
          ],
        ),
        const SizedBox(height: 16),
        // Sub-county Dropdown
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text("Sub-county",
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF1F1F1F))),
                Text(" *",
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Colors.red)),
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
              items: subCountyItems,
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color(0xFFFDFDFF),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: const Color(0xFFBDBDBD)),
                ),
              ),
              hint: Text(currentSubCountyName ?? 'Select Sub-county',
                  style: GoogleFonts.inter(
                      fontSize: 16, color: const Color(0xFF828282))),
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
              Text("Profile",
                  style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF1E1E1E))),
            ],
          ),
        ),
        centerTitle: false,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0, top: 10),
            child: GestureDetector(
              onTap: _pickImage,
              child: SvgPicture.asset('assets/svg/edit.svg',
                  height: 40, width: 40),
            ),
          ),
        ],
      ),
      body: userProfileProvider.isLoading || !_dataInitialized
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 20),
                  Stack(
                    children: [
                      SvgPicture.asset('assets/svg/ellipse.svg',
                          height: 120, width: 120, fit: BoxFit.cover),
                      Positioned.fill(
                        child: Align(
                          alignment: Alignment.center,
                          child: ClipOval(
                            child: CircleAvatar(
                              radius: 55,
                              backgroundImage: _selectedImage != null
                                  ? FileImage(_selectedImage!)
                                  : (userProfileProvider.userData?['image'] !=
                                          null
                                      ? NetworkImage(
                                          userProfileProvider.userData!['image']
                                              as String) as ImageProvider
                                      : const AssetImage(
                                          "assets/images/man.png")),
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
                            onTap: _pickImage,
                            child: SvgPicture.asset('assets/svg/edit.svg',
                                height: 30, width: 30),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Text(
                      userProfileProvider.userData?['full_name'] ??
                          'Unknown User',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  Text(
                      '${userProfileProvider.userData?['institution_level_name'] ?? 'Unknown Institution Level'} Teacher',
                      style: TextStyle(color: Colors.grey[600])),
                  Text(
                      userProfileProvider.userData?['joined_date'] != null
                          ? "Joined ${userProfileProvider.userData!['joined_date']}"
                          : 'Joined recently',
                      style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                  SizedBox(height: 16),
                  Divider(color: Color(0xFFEBEBEB), thickness: 1),
                  SizedBox(height: 30),
                  CustomTextField(
                      label: "Full Name", controller: _fullNameController),
                  CustomTextField(label: "Email", controller: _emailController),
                  CustomTextField(
                      label: "Phone Number",
                      controller: _phoneNumberController),
                  SizedBox(height: 16),
                  _buildDropdowns(userProfileProvider),
                  SizedBox(height: 30),
                  ActionButtons(
                    isLoading: isLoading,
                    onDiscard: () {
                      Navigator.pop(context);
                    },
                    onSave: () async {
                      setState(() {
                        isLoading = true;
                      });

                      bool success =
                          await userProfileProvider.updatePersonalInfo(
                        fullName: _fullNameController.text,
                        primaryEmail: _emailController.text,
                        phoneNumber: _phoneNumberController.text,
                        county: selectedCountyId != null &&
                                selectedCountyId!.isNotEmpty
                            ? int.tryParse(selectedCountyId!) ?? 0
                            : null,
                        subCounty: selectedSubCountyId != null &&
                                selectedSubCountyId!.isNotEmpty
                            ? int.tryParse(selectedSubCountyId!) ?? 0
                            : null,
                        image: _selectedImage != null
                            ? _selectedImage!.path
                            : null,
                      );

                      setState(() {
                        isLoading = false;
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
                        Navigator.pop(context);
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

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class JobDetailsTabSection extends StatefulWidget {
  final ValueChanged<int> onTabChanged; // Callback to notify parent

  const JobDetailsTabSection({super.key, required this.onTabChanged});

  @override
  State<JobDetailsTabSection> createState() => _JobDetailsTabSectionState();
}

class _JobDetailsTabSectionState extends State<JobDetailsTabSection> {
  int _selectedIndex = 0; // Tracks the active tab

  final List<String> _tabs = [
    'About Job',
    'Qualifications',
    'Application',
    'Contacts'
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFFAFAFA),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0x0D476BE8), width: 1),
      ),
      child: Row(
        children: _tabs.map((title) {
          int index = _tabs.indexOf(title);
          return Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedIndex = index;
                });
                widget.onTabChanged(index); // Notify parent widget
              },
              child: Container(
                alignment: Alignment.center,
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
                decoration: _selectedIndex == index
                    ? BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(6),
                      )
                    : null,
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: _selectedIndex == index
                        ? FontWeight.w500
                        : FontWeight.w400,
                    color: _selectedIndex == index
                        ? const Color(0xFF000EF8)
                        : const Color(0xFF5C5C5C),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

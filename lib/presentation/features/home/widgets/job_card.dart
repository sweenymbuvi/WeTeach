import 'package:flutter/material.dart';
import 'package:we_teach/presentation/features/payment/screens/show_payment_screen.dart';
import 'dart:ui';

// ignore: must_be_immutable
class JobCard extends StatefulWidget {
  final int jobId;
  final String jobTitle;
  final String timePosted;
  final String location;
  final String schoolName;
  bool isSaved;

  JobCard({
    Key? key,
    required this.jobId,
    required this.jobTitle,
    required this.timePosted,
    required this.location,
    required this.schoolName,
    this.isSaved = false,
  }) : super(key: key);

  @override
  _JobCardState createState() => _JobCardState();
}

class _JobCardState extends State<JobCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        PaymentBottomSheet.show(context,
            jobId: widget.jobId); // Pass jobId here
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: const Color(0xFFF5F5F5),
            width: 1,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CircleAvatar(
              radius: 24,
              backgroundColor: Colors.grey,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.jobTitle,
                    style: const TextStyle(
                      color: Color(0xFF333333),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Inter',
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "${widget.timePosted} • ${widget.location}",
                    style: const TextStyle(
                      color: Color(0xFF7D7D7D),
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'Inter',
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Text(
                        "School: ",
                        style: TextStyle(
                          color: Color(0xFF000EF8),
                          fontFamily: 'Inter',
                        ),
                      ),
                      Expanded(
                        child: Stack(
                          alignment: Alignment.centerLeft,
                          children: [
                            // Original text
                            Text(
                              widget.schoolName,
                              style: const TextStyle(
                                color: Color(0xFF000EF8),
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'Inter',
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            // Blurred overlay
                            ClipRect(
                              child: BackdropFilter(
                                filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                                child: Container(
                                  color: Colors.transparent,
                                  child: Text(
                                    widget.schoolName,
                                    style: const TextStyle(
                                      color: Colors.transparent,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: 'Inter',
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  widget.isSaved = !widget.isSaved;
                });
              },
              child: Icon(
                widget.isSaved ? Icons.bookmark : Icons.bookmark_outline,
                color: const Color(0xFF000EF8),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

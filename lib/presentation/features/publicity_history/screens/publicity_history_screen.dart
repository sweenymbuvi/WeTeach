import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:we_teach/gen/assets.gen.dart';
import 'package:we_teach/presentation/features/auth/profile/screens/profile_popup.dart';
import 'package:we_teach/presentation/features/home/home_screen/screens/home_screen.dart';
import 'package:we_teach/presentation/features/publicity_history/provider/publicity_history_provider.dart';

class PublicityHistoryScreen extends StatefulWidget {
  @override
  _PublicityHistoryScreenState createState() => _PublicityHistoryScreenState();
}

class _PublicityHistoryScreenState extends State<PublicityHistoryScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      final provider =
          Provider.of<PublicityHistoryProvider>(context, listen: false);
      provider.fetchPublicityHistory().then((_) {
        if (provider.shouldShowProfilePopup) {
          _showProfilePopup(); // Call the new method to show the ProfilePopup
        }
      });
    });
  }

  void _showProfilePopup() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) => ProfilePopup(), // Show the ProfilePopup
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF333333)),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen()),
            );
          },
        ),
        title: Text(
          "Publicity History",
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Color(0xFF333333),
          ),
        ),
        centerTitle: false,
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: Consumer<PublicityHistoryProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return Center(child: CircularProgressIndicator());
          }
          if (provider.errorMessage != null) {
            return Center(child: Text(provider.errorMessage!));
          }

          List<dynamic> publicityHistory = provider.publicityHistory;

          if (publicityHistory.isEmpty) {
            return Center(child: Text("No publicity history available."));
          }

          return Column(
            children: [
              const Divider(color: Color(0xFFF6F6F6), thickness: 1),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: publicityHistory.length,
                  itemBuilder: (context, index) {
                    final item = publicityHistory[index];
                    bool isActive = item["status"] == "active";

                    return Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 12, horizontal: 16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 24),
                                child: SvgPicture.asset(
                                  isActive
                                      ? Assets.svg
                                          .publicityActive // Use the generated asset class for active
                                      : Assets.svg
                                          .publicityInactive, // Use the generated asset class for inactive
                                  width: 40,
                                  height: 40,
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${item["days"]} Days for Ksh ${item["price"]}",
                                      style: GoogleFonts.inter(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xFF333333),
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      isActive
                                          ? "Package still active"
                                          : "Expired ${item["expiryDate"]}",
                                      style: GoogleFonts.inter(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                        color: isActive
                                            ? Color(0xFF000EF8)
                                            : Color(0xFF787878),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    "Total Impressions",
                                    style: GoogleFonts.inter(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                      color: Color(0xFF333333),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "${item["impressions"]}",
                                    style: GoogleFonts.inter(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF333333),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const Divider(color: Color(0xFFF8F8F8), thickness: 1),
                      ],
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:we_teach/presentation/features/profile/payment/provider/payment_provider.dart';
import 'package:we_teach/presentation/features/profile/payment/screens/card_payment_screen.dart';
import 'package:we_teach/presentation/features/profile/payment/screens/mpesa_payment_screen.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:we_teach/presentation/features/profile/shared/widgets/payment_card.dart';

class PaymentOptionsScreen extends StatefulWidget {
  final String? paymentMethodId;
  final String? cardNumber;

  const PaymentOptionsScreen({Key? key, this.paymentMethodId, this.cardNumber})
      : super(key: key);

  @override
  _PaymentOptionsScreenState createState() => _PaymentOptionsScreenState();
}

class _PaymentOptionsScreenState extends State<PaymentOptionsScreen> {
  String? _cardNumber;
  bool _isFirstLoad = true;
  bool _hasError = false;
  String _errorMessage = "";
  bool _isInitializing = true; // Flag to track initialization state

  @override
  void initState() {
    super.initState();
    _cardNumber = widget.cardNumber; // Initialize with passed value
    // Don't call _fetchPaymentMethods here to avoid duplicate calls
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Only fetch on the first load or when returning to this screen
    if (_isFirstLoad) {
      _isFirstLoad = false;
      // Use Future.microtask to avoid calling setState during build
      Future.microtask(() => _fetchPaymentMethods());
    }
  }

  Future<void> _fetchPaymentMethods() async {
    if (!mounted) return; // Safety check to prevent setState after disposal

    setState(() {
      _hasError = false;
      _errorMessage = "";
      _isInitializing = true; // Set loading state
    });

    try {
      final provider = Provider.of<PaymentProvider>(context, listen: false);
      await provider.fetchPaymentMethods();

      if (!mounted) return; // Check again after async operation

      setState(() {
        _isInitializing = false; // Update state after fetch completes
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _hasError = true;
        _errorMessage = "Failed to load payment methods. ${e.toString()}";
        _isInitializing = false;
      });
    }
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
                "Payment Options",
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
                'assets/svg/add.svg',
                height: 40,
                width: 40,
              ),
              onPressed: () async {
                // Add payment method action
                // You might want to navigate to an add payment page
              },
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Consumer<PaymentProvider>(
          builder: (context, paymentProvider, child) {
            if (_isInitializing || paymentProvider.isLoading) {
              return const Center(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text(
                    "Loading payment methods...",
                    style: TextStyle(color: Color(0xFF5C5C5C)),
                  )
                ],
              ));
            }

            if (_hasError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _errorMessage,
                      style: const TextStyle(color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _fetchPaymentMethods,
                      child: const Text("Retry"),
                    )
                  ],
                ),
              );
            }

            // Safety check for empty payment methods
            final paymentMethods = paymentProvider.paymentMethods;
            if (paymentMethods.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "No payment methods available.",
                      style: TextStyle(fontSize: 16, color: Color(0xFF5C5C5C)),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MpesaPaymentScreen(),
                          ),
                        );
                        _fetchPaymentMethods();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF000EF8),
                      ),
                      child: const Text("Add M-Pesa"),
                    ),
                  ],
                ),
              );
            }

            // Get latest payment method safely
            final latestPaymentMethod =
                paymentMethods.isNotEmpty ? paymentMethods.last : null;

            // Safely get masked phone number
            String maskedPhoneNumber = "No payment method added";
            if (latestPaymentMethod != null &&
                latestPaymentMethod.containsKey('phone_number') &&
                latestPaymentMethod['phone_number'] != null) {
              maskedPhoneNumber =
                  maskPhoneNumber(latestPaymentMethod['phone_number']);
            }

            return RefreshIndicator(
              onRefresh: _fetchPaymentMethods,
              child: ListView(
                children: [
                  PaymentOptionCard(
                    logo: 'assets/images/mpesa.png',
                    title: 'Mpesa',
                    subtitle: maskedPhoneNumber,
                    paymentMethodId: latestPaymentMethod?['id']?.toString(),
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MpesaPaymentScreen(),
                        ),
                      );
                      _fetchPaymentMethods(); // Refresh after returning
                    },
                    onMoreOptions: () {},
                    onEditPressed: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MpesaPaymentScreen(),
                        ),
                      );
                      _fetchPaymentMethods();
                    },
                    showThreeDots: true,
                  ),
                  const SizedBox(height: 16),
                  PaymentOptionCard(
                    logo: 'assets/images/visa.png',
                    title: 'Bank Card',
                    subtitle: _cardNumber != null
                        ? maskCardNumber(_cardNumber!)
                        : 'VISA **** 8888',
                    onTap: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CardPaymentScreen(),
                        ),
                      );
                      if (result is String) {
                        setState(() {
                          _cardNumber = result; // Update card number
                        });
                      }
                      _fetchPaymentMethods();
                    },
                    onMoreOptions: () {},
                    onEditPressed: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CardPaymentScreen(),
                        ),
                      );
                      if (result is String) {
                        setState(() {
                          _cardNumber = result; // Update card number
                        });
                      }
                      _fetchPaymentMethods();
                    },
                    showThreeDots: true,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  String maskPhoneNumber(String phoneNumber) {
    if (phoneNumber == null || phoneNumber.isEmpty) return "Not provided";
    if (phoneNumber.length < 8) return phoneNumber;
    return phoneNumber.substring(0, 4) +
        '****' +
        phoneNumber.substring(phoneNumber.length - 3);
  }

  String maskCardNumber(String cardNumber) {
    if (cardNumber == null || cardNumber.isEmpty) return "Not provided";
    if (cardNumber.length < 4) return cardNumber;
    return '**** **** **** ' + cardNumber.substring(cardNumber.length - 4);
  }
}

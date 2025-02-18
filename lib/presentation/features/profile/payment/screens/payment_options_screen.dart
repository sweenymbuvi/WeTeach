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

  @override
  void initState() {
    super.initState();
    _cardNumber = widget.cardNumber; // Initialize with passed value
    _fetchPaymentMethods();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _fetchPaymentMethods(); // Ensures the latest data when navigating back
  }

  void _fetchPaymentMethods() {
    final provider = Provider.of<PaymentProvider>(context, listen: false);
    provider.fetchPaymentMethods();
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
            child: SvgPicture.asset(
              'assets/svg/add.svg',
              height: 40,
              width: 40,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Consumer<PaymentProvider>(
          builder: (context, paymentProvider, child) {
            if (paymentProvider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (paymentProvider.paymentMethods.isEmpty) {
              return const Center(
                child: Text("No payment methods available."),
              );
            }

            final latestPaymentMethod =
                paymentProvider.paymentMethods.isNotEmpty
                    ? paymentProvider.paymentMethods.last
                    : null;

            String maskedPhoneNumber = latestPaymentMethod != null
                ? maskPhoneNumber(latestPaymentMethod['phone_number'])
                : "No payment method added";

            return Column(
              children: [
                PaymentOptionCard(
                  logo: 'assets/images/mpesa.png',
                  title: 'Mpesa',
                  subtitle: maskedPhoneNumber,
                  paymentMethodId: widget.paymentMethodId,
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
            );
          },
        ),
      ),
    );
  }

  String maskPhoneNumber(String phoneNumber) {
    if (phoneNumber.length < 8) return phoneNumber;
    return phoneNumber.substring(0, 4) +
        '****' +
        phoneNumber.substring(phoneNumber.length - 3);
  }

  String maskCardNumber(String cardNumber) {
    if (cardNumber.length < 4) return cardNumber;
    return '**** **** **** ' + cardNumber.substring(cardNumber.length - 4);
  }
}

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:social/social.dart';

import 'otp_phone.dart';

class PhoneSignInScreen extends StatelessWidget {
  PhoneSignInScreen({super.key});

  final TextEditingController phoneController = TextEditingController();

  void _showErrorFlushbar(BuildContext context, String message) {
    Flushbar(
      message: message,
      messageColor: Colors.red,
      duration: const Duration(seconds: 2),
      backgroundColor: Colors.red.shade50,
      margin: const EdgeInsets.all(8),
      borderRadius: BorderRadius.circular(8),
      flushbarPosition: FlushbarPosition.TOP,
    ).show(context);
  }

  void _verifyPhone(BuildContext context) {
    String phone = phoneController.text.trim();

    if (phone.isEmpty) {
      _showErrorFlushbar(context, "Please enter your phone number!");
      return;
    }

    if (phone.startsWith("0")) {
      phone = phone.substring(1);
    }

    final formattedPhone = "+95 $phone";
    phoneController.clear();

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) =>
            OtpVerificationScreen(phoneNumber: formattedPhone),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.chevron_left_rounded, size: 25),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            SizedBox(height: 20),
            _Header(),
            SizedBox(height: 20),
            _PhoneInputField(),
          ],
        ),
      ),
      bottomSheet: Padding(
        padding: const EdgeInsets.all(18),
        child: SocialButton(
          text: 'Verify Phone Number',
          color: Color(0xFF375DFB),
          textColor: Colors.white,
          onPressed: () => _verifyPhone(context),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text(
          'Welcome',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        Text(
          'Type your phone number after +95, starting with 9',
          style: TextStyle(fontSize: 14),
        ),
      ],
    );
  }
}

class _PhoneInputField extends StatelessWidget {
  const _PhoneInputField();

  @override
  Widget build(BuildContext context) {
    final phoneController =
        (context.findAncestorWidgetOfExactType<PhoneSignInScreen>())
            ?.phoneController;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        border: Border.all(color: Color(0xFFE2E4E9), width: 1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
        controller: phoneController,
        keyboardType: TextInputType.phone,
        inputFormatters: [
          LengthLimitingTextInputFormatter(11),
          FilteringTextInputFormatter.digitsOnly,
        ],
        decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 15),
          prefixIcon: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(width: 8),
              Image.asset('assets/mm.png', width: 20, height: 20),
              const SizedBox(width: 5),
              const Text(
                '+95',
                style: TextStyle(color: Colors.black, fontSize: 14),
              ),
              const SizedBox(width: 10),
              Container(height: 50, width: 1, color: Color(0xFFE2E4E9)),
            ],
          ),
          prefixIconConstraints: const BoxConstraints(
            minWidth: 0,
            minHeight: 0,
          ),
        ),
      ),
    );
  }
}

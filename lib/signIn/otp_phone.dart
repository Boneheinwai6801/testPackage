import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:otp_autofill/otp_autofill.dart';
import 'package:social/social.dart';


class OtpVerificationScreen extends StatefulWidget {
  final String phoneNumber;

  const OtpVerificationScreen({super.key, required this.phoneNumber});

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  late OTPTextEditController controller;
  late OTPInteractor _otpInteractor;
  String? appSignature;

  @override
  void initState() {
    super.initState();
    controller = OTPTextEditController(codeLength: 6);
    _initInteractor();
  }

  Future<void> _initInteractor() async {
    _otpInteractor = OTPInteractor();
    appSignature = await _otpInteractor.getAppSignature();
    log('App Signature: $appSignature');

    controller.startListenUserConsent((code) {
      final exp = RegExp(r'(\d{6})');
      return exp.stringMatch(code ?? '') ?? '';
    });
  }

  void _onOtpCompleted(String value) {
    if (value.length == 6) {
      controller.text = value;
      if (formKey.currentState!.validate()) {
        log("OTP Entered: $value");
      }
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
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
          children: [
            const SizedBox(height: 20),
            _Header(phoneNumber: widget.phoneNumber),
            const SizedBox(height: 20),
            _OtpInputField(
              formKey: formKey,
              controller: controller,
              onCompleted: _onOtpCompleted,
            ),
            _buildresentText(context),
          ],
        ),
      ),
      bottomSheet: Padding(
        padding: const EdgeInsets.all(18),
        child: SocialButton(
          text: 'Confirm',
          color: const Color(0xFF375DFB),
          textColor: Colors.white,
          onPressed: () {
            if (controller.text.length == 6) {
              _onOtpCompleted(controller.text);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Please enter a 6-digit OTP")),
              );
            }
          },
        ),
      ),
    );
  }

  _buildresentText(BuildContext context) {
    return Center(
      child: RichText(
        textAlign: TextAlign.center,

        text: TextSpan(
          text: "Having trouble? ",
          style: const TextStyle(color: Colors.black, fontSize: 14),
          children: [
            TextSpan(
              text: 'Resend OTP',
              style: const TextStyle(
                color: Color(0xFF375DFB),
                fontWeight: FontWeight.bold,
                textBaseline: TextBaseline.alphabetic,
                fontSize: 14,
                decoration: TextDecoration.underline,
                decorationThickness: 1.5,
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Resend OTP tapped")),
                  );
                },
            ),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final String phoneNumber;

  const _Header({required this.phoneNumber});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Verification',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Text(
          'We will send OTP code to $phoneNumber',
          style: const TextStyle(fontSize: 14),
        ),
      ],
    );
  }
}

class _OtpInputField extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final OTPTextEditController controller;
  final ValueChanged<String> onCompleted;

  const _OtpInputField({
    required this.formKey,
    required this.controller,
    required this.onCompleted,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: PinCodeTextField(
        appContext: context,
        controller: controller,
        length: 6,
        keyboardType: TextInputType.number,
        animationType: AnimationType.fade,
        cursorColor: Colors.black,
        animationDuration: const Duration(milliseconds: 300),
        enableActiveFill: true,
        obscureText: false,
        obscuringCharacter: '*',

        pastedTextStyle: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.normal,
        ),
        textStyle: const TextStyle(
          fontWeight: FontWeight.w600,
          color: Colors.black,
        ),

        pinTheme: PinTheme(
          fieldOuterPadding: const EdgeInsets.all(2),
          borderWidth: 0.5,
          shape: PinCodeFieldShape.box,
          borderRadius: BorderRadius.circular(10),
          fieldHeight: 50,
          fieldWidth: 45,
          activeBorderWidth: 0,
          activeFillColor: Colors.transparent,
          activeColor: const Color.fromARGB(255, 151, 151, 152),
          inactiveFillColor: Colors.transparent,
          inactiveColor: const Color(0xffE2E4E9),
          selectedFillColor: Colors.transparent,
        ),

        onCompleted: onCompleted,
        onChanged: (value) {
          if (kDebugMode) {
            log("OTP Changed: $value");
          }
        },
        beforeTextPaste: (text) => true,
      ),
    );
  }
}

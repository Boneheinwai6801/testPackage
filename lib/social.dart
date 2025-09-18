// ignore_for_file: use_build_context_synchronously, deprecated_member_use

import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'auth.dart';
import 'signIn/signin_phone.dart';


class SocialSignInPage extends StatelessWidget {
  final Widget imagelogo;

  final bool enableGoogle;
  final bool enablePhone;
  final bool enableEmail;
  final bool enableSkip;

  const SocialSignInPage({
    super.key,
    this.imagelogo = const FlutterLogo(size: 100),
    this.enableGoogle = true,
    this.enablePhone = true,
    this.enableEmail = true,
    this.enableSkip = true,
  });

  Future<void> _onSignIn(String platform, BuildContext context) async {
    try {
      UserCredential? userCredential;

      switch (platform) {
        case 'Google':
          userCredential = await AuthService().signInWithGoogle();
          break;
        case 'Phone':
          Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (_) => PhoneSignInScreen()));
          break;
        case 'Email':
          log("Email sign-in not implemented yet.");
          break;
        case 'Skip':
          log("User skipped sign-in.");
          break;
        default:
          log("Other sign-in ($platform) not implemented yet.");
      }

      // if (userCredential?.user != null) {
      //   Navigator.of(context).push(
      //     MaterialPageRoute(
      //       builder: (_) => ProfileScreen(user: userCredential!.user!),
      //     ),
      //   );
      // } else if (platform != 'Skip') {
      // }
    } catch (e) {
      _showError(context, 'Error: $e');
    }
  }

  void _showError(BuildContext context, String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  Widget _buildDivider() {
    return Stack(
      alignment: Alignment.center,
      children: [
        const Divider(
          thickness: 1,
          indent: 30,
          endIndent: 30,
          color: Colors.grey,
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          color: Colors.white,
          // color: Color(0xFFF0F2F5),
          child: const Text('OR', style: TextStyle(color: Colors.grey)),
        ),
      ],
    );
  }

  Widget _buildTermsText() {
    return RichText(
      textAlign: TextAlign.center,
      text: const TextSpan(
        text: 'By Signing up, you agree to our ',
        style: TextStyle(color: Colors.black, fontSize: 14),
        children: <TextSpan>[
          TextSpan(
            text: 'Terms of Service ',
            style: TextStyle(color: Colors.blueAccent, fontSize: 14),
          ),
          TextSpan(
            text: 'and ',
            style: TextStyle(fontStyle: FontStyle.italic, color: Colors.black),
          ),
          TextSpan(
            text: 'Privacy Policy',
            style: TextStyle(color: Colors.blueAccent, fontSize: 14),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: screenHeight * 0.05),

                  imagelogo,
                  SizedBox(height: screenHeight * 0.25),

                  if (enablePhone) ...[
                    SocialButton(
                      text: 'Continue with Phone Number',
                      color: Colors.blueAccent,
                      icon: const Icon(Icons.phone, color: Colors.white),
                      onPressed: () => _onSignIn('Phone', context),
                    ),
                    const SizedBox(height: 15),
                  ],

                  if (enableGoogle) ...[
                    SocialButton(
                      text: 'Sign in with Google',
                      color: Colors.black,
                      assetIcon: 'assets/google-removebg-preview.png',
                      onPressed: () => _onSignIn('Google', context),
                    ),
                    const SizedBox(height: 15),
                  ],

                  if (enableEmail) ...[
                    SocialButton(
                      text: 'Continue with Email',
                      color: Colors.blueAccent,
                      icon: const Icon(Icons.email, color: Colors.white),
                      onPressed: () => _onSignIn('Email', context),
                    ),
                    const SizedBox(height: 20),
                  ],

                  _buildTermsText(),
                  const SizedBox(height: 20),

                  if (enableSkip) ...[
                    _buildDivider(),
                    const SizedBox(height: 20),
                    SocialButton(
                      text: 'Sign up later',
                      color: Colors.white10,
                      icon: const Icon(
                        Icons.emoji_emotions,
                        color: Colors.black,
                      ),
                      textColor: Colors.black,
                      onPressed: () => _onSignIn('Skip', context),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class SocialButton extends StatelessWidget {
  final String text;
  final Color color;
  final Icon? icon;
  final String? assetIcon;
  final VoidCallback onPressed;
  final Color textColor;

  const SocialButton({
    super.key,
    required this.text,
    required this.color,
    required this.onPressed,
    this.icon,
    this.assetIcon,
    this.textColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          foregroundColor: textColor,
          backgroundColor: color,
          minimumSize: const Size(double.infinity, 50),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          elevation: 5,
          shadowColor: color.withOpacity(0.5),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) icon!,
            if (assetIcon != null)
              Image.asset(assetIcon!, height: 24, width: 24),
            const SizedBox(width: 12),
            Text(
              text,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.normal,
                color: textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

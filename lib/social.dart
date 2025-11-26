// ignore_for_file: use_build_context_synchronously, deprecated_member_use

import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:social/model/model.dart';

import 'auth.dart';
import 'signIn/signin_phone.dart';

class SocialSignInPage extends StatelessWidget {
  final Widget imagelogo;
  final bool enableGoogle;
  final bool enablePhone;
  final bool enableEmail;
  final bool enableSkip;
  final Color? backgroundColor;
  final Color? phoneButtonColor;
  final Color? googleButtonColor;
  final Color? emailButtonColor;
  final Color? skipButtonColor;

  final Color? phoneTextColor;
  final Color? googleTextColor;
  final Color? emailTextColor;
  final Color? skipTextColor;
  final String? googleAssetIcon;
  final String? packageName; // Add package name parameter
  final void Function(AuthUserData user)? onSignInSuccess;

  const SocialSignInPage({
    super.key,
    this.imagelogo = const FlutterLogo(size: 100),
    this.enableGoogle = true,
    this.enablePhone = true,
    this.enableEmail = true,
    this.enableSkip = true,
    this.backgroundColor,
    this.phoneButtonColor,
    this.googleButtonColor,
    this.emailButtonColor,
    this.skipButtonColor,
    this.phoneTextColor,
    this.googleTextColor,
    this.emailTextColor,
    this.skipTextColor,
    this.googleAssetIcon,
    this.packageName = 'social', // Default package name
    this.onSignInSuccess,
  });

  Future<void> _onSignIn(String platform, BuildContext context) async {
    try {
      AuthUserData? authUser;

      switch (platform) {
        case 'Google':
          try {
            showLoadingDialog(context, message: "Signing in with Google...");
            authUser = await AuthService().signInWithGoogle().then((userCred) {
              final user = userCred!.user;
              if (user != null) {
                return AuthUserData.fromFirebaseUser(
                  uid: user.uid,
                  name: user.displayName,
                  email: user.email,
                  photoUrl: user.photoURL,
                  token: userCred.credential!.token.toString(),
                );
              }
              return null;
            });
            hideLoadingDialog(context);
          } catch (e) {
            hideLoadingDialog(context);
            _showError(context, "Google sign-in failed: $e");
          }
          break;
        case 'Phone':
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) =>  PhoneSignInScreen()),
          );
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
      if (authUser != null && onSignInSuccess != null) {
        onSignInSuccess!(authUser);
      }
    } catch (e) {
      log("Sign-in error: $e");
      _showError(context, 'Error: $e');
    }
  }

  void _showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
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
    final theme = Theme.of(context);
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: backgroundColor ?? theme.colorScheme.primary,
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
                      color: phoneButtonColor ?? theme.colorScheme.secondary,
                      textColor: phoneTextColor ?? Colors.white,
                      icon: const Icon(Icons.phone, color: Colors.white),
                      onPressed: () => _onSignIn('Phone', context),
                    ),
                    const SizedBox(height: 15),
                  ],

                  if (enableGoogle) ...[
                    SocialButton(
                      text: 'Sign in with Google',
                      color: googleButtonColor ?? Colors.black,
                      textColor: googleTextColor ?? Colors.white,
                      assetIcon: googleAssetIcon,
                      packageName: googleAssetIcon != null ? null : packageName,
                      onPressed: () => _onSignIn('Google', context),
                    ),
                    const SizedBox(height: 15),
                  ],

                  if (enableEmail) ...[
                    SocialButton(
                      text: 'Continue with Email',
                      color: emailButtonColor ?? theme.colorScheme.secondary,
                      textColor: emailTextColor ?? Colors.white,
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
                      color: skipButtonColor ?? Colors.grey.shade300,
                      textColor: skipTextColor ?? Colors.black,
                      icon: const Icon(
                        Icons.emoji_emotions,
                        color: Colors.black,
                      ),
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

  void showLoadingDialog(BuildContext context, {String message = "Signing in..."}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(),
                const SizedBox(width: 16),
                Text(message),
              ],
            ),
          ),
        );
      },
    );
  }

  void hideLoadingDialog(BuildContext context) {
    Navigator.of(context, rootNavigator: true).pop();
  }
}

class SocialButton extends StatelessWidget {
  final String text;
  final Color color;
  final Icon? icon;
  final String? assetIcon;
  final String? packageName;
  final VoidCallback onPressed;
  final Color textColor;

  const SocialButton({
    super.key,
    required this.text,
    required this.color,
    required this.onPressed,
    this.icon,
    this.assetIcon,
    this.packageName,
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
            // Icon/Image section
            if (icon != null) 
              Padding(
                padding: const EdgeInsets.only(right: 12),
                child: icon!,
              ),
            
            if (assetIcon != null) 
              Padding(
                padding: const EdgeInsets.only(right: 12),
                child: _buildAssetImage(),
              ),
            
            // Text section
            Expanded(
              child: Text(
                text,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                  color: textColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAssetImage() {
    try {
      return Image.asset(
        assetIcon!, 
        height: 24, 
        width: 24, 
        package: packageName,
        errorBuilder: (context, error, stackTrace) {
          // Fallback icon if image fails to load
          return Icon(
            Icons.account_circle, 
            size: 24, 
            color: textColor,
          );
        },
      );
    } catch (e) {
      // Fallback icon if there's any error
      return Icon(
        Icons.account_circle, 
        size: 24, 
        color: textColor,
      );
    }
  }
}
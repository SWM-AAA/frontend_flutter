import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:frontend/user/consts/data.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginPolicyText extends StatefulWidget {
  const LoginPolicyText({
    super.key,
  });

  @override
  State<LoginPolicyText> createState() => _LoginPolicyTextState();
}

class _LoginPolicyTextState extends State<LoginPolicyText> {
  final Uri policyUrl = Uri.parse(POLICY_URL);
  Future<void> _launchUrl() async {
    if (!await launchUrl(policyUrl)) {
      throw Exception('Could not launch $policyUrl');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
              children: [
                const TextSpan(
                  text: 'By continuing you agree Zeppy’s Terms of ',
                  style: TextStyle(
                    color: Color(0xFF5C5F68),
                  ),
                ),
                TextSpan(
                  text:
                      'Services & Privacy & Position Policy', // Tappable words
                  style: const TextStyle(
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      _launchUrl(); // Replace with your URL
                    },
                ),
              ],
              style: const TextStyle(
                color: Color(0xFF5C5F68),
                fontSize: 12,
                fontWeight: FontWeight.w500,
                height: 1.33,
              ))),
    );
  }
}

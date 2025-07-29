import 'package:flutter/material.dart';
import 'package:note_app/core/utils/extensions/navigation_extensions.dart';

import '../../../../../../core/constants/app_assets.dart';
import '../../../../../../core/routing/routes.dart';
import '../../../../../../core/widgets/custom_login_with_google.dart';
import '../../../../../../core/widgets/signup_login_text.dart';

class SignUpSocialRow extends StatelessWidget {
  const SignUpSocialRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          "- OR Continue with -",
          style: TextStyle(
            fontSize: 12,
            color: Colors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomLoginWithGoogle(imagePath: AppAssets.googleIcon),
            const SizedBox(width: 10),
            CustomLoginWithGoogle(imagePath: AppAssets.appleIcon),
            const SizedBox(width: 10),
            CustomLoginWithGoogle(imagePath: AppAssets.facebookIcon),
          ],
        ),
        const SizedBox(height: 22),
        SignupLoginText(
          text1: "I Already Have an Account ",
          text2: "Login",
          onTap: () {
            context.pushReplacementNamed(Routes.loginScreen);
          },
        ),
      ],
    );
  }
}
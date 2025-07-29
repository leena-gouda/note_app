
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_app/core/utils/extensions/navigation_extensions.dart';
import 'package:note_app/features/auth/signup/ui/screens/widgets/signup_social_row.dart';
import '../../../../../core/routing/routes.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/utils/app_utils.dart';
import '../../../../../core/widgets/custom_button.dart';
import '../../../../../core/widgets/custom_loading_app.dart';
import '../../../../../core/widgets/custom_text_auth.dart';
import '../../../../../core/widgets/custom_text_form_field.dart';
import '../cubit/signup_cubit.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SignupCubit(),
      child: Scaffold(
        appBar: AppBar(toolbarHeight: 0),
        body: BlocConsumer<SignupCubit, SignUpState>(
          listener: (context, state) {
            if (state is SignUpLoading) {
              showLoadingApp(context);
            }
            if (state is SignUpSuccess) {
              context.back();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'تم التسجيل بنجاح!',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: AppColor.primaryColor,
                  // أو أي لون تريده
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  margin: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  elevation: 6,
                  duration: const Duration(seconds: 3),
                ),
              );

              context.pushReplacementNamed(Routes.loginScreen);
            }
            if (state is SignUpError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Error is ${state.message}',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  margin: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  elevation: 6,
                  duration: const Duration(seconds: 3),
                ),
              );
              context.back();
            }
          },
          builder: (context, state) {
            final signupCubit = context.read<SignupCubit>();
            return Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Form(
                    key: signupCubit.formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomTextAuth(text: "Create an\naccount"),
                        const SizedBox(height: 36),
                        CustomTextFormField(
                          hintText: "Username or Email",
                          controller: signupCubit.emailController,
                          keyboardType: TextInputType.emailAddress,
                          prefixIcon: Icon(Icons.person),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your username or email';
                            }
                            if (!AppUtils.isEmailValid(value.trim())) {
                              return 'Enter a valid email address';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 32),
                        CustomTextFormField(
                          obscureText: signupCubit.obscureText,
                          hintText: "Password",
                          controller: signupCubit.passwordController,
                          keyboardType: TextInputType.emailAddress,
                          prefixIcon: Icon(CupertinoIcons.lock_fill),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password';
                            }
                            return null;
                          },
                          suffixIcon: IconButton(
                            onPressed: () {
                              signupCubit.toggleObscureText();
                            },
                            icon: Icon(
                              signupCubit.obscureText == true
                                  ? CupertinoIcons.eye_fill
                                  : CupertinoIcons.eye_slash,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),
                        CustomTextFormField(
                          obscureText: signupCubit.obscureText2,
                          hintText: "ConfirmPassword",
                          controller: signupCubit.passwordConfirmController,
                          keyboardType: TextInputType.emailAddress,
                          prefixIcon: Icon(CupertinoIcons.lock_fill),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password';
                            }
                            return null;
                          },
                          suffixIcon: IconButton(
                            onPressed: () {
                              signupCubit.toggleObscureText2();
                            },
                            icon: Icon(
                              signupCubit.obscureText2 == true
                                  ? CupertinoIcons.eye_fill
                                  : CupertinoIcons.eye_slash,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        RichText(
                          textAlign: TextAlign.start,

                          text: TextSpan(
                            text: "By clicking the",
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF676767),
                              fontWeight: FontWeight.normal,
                              height: 1.4,
                            ),
                            children: [
                              // By clicking the Register button, you agree to the public offer
                              TextSpan(
                                text: " Register ",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: AppColor.primaryColor,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                              TextSpan(
                                text: "button, you agree\nto the public offer",
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 50),
                        CustomButton(
                          text: "Create Account",
                          onPressed: () {
                            signupCubit.signUp();
                          },
                        ),
                        const SizedBox(height: 70),
                        SignUpSocialRow(),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
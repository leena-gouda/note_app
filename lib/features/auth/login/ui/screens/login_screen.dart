
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_app/core/utils/extensions/navigation_extensions.dart';
import 'package:note_app/features/auth/login/ui/screens/widgets/login_social_row.dart';
import '../../../../../core/routing/routes.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/utils/app_utils.dart';
import '../../../../../core/widgets/custom_button.dart';
import '../../../../../core/widgets/custom_loading_app.dart';
import '../../../../../core/widgets/custom_text_auth.dart';
import '../../../../../core/widgets/custom_text_form_field.dart';
import '../../data/repos/login_repo.dart';
import '../cubit/login_cubit.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginCubit(LoginRepo()),
      child: Scaffold(
        appBar: AppBar(toolbarHeight: 0),
        body: BlocConsumer<LoginCubit, LoginState>(
          listener: (context, state) {
            if (state is LoginLoading) {
              showLoadingApp(context);
            }
            if (state is LoginSuccess) {
              context.back();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'You are Successfully logged in ${state.userModel?.username}',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: Colors.green,
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

              context.pushNamedAndRemoveUntil(Routes.homeScreen);
            }
            if (state is LoginError) {
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
            final loginCubit = context.read<LoginCubit>();
            return Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Form(
                    key: loginCubit.formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomTextAuth(text: "Welcome\nBack!"),
                        const SizedBox(height: 36),
                        CustomTextFormField(
                          hintText: "Username or Email",
                          controller: loginCubit.emailController,
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
                          obscureText: loginCubit.obscureText,
                          hintText: "Password",
                          controller: loginCubit.passwordController,
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
                              loginCubit.toggleObscureText();
                            },
                            icon: Icon(
                              loginCubit.obscureText == true
                                  ? CupertinoIcons.eye_fill
                                  : CupertinoIcons.eye_slash,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        Align(
                          alignment: AlignmentDirectional.centerEnd,
                          child: TextButton(
                            onPressed: () {},
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: Text(
                              "Forgot Password?",
                              style: TextStyle(
                                color: AppColor.primaryColor,
                                fontWeight: FontWeight.w500,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 50),
                        CustomButton(
                          text: "Login",
                          onPressed: () {
                            loginCubit.login();
                          },
                        ),
                        const SizedBox(height: 70),
                        LoginSocialRow(),
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
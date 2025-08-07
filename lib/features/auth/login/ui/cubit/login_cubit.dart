import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/models/user_model.dart';
import '../../data/repos/login_repo.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {

  final LoginRepo loginRepo;
  LoginCubit(this.loginRepo) : super(LoginInitial());

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool obscureText = true;

  void toggleObscureText() {
    obscureText = !obscureText;
    emit(LoginInitial());
  }

  void login() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    if (formKey.currentState?.validate() == true) {
      emit(LoginLoading());
      try {
        final result = await loginRepo.login(emailController.text, passwordController.text);
        emit(LoginSuccess(userModel: result));
        prefs.setString("username", result.username.toString());
        prefs.setString("email", result.email.toString());
        prefs.setString("userId", result.id.toString());
        print("prefs : ${prefs.getString("email")}");
        print("prefs : ${prefs.getString("username")}");
        print("prefs : ${prefs.getString("userId")}");

      } catch (e) {
        debugPrint("Login Error: $e");
        emit(LoginError(message: e.toString()));
      }
    }
  }

}
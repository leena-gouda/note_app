import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

import '../../../login/data/models/user_model.dart';
import '../../data/repos/signup_repo.dart';

part 'signup_state.dart';

class SignupCubit extends Cubit<SignUpState> {
  final SignUpRepo signUpRepo;

  SignupCubit(this.signUpRepo) : super(SignUpInitial());

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool obscureText = true;
  bool obscureText2 = true;

  void toggleObscureText() {
    obscureText = !obscureText;
    emit(SignUpInitial());
  }

  void toggleObscureText2() {
    obscureText2 = !obscureText2;
    emit(SignUpInitial());
  }

  void signUp() async {
    if (formKey.currentState?.validate() == true) {
      emit(SignUpLoading());

      try {
        final result = await signUpRepo.signUp(
          usernameController.text,
          emailController.text,
          passwordController.text,
        );
        emit(SignUpSuccess(user: result));
      } catch (e) {
        emit(SignUpError(message: e.toString()));
        print(e);
      }
    }
  }
}
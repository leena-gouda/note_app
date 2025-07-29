import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final FirebaseAuth auth = FirebaseAuth.instance;

  bool obscureText = true;

  void toggleObscureText() {
    obscureText = !obscureText;
    emit(LoginInitial());
  }

  void login() async {
    if (formKey.currentState?.validate() == true) {
      emit(LoginLoading());

      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );

        emit(LoginSuccess());
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          print('No user found for that email.');
        } else if (e.code == 'wrong-password') {
          print('Wrong password provided for that user.');
        }
        emit(
          LoginError(message: e.message ?? 'An error occurred during login'),
        );
      } catch (e) {
        emit(LoginError(message: e.toString()));
      }
    }
  }
}
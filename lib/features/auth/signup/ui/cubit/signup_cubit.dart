import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

part 'signup_state.dart';

class SignupCubit extends Cubit<SignUpState> {
  SignupCubit() : super(SignUpInitial());

  final FirebaseAuth auth = FirebaseAuth.instance;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController passwordConfirmController =
  TextEditingController();
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

      if (passwordController.text != passwordConfirmController.text) {
        emit(SignUpError(message: 'Passwords do not match'));
        print('Passwords do not match');
        return;
      }

      try {
        await auth.createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );
        emit(SignUpSuccess());
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          print('The password provided is too weak.');
        } else if (e.code == 'email-already-in-use') {
          print('The account already exists for that email.');
        }
        emit(SignUpError(message: e.code));
      } catch (e) {
        emit(SignUpError(message: e.toString()));
        print(e);
      }
    }
  }
}
import 'package:doc_saver_app/helper/snackbar_helper.dart';
import 'package:doc_saver_app/screens/authentication.dart';
import 'package:doc_saver_app/screens/homescreen.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthProvider extends ChangeNotifier {
  bool _isLogin = true;
  bool get isLogin => _isLogin;

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseDatabase _firebaseDatabase = FirebaseDatabase.instance;

  setIsLogin() {
    _isLogin = !_isLogin;
    notifyListeners();
  }

  bool _obscureText = true;
  bool get obscureText => _obscureText;

  setObscurePassword() {
    _obscureText = !_obscureText;
    notifyListeners();
  }

  bool _obscurePassword = true;
  bool get obscurePassword => _obscurePassword;

  setObscureConfirmPassword() {
    _obscurePassword = !_obscurePassword;
    notifyListeners();
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  setIsLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  signUp(
    BuildContext context, {
    required String email,
    required String password,
    required String username,
  }) async {
    try {
      setIsLoading(true);
      UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(
        email: email,
        password: password,
      )
          .then((value) async {
        await _firebaseDatabase
            .ref()
            .child("user_info/${value.user!.uid}")
            .set({"username": username});
        setIsLoading(false);
        SnackbarHelper.showSuccessSnackbar(context, 'SignUp Successful!');
        Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
        return value;
      });
    } on FirebaseAuthException catch (e) {
      setIsLoading(false);
      SnackbarHelper.showErrorSnackbar(context, e.message!);
    } catch (error) {
      setIsLoading(false);
      SnackbarHelper.showErrorSnackbar(context, error.toString());
    }
  }

  signIn(BuildContext context,
      {required String email, required String password}) async {
    try {
      setIsLoading(true);
      UserCredential userCredential = await _firebaseAuth
          .signInWithEmailAndPassword(
        email: email,
        password: password,
      )
          .then((value) {
        setIsLoading(false);
        SnackbarHelper.showSuccessSnackbar(context, 'Login Successful!');
        Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
        return value;
      });
    } on FirebaseAuthException catch (e) {
      setIsLoading(false);
      SnackbarHelper.showErrorSnackbar(context, e.message!);
    } catch (error) {
      setIsLoading(false);
      SnackbarHelper.showErrorSnackbar(context, error.toString());
    }
  }

  bool _isLoadingForgetPassword = false;
  bool get isLoadingForgetPassword => _isLoadingForgetPassword;

  setIsLoadingForgetPassword(bool value) {
    _isLoadingForgetPassword = value;
    notifyListeners();
  }

  forgetPassword(String email, BuildContext context) async {
    try {
      setIsLoadingForgetPassword(true);
      await _firebaseAuth.sendPasswordResetEmail(email: email).then((value) {
        setIsLoadingForgetPassword(false);
        SnackbarHelper.showSuccessSnackbar(
            context, ' Reset password link has been successfully sent!');
      });
    } on FirebaseAuthException catch (e) {
      setIsLoadingForgetPassword(false);
      SnackbarHelper.showErrorSnackbar(context, e.message!);
    } catch (error) {
      setIsLoadingForgetPassword(false);
      SnackbarHelper.showErrorSnackbar(context, error.toString());
    }
  }

  bool _isLoadingLogout = false;
  bool get isLoadingLogout => _isLoadingLogout;

  setIsLoadingLogout(bool value) {
    _isLoadingLogout = value;
    notifyListeners();
  }

  logout(BuildContext context) async {
    try {
      setIsLoadingLogout(true);
      await _firebaseAuth.signOut().then((value) {
        setIsLoadingLogout(false);
        SnackbarHelper.showSuccessSnackbar(context, 'Logout Successful!');
        Navigator.of(context).popUntil((route) =>
            route.isFirst); // Pops all screens in stack until initial Screen!
        Navigator.of(context).pushReplacementNamed(AuthScreen.routeName);
      });
    } on FirebaseAuthException catch (e) {
      setIsLoadingLogout(false);
      SnackbarHelper.showErrorSnackbar(context, e.message!);
    } catch (error) {
      setIsLoadingLogout(false);
      SnackbarHelper.showErrorSnackbar(context, error.toString());
    }
  }
}

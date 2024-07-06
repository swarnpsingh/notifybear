import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseAuthServices {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<void> signUp(
      _emailController, _passwordController, _usernameController) async {
    try {
      // Create user with email and password
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      // Store additional user data in Firestore
      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'UserName': _usernameController.text,
        'email': _emailController.text,
      });

      // User signed up successfully
      print("Signed up: ${userCredential.user!.uid}");
      SnackBar(content: Text('Sign in successful!'));
      // Navigate to the next screen or show a success message
    } on FirebaseAuthException catch (e) {
      String message;
      if (e.code == 'weak-password') {
        message = 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        message = 'An account already exists for that email.';
      } else {
        message = 'Error: ${e.message}';
      }
      SnackBar(content: Text('Sign in failed: $e'));
    } catch (e) {
      print(e);
      SnackBar(content: Text('Sign in failed: $e'));
    }
  }

  Future<void> signInWithGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        return; // The user canceled the sign-in
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await _auth.signInWithCredential(credential);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Sign in successful!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Sign in failed: $e')),
      );
    }
  }

  Future<void> signUpWithFacebook(BuildContext context) async {
    try {
      // Trigger the sign-in flow
      final LoginResult loginResult = await FacebookAuth.instance.login();
      // Check if login was successful
      if (loginResult.status == LoginStatus.success) {
        // Create a credential from the access token
        final OAuthCredential facebookAuthCredential =
            FacebookAuthProvider.credential(
                loginResult.accessToken!.tokenString);

        // Once signed in, return the UserCredential
        UserCredential userCredential = await FirebaseAuth.instance
            .signInWithCredential(facebookAuthCredential);

        // You can access the new user via userCredential.user
        print("Signed up: ${userCredential.user!.displayName}");
      } else {
        print("Facebook login failed: ${loginResult.status}");
        print("Message: ${loginResult.message}");
      }
    } on FirebaseAuthException catch (e) {
      print(e.message);
      // Handle Firebase Auth-specific errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Firebase Auth error: ${e.message}')),
      );
    } catch (e) {
      print(e);
      // Handle other errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred. Please try again.')),
      );
    }
  }
}

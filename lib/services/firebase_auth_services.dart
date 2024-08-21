import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:notifybear/screens/add_platforms.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:twitter_login/twitter_login.dart';

class FirebaseAuthServices {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // Method to save user ID in SharedPreferences
  Future<void> _saveUserId(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_id', userId);
  }

// Method to get user ID from SharedPreferences
  Future<String?> _getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_id');
  }

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

      // Save user ID in SharedPreferences
      await _saveUserId(userCredential.user!.uid);

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
      final GoogleSignInAccount? googleUser = await GoogleSignIn(
        scopes: ['https://www.googleapis.com/auth/youtube.readonly'],
      ).signIn();
      if (googleUser == null) {
        return; // The user canceled the sign-in
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase Authentication
      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      final User? user = userCredential.user;

      if (user != null) {
        // Save user ID in SharedPreferences
        await _saveUserId(user.uid);

        // Request a token with the YouTube scope
        final String? token = await user.getIdToken(true);

        if (token != null) {
          // Use this token to make YouTube API requests
          final response = await http.get(
            Uri.parse(
                'https://www.googleapis.com/youtube/v3/subscriptions?part=snippet&mine=true&maxResults=50'),
            headers: {
              'Authorization': 'Bearer $token',
            },
          );

          if (response.statusCode == 200) {
            // Successfully fetched YouTube data
            print('YouTube data: ${response.body}');
          } else {
            print('Failed to fetch YouTube data: ${response.statusCode}');
          }
        }

        // Store user info in Firestore (preserving existing fields)
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set(
            {
              'username': user.displayName,
              'email': user.email,
              // You can add more fields as needed
            },
            SetOptions(
                merge:
                    true)); // Using merge: true to preserve existing fields like selectedChannels

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Sign in successful!')),
        );
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => AddPlatforms()));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('User information not found')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Sign in failed: $e')),
      );
    }
  }

  Future<void> signInWithFacebook(BuildContext context) async {
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

        // Save user ID in SharedPreferences
        await _saveUserId(userCredential.user!.uid);

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

  Future<void> signInWithTwitter() async {
    // Create a TwitterLogin instance
    final twitterLogin = TwitterLogin(
      apiKey: 'UUWTBIJwVGKAazTUgmx2HadNZ',
      apiSecretKey: 'sS02dU9JvNOAmaemWLkgx1gqmjie91KWf8uoi2ur9ZMOsRYccJ',
      redirectURI: 'https://notifybear-5195a.firebaseapp.com/__/auth/handler',
    );

    // Trigger the sign-in flow
    final authResult = await twitterLogin.login();

    // Now you can switch on the status
    switch (authResult.status) {
      case TwitterLoginStatus.loggedIn:
        // success
        print('Logged in! Username: ${authResult.user?.name}');
        break;
      case TwitterLoginStatus.cancelledByUser:
        // cancel
        print('Login cancelled by user.');
        break;
      case TwitterLoginStatus.error:
        // error
        print('Login error: ${authResult.errorMessage}');
        break;
      case TwitterLoginStatus.cancelledByUser:
        // cancel
        print('Login cancelled by user.');
        break;
      case null:
        print('null');
    }
  }

  void sendPasswordResetEmail(BuildContext context, emailController) async {
    String email = emailController.text.trim();

    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Invalid email format')),
      );
      return;
    }

    try {
      await _auth.sendPasswordResetEmail(email: email);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Password reset email sent')),
      );
    } catch (e) {
      print('Failed to send password reset email: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text('Failed to send password reset email: ${e.toString()}')),
      );
    }
  }
}

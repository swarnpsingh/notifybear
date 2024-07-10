import 'package:flutter/material.dart';
import 'package:notifybear/services/firebase_auth_services.dart';

import '../../shared/my_colors.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  TextEditingController emailController = TextEditingController();
  FirebaseAuthServices firebaseAuthServices = FirebaseAuthServices();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(builder: (context, constraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: constraints.maxHeight,
            ),
            child: IntrinsicHeight(
              child: Container(
                decoration: BoxDecoration(
                  gradient: MyColors.getBackgroundGradient(),
                ),
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Image.asset(
                            'assets/notifybear.com.png', // Add your logo image path here
                            height: 5,
                            width: 400,
                            //fit: BoxFit.contain,
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        TextField(
                          controller: emailController,
                          decoration: InputDecoration(
                            labelText: 'Email',
                          ),
                          keyboardType: TextInputType.emailAddress,
                          style: TextStyle(color: Colors.white),
                        ),
                        SizedBox(height: 30.0),
                        ElevatedButton(
                          onPressed: () => firebaseAuthServices
                              .sendPasswordResetEmail(context, emailController),
                          child: Text('Send Password Reset Email'),
                        ),
                        SizedBox(
                          height: 250,
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}

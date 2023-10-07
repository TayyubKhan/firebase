import 'package:firebase/Utilis/Utilis.dart';
import 'package:firebase/screens/auth/verifyscreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../widgets/RoundedButton.dart';

class RegisterWithPhone extends StatefulWidget {
  const RegisterWithPhone({super.key});

  @override
  State<RegisterWithPhone> createState() => _RegisterWithPhoneState();
}

class _RegisterWithPhoneState extends State<RegisterWithPhone> {
  @override
  bool loading = false;
  TextEditingController phoneController = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    phoneController.dispose();
  }

  void loginWithPhone() {
    setState(() {
      loading = true;
    });
    auth.verifyPhoneNumber(
        phoneNumber: phoneController.text.toString(),
        verificationCompleted: (_) {
          setState(() {
            loading = false;
          });
        },
        verificationFailed: (e) {
          setState(() {
            loading = false;
          });
          Utilis().toastMessage(e.toString());
        },
        codeSent: (String verificationId, int? token) {
          setState(() {
            loading = false;
          });
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      VerifyWithPhone(verificationId: verificationId)));
        },
        codeAutoRetrievalTimeout: (e) {
          setState(() {
            loading = false;
          });
          Utilis().toastMessage(e.toString());
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          automaticallyImplyLeading: false,
          title: const Text(
            'Login',
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  TextFormField(
                    keyboardType: TextInputType.phone,
                    controller: phoneController,
                    cursorColor: Colors.black,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Enter Phone';
                      } else {
                        return null;
                      }
                    },
                    decoration: const InputDecoration(
                        focusedBorder: UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.black, width: 2)),
                        prefixIcon: Icon(
                          Icons.phone,
                          color: Colors.black,
                        ),
                        hintText: '+1 234 567 89'),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              RoundedButton(
                title: 'Verify',
                loading: loading,
                onTap: () {
                  loginWithPhone();
                },
              )
            ],
          ),
        ));
  }
}

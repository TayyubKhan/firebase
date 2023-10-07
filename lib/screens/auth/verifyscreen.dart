// ignore_for_file: use_build_context_synchronously

import 'package:firebase/Utilis/Utilis.dart';
import 'package:firebase/screens/Posts/PostScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../widgets/RoundedButton.dart';

class VerifyWithPhone extends StatefulWidget {
  final String verificationId;
  const VerifyWithPhone({super.key, required this.verificationId});

  @override
  State<VerifyWithPhone> createState() => _VerifyWithPhoneState();
}

class _VerifyWithPhoneState extends State<VerifyWithPhone> {
  @override
  bool loading = false;
  TextEditingController codeController = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    codeController.dispose();
  }

  void loginWithPhone() async {
    setState(() {
      loading = true;
    });
    final credential = PhoneAuthProvider.credential(
        verificationId: widget.verificationId,
        smsCode: codeController.text.toString());
    try {
      await auth.signInWithCredential(credential);
      setState(() {
        loading = false;
      });
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const PostScreen()));
    } catch (e) {
      setState(() {
        loading = false;
      });
      Utilis().toastMessage(e.toString());
    }
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
                    controller: codeController,
                    cursorColor: Colors.black,
                    validator: (value) {
                      if (value!.isEmpty) {
                        if (value.length < 6) {
                          return 'Enter 6 Digit Password';
                        }
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
                        hintText: '6 digit Password '),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              RoundedButton(
                title: 'Login',
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

// ignore_for_file: use_build_context_synchronously
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase/Utilis/Utilis.dart';
import 'package:firebase/widgets/RoundedButton.dart';
import 'package:flutter/material.dart';

class FireStoreAddData extends StatefulWidget {
  const FireStoreAddData({super.key});

  @override
  State<FireStoreAddData> createState() => _FireStoreAddDataState();
}

class _FireStoreAddDataState extends State<FireStoreAddData> {
  final dataController = TextEditingController();
  bool loading = false;
  final fireStore = FirebaseFirestore.instance.collection('collection');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: const Text(
          'Add FireStore Data',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextFormField(
              maxLines: 4,
              keyboardType: TextInputType.text,
              controller: dataController,
              cursorColor: Colors.black,
              validator: (value) {},
              decoration: const InputDecoration(
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black, width: 1)),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black, width: 2)),
                  hintText: 'Add Data'),
            ),
            const SizedBox(
              height: 50,
            ),
            RoundedButton(
                title: 'Add',
                loading: loading,
                onTap: () async {
                  setState(() {
                    loading = true;
                  });
                  String id = DateTime.now().millisecondsSinceEpoch.toString();
                  await fireStore.doc(id).set({
                    'id': id,
                    'title': dataController.text.toString()
                  }).then((value) {
                    setState(() {
                      loading = false;
                    });
                    Utilis().toastMessage('Added');
                  }).onError((error, stackTrace) {
                    setState(() {
                      loading = false;
                    });
                    Utilis().toastMessage(error.toString());
                  });
                  Navigator.pop(context);
                })
          ],
        ),
      ),
    );
  }
}

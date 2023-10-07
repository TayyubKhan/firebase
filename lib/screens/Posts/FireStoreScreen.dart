import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase/Utilis/Utilis.dart';
import 'package:firebase/screens/Posts/FireStoreAddData.dart';
import 'package:firebase/screens/auth/loginscreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FireStoreScreen extends StatefulWidget {
  const FireStoreScreen({super.key});

  @override
  State<FireStoreScreen> createState() => _FireStoreScreenState();
}

class _FireStoreScreenState extends State<FireStoreScreen> {
  final editController = TextEditingController();
  FirebaseAuth auth = FirebaseAuth.instance;
  final fireStore =
      FirebaseFirestore.instance.collection('collection').snapshots();
  final fireStoreUpdate = FirebaseFirestore.instance.collection('collection');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: const Text(
          'FireStoreScreen',
        ),
        actions: [
          IconButton(
              onPressed: () {
                auth.signOut().then((value) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginScreen()));
                }).onError((error, stackTrace) {
                  Utilis().toastMessage(error.toString());
                });
              },
              icon: const Icon(
                Icons.logout,
                color: Colors.black,
              ))
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
                stream: fireStore,
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    const Text('Error');
                  }
                  return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(
                              snapshot.data!.docs[index]!['title'].toString()),
                          subtitle:
                              Text(snapshot.data!.docs[index]!.id.toString()),
                          trailing: PopupMenuButton(
                            icon: const Icon(Icons.more_vert),
                            itemBuilder: (context) => [
                              PopupMenuItem(
                                  child: ListTile(
                                onTap: () {
                                  Navigator.pop(context);
                                  showMyDialogue(
                                      snapshot.data!.docs[index]!.id.toString(),
                                      snapshot.data!.docs[index]!['title']
                                          .toString());
                                },
                                leading: const Text('Edit'),
                                title: const Icon(Icons.edit),
                              )),
                              PopupMenuItem(
                                  child: ListTile(
                                onTap: () async {
                                  Navigator.pop(context);
                                  await fireStoreUpdate
                                      .doc(snapshot.data!.docs[index]!.id
                                          .toString())
                                      .delete();
                                  Utilis().toastMessage('Deleted');
                                },
                                leading: const Text('Delete'),
                                title: const Icon(Icons.delete),
                              )),
                            ],
                          ),
                        );
                      });
                }),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.black,
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const FireStoreAddData()));
          },
          child: const Icon(Icons.add, color: Colors.white)),
    );
  }

  Future<void> showMyDialogue(String id, title) async {
    return showDialog(
        context: context,
        builder: (context) {
          editController.text = title;
          return AlertDialog(
            title: const Text('Update'),
            content: TextFormField(
              keyboardType: TextInputType.text,
              controller: editController,
              cursorColor: Colors.black,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black, width: 1)),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black, width: 2)),
                  hintText: 'Add post'),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel')),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    fireStoreUpdate
                        .doc(id)
                        .update({'title': editController.text.toString()});
                  },
                  child: const Text('Update')),
            ],
          );
        });
  }
}

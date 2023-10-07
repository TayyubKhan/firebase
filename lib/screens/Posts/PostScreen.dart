import 'package:firebase/Utilis/Utilis.dart';
import 'package:firebase/screens/Posts/addpost.dart';
import 'package:firebase/screens/auth/loginscreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({super.key});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  final editController = TextEditingController();
  FirebaseAuth auth = FirebaseAuth.instance;
  final ref = FirebaseDatabase.instance.ref('Post');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: const Text(
          'Post',
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
            child: StreamBuilder(
                stream: ref.onValue,
                builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    Map<dynamic, dynamic> map =
                        snapshot.data!.snapshot.value as dynamic;
                    List<dynamic> list = [];
                    list.clear();
                    list = map.values.toList();
                    return ListView.builder(
                        itemCount: list.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            trailing: PopupMenuButton(
                              icon: const Icon(Icons.more_vert),
                              itemBuilder: (context) => [
                                PopupMenuItem(
                                    child: ListTile(
                                  leading: const Icon(Icons.edit),
                                  title: const Text('Update'),
                                  onTap: () {
                                    Navigator.pop(context);
                                    showMyDialogue(list[index]['id'].toString(),
                                        list[index]['Title'].toString());
                                  },
                                )),
                                PopupMenuItem(
                                    child: ListTile(
                                  leading: const Icon(Icons.delete),
                                  title: const Text('Delete'),
                                  onTap: () {
                                    Navigator.pop(context);
                                    ref
                                        .child(list[index]['id'].toString())
                                        .remove()
                                        .then((value) {
                                      Utilis().toastMessage('Deleted');
                                    }).onError((error, stackTrace) {
                                      Utilis().toastMessage(error.toString());
                                    });
                                  },
                                ))
                              ],
                            ),
                            subtitle: Text(list[index]['id'].toString()),
                            title: Text(list[index]['Title'].toString(),
                                style: const TextStyle(
                                    fontSize: 24, fontWeight: FontWeight.bold)),
                          );
                        });
                  }
                }),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.black,
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const AddPost()));
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
                    ref
                        .child(id)
                        .update({'Title': editController.text.toString()}).then(
                            (value) {
                      Utilis().toastMessage('Updated');
                    }).onError((error, stackTrace) {
                      Utilis().toastMessage(error.toString());
                    });
                  },
                  child: const Text('Update')),
            ],
          );
        });
  }
}

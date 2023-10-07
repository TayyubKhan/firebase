// ignore_for_file: use_build_context_synchronously

import 'package:firebase/widgets/RoundedButton.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class AddPost extends StatefulWidget {
  const AddPost({super.key});

  @override
  State<AddPost> createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  final postController = TextEditingController();
  bool loading = false;
  final databaseRef = FirebaseDatabase.instance.ref('Post');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: const Text(
          'Add Post',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextFormField(
              maxLines: 4,
              keyboardType: TextInputType.text,
              controller: postController,
              cursorColor: Colors.black,
              validator: (value) {},
              decoration: const InputDecoration(
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black, width: 1)),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black, width: 2)),
                  hintText: 'Add post'),
            ),
            const SizedBox(
              height: 50,
            ),
            RoundedButton(
                title: 'Post',
                loading: loading,
                onTap: () async {
                  setState(() {
                    loading = true;
                  });
                  String id = DateTime.now().millisecondsSinceEpoch.toString();
                  await databaseRef
                      .child(id)
                      .set({'id': id, 'Title': postController.text.toString()});
                  setState(() {
                    loading = false;
                  });
                  Navigator.pop(context);
                })
          ],
        ),
      ),
    );
  }
}

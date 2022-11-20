import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fm_notes_app/screens/notes_editor.dart';
import 'package:google_fonts/google_fonts.dart';

import '../helpers/cloud_firestore_helper.dart';
import '../style/app_style.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static GlobalKey<FormState> formKey = GlobalKey<FormState>();
  static TextEditingController titleController = TextEditingController();
  static TextEditingController contextController = TextEditingController();

  String title = "";
  String content = "";


  @override
  Widget build(BuildContext context) {
    return Scaffold(
   
      backgroundColor: Colors.black,
      appBar: AppBar(
     
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/images/firebaselogo.png",
              scale: 12,
            ),
            const SizedBox(width: 8),
            const Text(
              "FireNotes",
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 24),
            ),
          ],
        ),
        centerTitle: true,
        backgroundColor: Colors.black,
        // backgroundColor: AppStyle.mainColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Notes",
              style: GoogleFonts.roboto(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream:
                    CloudFirestoreHelper.cloudFirestoreHelper.selectRecord(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (snapshot.hasData) {
                    QuerySnapshot? data = snapshot.data;
                    List<QueryDocumentSnapshot> list = data!.docs;
                    return ListView.builder(
                        itemCount: list.length,
                        itemBuilder: (context, i) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Card(
                              elevation: 3,
                              color: AppStyle.cardsColor[list[i]['color_id']],
                              child: ListTile(
                                
                                title: Text(
                                  "${list[i]['note_title']}",
                                  style: AppStyle.mainTitle,
                                ),
                                subtitle: Text("${list[i]['note_content']}"),

                                

                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        updateData(id: list[i].id);
                                      },
                                      icon: const Icon(
                                        Icons.edit,
                                        color: Colors.blue,
                                      ),
                                    ),
                                    IconButton(
                                        onPressed: () async {
                                          await CloudFirestoreHelper
                                              .cloudFirestoreHelper
                                              .deleteRecord(
                                            id: list[i].id,
                                          );
                                        },
                                        icon: const Icon(
                                          Icons.delete,
                                          color: Colors.red,
                                        )),
                                  ],
                                ),
                              ),
                            ),
                          );
                        });
                  }
                  return Text(
                    "There is no Notes",
                    style: GoogleFonts.nunito(color: Colors.white),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xfffcca3f),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
           
              builder: (context) => const NoteEditor_Page(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  updateData({required String id}) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Color(0xfffcca3f),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Center(
                  child: Text(
                    "Update Data",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                TextFormField(
                  controller: titleController,
                  onSaved: (val) {
                    title = val!;
                  },
                  validator: (val) {
                    (val!.isEmpty) ? 'Enter your title first...' : null;
                  },
                  decoration: const InputDecoration(
                    hintText: "Title",
                    border: OutlineInputBorder(),
                    label: Text("title"),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                TextFormField(
                  controller: contextController,
                  onSaved: (val) {
                    content = val!;
                  },
                  validator: (val) {
                    (val!.isEmpty) ? 'Enter your context first' : null;
                  },
                  decoration: const InputDecoration(
                    hintText: "Context",
                    border: OutlineInputBorder(),
                    label: Text("content"),
                  ),
                ),
                SizedBox(
                  height: 25,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                      ),
                      onPressed: () async {
                        Navigator.of(context).pop();
                        if (formKey.currentState!.validate()) {
                          formKey.currentState!.save();

                          Map<String, dynamic> update = {
                            'note_title': title,
                            'note_content': content,
                          };

                          CloudFirestoreHelper.cloudFirestoreHelper
                              .updateRecord(id: id, updateData: update);

                          titleController.clear();
                          contextController.clear();

                          setState(() {
                            title = "";
                            content = "";
                          });
                        } else {
                          Navigator.of(context).pop();
                        }
                      },
                      child: const Text("Update"),
                    ),
                    OutlinedButton(
                      onPressed: () {
                        titleController.clear();
                        contextController.clear();

                        setState(() {
                          title = "";
                          content = "";
                        });
                        Navigator.of(context).pop();
                      },
                      child: const Text(
                        "Cancel",
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

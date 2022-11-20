import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../style/app_style.dart';

class NoteEditor_Page extends StatefulWidget {
  const NoteEditor_Page({Key? key}) : super(key: key);

  @override
  State<NoteEditor_Page> createState() => _NoteEditor_PageState();
}

class _NoteEditor_PageState extends State<NoteEditor_Page> {
  int color_id = Random().nextInt(AppStyle.cardsColor.length);

  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();
  String date = DateTime.now().toString();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    
      backgroundColor: AppStyle.cardsColor[color_id],
     
      body: Padding(
        padding: const EdgeInsets.only(top: 50, left: 5),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  border: InputBorder.none,
                  hintText: 'Note Title',
                ),
                style: AppStyle.mainTitle,
              ),
            ),

            // Text(
            //   date,
            //   style: AppStyle.dateTitle,
            // ),
            const SizedBox(
              height: 5,
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: TextField(
                controller: contentController,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  fillColor: Colors.white,
                  filled: true,
                  hintText: 'Note Content',
                ),
                style: AppStyle.mainContent,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        //backgroundColor: AppStyle.accentColor,
        backgroundColor: const Color(0xfffcca3f),
        onPressed: () {
          FirebaseFirestore.instance.collection("Notes").add({
            "note_title": titleController.text,
            "note_content": contentController.text,
            //"creation_date": date,
            "color_id": color_id,
          }).then((value) {
            print(value.id);
            Navigator.of(context).pop();
          }).catchError((error) => print("Failed to add new $error"));
        },
        child: const Icon(Icons.save_rounded),
      ),
    );
  }
}

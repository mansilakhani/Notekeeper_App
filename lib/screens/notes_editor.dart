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
      // backgroundColor: Colors.black,
      backgroundColor: AppStyle.cardsColor[color_id],
      // appBar: AppBar(
      //   backgroundColor: AppStyle.cardsColor[color_id],
      //   iconTheme: IconThemeData(color: Colors.black),
      //   // title: Text(
      //   //   "Add a new Note",
      //   //   style: TextStyle(
      //   //       color: Colors.black, fontSize: 24, fontWeight: FontWeight.w900),
      //   // ),
      //   centerTitle: true,
      // ),
      body: Padding(
        padding: const EdgeInsets.only(top: 60, left: 20),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: 'Note Title',
              ),
              style: AppStyle.mainTitle,
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              date,
              style: AppStyle.dateTitle,
            ),
            const SizedBox(
              height: 28,
            ),
            TextField(
              controller: contentController,
              keyboardType: TextInputType.multiline,
              maxLines: null,
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: 'Note Context',
              ),
              style: AppStyle.mainContent,
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
            "creation_date": date,
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

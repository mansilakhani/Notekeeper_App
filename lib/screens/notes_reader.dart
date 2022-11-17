import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fm_notes_app/style/app_style.dart';

class NoteReader_Page extends StatefulWidget {
  NoteReader_Page({
    required this.doc,
    Key? key,
  }) : super(key: key);
  QueryDocumentSnapshot doc;

  @override
  State<NoteReader_Page> createState() => _NoteReader_PageState();
}

class _NoteReader_PageState extends State<NoteReader_Page> {
  @override
  Widget build(BuildContext context) {
    int color_id = widget.doc['color_id'];
    return Scaffold(
      backgroundColor: AppStyle.cardsColor[color_id],
      appBar: AppBar(
        backgroundColor: AppStyle.cardsColor[color_id],
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              widget.doc["note_title"],
              style: AppStyle.mainTitle,
            ),
            const SizedBox(height: 4),
            Text(
              widget.doc["creation_date"],
              style: AppStyle.dateTitle,
            ),
            const SizedBox(height: 28),
            Text(
              widget.doc["note_content"],
              style: AppStyle.mainTitle,
              overflow: TextOverflow.ellipsis,
            )
          ],
        ),
      ),
    );
  }
}

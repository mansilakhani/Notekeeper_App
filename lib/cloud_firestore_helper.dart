import 'package:cloud_firestore/cloud_firestore.dart';

class CloudFirestoreHelper {
  CloudFirestoreHelper._();

  static final CloudFirestoreHelper cloudFirestoreHelper =
      CloudFirestoreHelper._();

  //static final
  static final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  late CollectionReference notesRef;
  late CollectionReference countersRef;

  //todo: connectWithStudentsCollection

  void connectWithNotessCollection() {
    notesRef = firebaseFirestore.collection("Notes");
  }

  void connectWithCountersCollection() {
    countersRef = firebaseFirestore.collection("count");
  }

  Future<void> insertRecord({required Map<String, dynamic> data}) async {
    connectWithNotessCollection();
    connectWithCountersCollection();

    DocumentSnapshot documentSnapshot =
        await countersRef.doc('notes-counter').get();

    Map<String, dynamic> counterData =
        documentSnapshot.data() as Map<String, dynamic>;

    int counter = counterData['count'];

    await notesRef.doc('${++counter}').set(data);

    await countersRef.doc('notes-counter').update({'count': counter});
  }

  Stream<QuerySnapshot<Object?>> selectRecord() {
    connectWithNotessCollection();

    return notesRef.snapshots();
  }

  Future<void> updateRecord(
      {required String id, required Map<String, dynamic> updateData}) async {
    connectWithNotessCollection();

    await notesRef.doc(id).update(updateData);
  }

  Future<void> deleteRecord({required String id}) async {
    connectWithNotessCollection();

    await notesRef.doc(id).delete();
  }
}

import 'package:chat_app_2/helpers/auth_helper.dart';
import 'package:chat_app_2/modals/chat_modal.dart';
import 'package:chat_app_2/modals/detail_madal.dart';
import 'package:chat_app_2/modals/friend_modal.dart';
import 'package:chat_app_2/modals/user_modal.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FireStoreHelper {
  FireStoreHelper._();

  static final FireStoreHelper fireStoreHelper = FireStoreHelper._();

  FirebaseFirestore fireStore = FirebaseFirestore.instance;

  String collectionPath = "Users";
  String collection = "friends";

  Future<void> addUser({required DetailModal detailModal}) async {
    await fireStore
        .collection(collectionPath)
        .doc(detailModal.email)
        .set(detailModal.toMap);
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getUserData() {
    String? email = Auth.auth.firebaseAuth.currentUser!.email;

    return fireStore
        .collection(collectionPath)
        .where('email', isNotEqualTo: email)
        .snapshots();
  }

  Future<void> addFriend({required DetailModal detailModal}) async {
    String? email = Auth.auth.firebaseAuth.currentUser!.email;

    FriendModal friendModal = FriendModal(
      firstName: detailModal.firstName,
      lastName: detailModal.lastName,
      email: detailModal.email,
      profilePic: detailModal.image,
    );

    await fireStore
        .collection(collectionPath)
        .doc(email)
        .collection(collection)
        .doc(detailModal.email)
        .set(friendModal.toMap());
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getFriendList() {
    String? email = Auth.auth.firebaseAuth.currentUser!.email;
    return fireStore
        .collection(collectionPath)
        .doc(email)
        .collection(collection)
        .snapshots();
  }

  Future<void> sentMessage(
      {required ChatModal chatModal,
      required String senderId,
      required String receiverId}) async {
    Map<String, dynamic> data = chatModal.toMap;

    data.update('type', (value) => 'sent');

    await fireStore
        .collection(collectionPath)
        .doc(senderId)
        .collection(receiverId)
        .doc(chatModal.dateTime.millisecondsSinceEpoch.toString())
        .set(data);

    data.update('type', (value) => 'rec');

    await fireStore
        .collection(collectionPath)
        .doc(receiverId)
        .collection(senderId)
        .doc(chatModal.dateTime.millisecondsSinceEpoch.toString())
        .set(data);
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getChats(
      {required String senderId, required String receiverId}) {
    return fireStore
        .collection(collectionPath)
        .doc(senderId)
        .collection(receiverId)
        .snapshots();
  }

  deleteChat(
      {required String senderId,
      required String receiverId,
      required ChatModal chatModal}) async {
    Map<String, dynamic> data = chatModal.toMap;

    data.update('msg', (value) => 'This Message was deleted');
    data.update('type', (value) => 'sent');

    await fireStore
        .collection(collectionPath)
        .doc(senderId)
        .collection(receiverId)
        .doc(chatModal.dateTime.millisecondsSinceEpoch.toString())
        .update(data);

    data.update('msg', (value) => 'This Message was deleted');
    data.update('type', (value) => 'rec');

    await fireStore
        .collection(collectionPath)
        .doc(receiverId)
        .collection(senderId)
        .doc(chatModal.dateTime.millisecondsSinceEpoch.toString())
        .update(data);
  }
}

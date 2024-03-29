import 'package:cloud_firestore/cloud_firestore.dart';

class OrganizerModel {
  String username;
  String uid;
  String pic;
  String phoneNumber;
  String bio;
  String unit;
  String contact;
  String email;
  int postLength;

  OrganizerModel({
    required this.username,
    required this.uid,
    required this.pic,
    required this.email,
    required this.phoneNumber,
    required this.bio,
    required this.unit,
    required this.contact,
    required this.postLength,
  });

  static Map toMap(OrganizerModel cart) {
    return {
      "username": cart.username,
      "uid": cart.uid,
      "pic": cart.pic,
      "email": cart.email,
      "phoneNumber": cart.phoneNumber,
      "bio": cart.bio,
      "unit": cart.unit,
      "contact": cart.contact,
    };
  }

  static OrganizerModel fromSnap(DocumentSnapshot snap) {
    var snapshot = (snap.data()) as Map<String, dynamic>;
    // print('這是本帳用戶信息在 post.dart in model ${snapshot}');
    return OrganizerModel(
      username: snapshot['username'],
      uid: snapshot['uid'],
      pic: snapshot['pic'],
      email: snapshot['email'],
      phoneNumber: snapshot['phoneNumber'],
      bio: snapshot['bio'],
      unit: snapshot['unit'],
      contact: snapshot['contact'],
      postLength: snapshot['postLength'],
    );
  }

  Map<String, dynamic> toJson() => {
        "username": username,
        "uid": uid,
        "pic": pic,
        "email": email,
        "phoneNumber": phoneNumber,
        "bio": bio,
        "unit": unit,
        "contact": contact,
        "postLength": postLength,
      };

  static OrganizerModel? fromMap(Map? map) {
    if (map == null) {
      return null;
    } else {
      return OrganizerModel(
        username: map['username'],
        uid: map['uid'],
        pic: map['pic'],
        email: map['email'],
        phoneNumber: map['phoneNumber'],
        bio: map['bio'],
        unit: map['unit'],
        contact: map['contact'],
        postLength: map['postLength'],
      );
    }
  }
}

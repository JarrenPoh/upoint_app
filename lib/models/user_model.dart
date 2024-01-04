import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String email;
  final String uuid;
  String? username;
  String? studentID;
  String? className;
  String? phoneNumber;
  String? fcmToken;
  List? signList;
  String? pic;

  User({
    required this.email,
    required this.uuid,
    this.phoneNumber,
    this.studentID,
    this.className,
    this.username,
    this.fcmToken,
    this.signList,
    this.pic,
  });

  Map<String, dynamic> toJson() => {
        "email": email,
        "uuid": uuid,
        "username": username,
        "studentID": studentID,
        "className":className,
        "phoneNumber": phoneNumber,
        "fcmToken": fcmToken,
        "signList":signList,
        "pic":pic,
      };

  static User fromSnap(DocumentSnapshot snap) {
    var snapshot = (snap.data()) as Map<String, dynamic>;

    return User(
      email: snapshot['email'],
      uuid: snapshot['uuid'],
      username: snapshot['username'],
      studentID: snapshot['studentID'],
      className: snapshot['className'],
      phoneNumber: snapshot['phoneNumber'],
      fcmToken: snapshot['fcmToken'],
      signList:snapshot['signList'],
      pic: snapshot['pic'],
    );
  }
}

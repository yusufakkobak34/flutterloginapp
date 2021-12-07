import 'package:firebase_auth/firebase_auth.dart';

class UserModel {
  String? uid;
  String? email;
  String? firstName;
  String? secondName;


  UserModel({this.uid,this.email,this.firstName,this.secondName});

  //Servera data atma işlemi
  factory UserModel.fromMap(map)
  {
    return UserModel(
      uid: map['uid'],
      email: map['email'],
      firstName: map['firstName'],
      secondName: map['secondName'],
    );
  }

  //Serverdan data çekme işlemi
  Map<String,dynamic> toMap() {
    return {
      'uid' : uid,
      'email':email,
      'firstName':firstName,
      'secondName':secondName,
    };
  }


}
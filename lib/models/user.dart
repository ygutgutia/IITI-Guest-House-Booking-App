import 'package:flutter/material.dart';

class Users{

  final String uID;
  final String authToken;
  final String emailID;
  final String name;
  final String DOB;
  final String phNo;
  final String picLink;


  Users({
    @required this.uID,
    @required this.authToken,
    @required this.emailID,
    @required this.name,
    @required this.DOB,
    @required this.phNo,
    @required this.picLink,
  });

}
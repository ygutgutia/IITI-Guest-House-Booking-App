import 'dart:async';

import 'package:scoped_model/scoped_model.dart';
import 'package:soft_proj/models/user.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:rxdart/subjects.dart';

class UserModel extends Model{

  PublishSubject<bool> _userSubject = PublishSubject();

  Users _userCurrent;
  bool _isUserLoading = false;

  PublishSubject<bool> get userSubject{
    return _userSubject;
  }
  

  void updateCurrUser(String email, String uid, String authTok){
    _userCurrent= Users(
      uID: uid,
      authToken: authTok,
      emailID: email,
      name: 'Yash',
      DOB: '2001-05-29',
      phNo: '1234',
      picLink: ''

    );
  }


 Future<Map<String, dynamic>> authenticate(String email, String password, String purpose) async {
    
    _isUserLoading = true;
    notifyListeners();
    bool successBool = false;
    String messageSend = 'Authentication Failed';
    String uID = '';
    String authTok = '';

    final Map<String, dynamic> authData = {
      'email' : email,
      'password' : password,
      'returnSecureToken' : true
    };  

    String postRqst = (purpose == 'signUp') ?
      'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyC4QWG6KtEQwivryxjX4Ie0Zi2kBGSQwII' :
      'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyC4QWG6KtEQwivryxjX4Ie0Zi2kBGSQwII';

    final http.Response response = await http.post(
        postRqst,
        body: json.encode(authData),
        headers: {'Content-Type': 'application/json'},
        );
      
      Map<String, dynamic> responseData = json.decode(response.body);

      if(responseData.containsKey('idToken')){
        successBool = true;
        messageSend = 'Authentication Succeeded';
        uID = responseData['localId'];
        authTok = responseData['idToken'];
        //setAuthTimeout(int.parse(responseData['expiresIn']));----------------TIMEOUT CRITERIA

        final SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('token', responseData['idToken']);
        prefs.setString('email', email);
        prefs.setString('uID', responseData['localId']);

      }else if(responseData['error']['message'] == 'EMAIL_EXISTS'){
        messageSend = 'Email Already Exists';
      }else if(responseData['error']['message'] == 'EMAIL_NOT_FOUND'){
        messageSend = 'Email Not Found. Kindly Sign In.';
      }else if(responseData['error']['message'] == 'INVALID_PASSWORD'){
        messageSend = 'The Password Entered is invalid.';
      }else{
        messageSend = 'Something Went Wrong';
      }
      
      _isUserLoading = false;
      notifyListeners();
    return {'success' : successBool, 'message' : messageSend, 'uID' : uID, 'idTok' : authTok};
  }


void autoAuth() async{
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final String token = prefs.getString('token');
  if(token!=null){
    final String email = prefs.getString('email');
    final String uID = prefs.getString('uID');
    updateCurrUser(email, uID, token);
    _userSubject.add(true);
    notifyListeners();
  }

}

 void deleteStoredToken() async{
   _userCurrent = null;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
    _userSubject.add(false);
  }
 


Users get currUserData{
  return _userCurrent;
}
  
}

class UtilityModelUser extends UserModel {
  bool get isUserLoading {
    return _isUserLoading;
  }
}

/*void setAuthTimeout(int time){
  Timer(Duration(seconds: time), deleteStoredToken);
}*/
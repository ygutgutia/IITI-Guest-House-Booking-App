import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:soft_proj/ScopedModels/mainmodel.dart';

enum AuthPage{
  Login,
  Signup
}

class LoginP extends StatefulWidget {

  final MainModel model;
  LoginP(this.model);
  
  @override
  _LoginClass createState() => _LoginClass();
}

class _LoginClass extends State<LoginP> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordCont = TextEditingController();
  AuthPage _currAuth = AuthPage.Login;
  String email;
  String pass;

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Login page'),
      ),

      body: Center(
      child: GestureDetector(

        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },

        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.fromLTRB(40, 0, 40, 0),
            child: Form(
              key: _formKey,
              child: Container(
                child: Column(
                  children: <Widget>[


                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 13.0),
                      child: TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        onSaved: (String value) {
                          email = value;
                        },
                        decoration: const InputDecoration(
                          hintText: 'Enter your institute email ID',
                        ),
                        validator: (String value) {
                          if (value.trim().isEmpty) {
                            return 'Please enter your Email';
                          }
//if (!value.trim().endsWith('@iiti.ac.in')) { return 'Please enter a valid Institute Email ID';}------------------UNCOMMENT-------------
                          return null;
                        },
                      ),
                    ),


                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 13.0),
                      child: TextFormField(
                        controller: _passwordCont,
                        obscureText: true,
                        onSaved: (String value) {
                            pass = value;
                        },
                        decoration: const InputDecoration(
                          hintText: 'Enter your Password',
                        ),
                        validator: (String value) {
                          if (value.isEmpty || value.length < 6) { //Password Criterias regex--------------------------------
                            return 'Password must be atleast 6 digits in length';
                          }
                          return null;
                        },
                      ),
                    ),


                     _currAuth == AuthPage.Signup ? Padding(
                      padding: const EdgeInsets.symmetric(vertical: 13.0),
                      child: TextFormField(
                        obscureText: true,
                        decoration: const InputDecoration(
                          hintText: 'Enter your Password again',
                        ),
                        validator: (String value) {
                          if (_passwordCont.text != value) {
                            return 'Password Doesnt Match';
                          }
                          return null;
                        },
                      ),
                    ) : Container(),

                    SizedBox(height: 13.0,),

/////////////////ACCEPT TERMS BUTTON//////////////////

                  ScopedModelDescendant<MainModel>(
                    builder: (BuildContext context, Widget child, MainModel model) {
                      return model.isUserLoading ? CircularProgressIndicator() : RaisedButton(
          
                        child: Text(_currAuth == AuthPage.Signup ? 'Sign In' : 'Login'),

                        onPressed: () {
                          _formKey.currentState.save();
                          if (_formKey.currentState.validate()) {
                              _submitForm(model.authenticate, model.updateCurrUser);
                          }
                        },
                      );
                    },
                  ),
                    
                  
                  
                    FlatButton(
                      onPressed: () {//Left---------------------------------------------------
                      },
                      child: Text('Forgot Password?'),
                    ),


                    FlatButton( //Implement Navigation SWITCH--------------------------------------------------
                      onPressed: () {
                        _formKey.currentState.reset();
                        setState(() {
                          _currAuth = _currAuth == AuthPage.Login ? AuthPage.Signup : AuthPage.Login;
                        });
                        
                      },
                      child: Text('Switch to ${_currAuth == AuthPage.Login ? 'Signup' : 'Login'}'),
                    ),


                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    ),);
  }
//------------------------------------------SEND CONFIRM MAIL--------------------------------------
  void _submitForm(Function authenticate, Function updateCurrUser) async{

    Map<String, dynamic> succInfo;
    String currPurpose = (_currAuth == AuthPage.Signup) ? 'signUp' : 'signIn';
        
      succInfo = await authenticate(email, pass, currPurpose);
    

                            if (succInfo['success']) {
                              updateCurrUser(email, succInfo['uID'], succInfo['idTok']);
                              _formKey.currentState.reset();
                              Navigator.pushReplacementNamed(context, '/ghpage');
                            }
                            else {
                              
                             _formKey.currentState.reset();
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text("Wrong Details"),
                                    content: Text(succInfo['message']),
                                    actions: <Widget>[
                                      FlatButton(
                                          child: Text("OK"),
                                          onPressed: () {
                                            Navigator.pop(context);
                                          }),
                                    ],
                                  );
                                },
                              );
                            }

  }
}


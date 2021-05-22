import 'package:flutter/material.dart';
import 'package:soft_proj/Payement/payment.dart';
import 'package:soft_proj/Payement/postPayement.dart';
import 'package:soft_proj/SignUpPages/login.dart';
import './ScopedModels/mainmodel.dart';
import './OpeningPages/HousePages/view_ghouses.dart';
import './SideDrawerPages/profile.dart';

import 'package:scoped_model/scoped_model.dart';

import './SignUpPages/login.dart';
import './OpeningPages/RoomPages/roomdata_page.dart';
import 'BookingPages/bookRooms.dart';
import 'BookingPages/dateSelect.dart';
import 'SideDrawerPages/hospitality.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  bool _isAuthenticated = false;

  final MainModel _model = MainModel();

  @override
  void initState() {
    _model.autoAuth();
    _model.userSubject.listen((bool isAuthenticated){
      setState(() {
       _isAuthenticated = isAuthenticated;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel<MainModel>(
      model: _model,
      child: MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            fontFamily: 'Oswald',
          ),
          
          
          routes: {
            '/': (BuildContext context) =>  ScopedModelDescendant<MainModel>(
                                             builder: (BuildContext context, Widget child, MainModel model) { 
                                               return (_isAuthenticated == false) ? LoginP(_model) : GHPage(_model);
                                               }),

            '/ghpage': (BuildContext context) => GHPage(_model),
            '/profile': (BuildContext context) => UserProfilePage(),
            '/hosp': (BuildContext context) => Hospitality(),
            '/prof': (BuildContext context) => UserProfilePage(),
            '/dateSelect': (BuildContext context) => DateSelector(_model),
            '/postPay': (BuildContext context) => postPay(_model),
          },
 
          onGenerateRoute: (RouteSettings settings){
            final List<String> inp = settings.name.split('/');
                      
            if(inp[1]=='0'){
              return MaterialPageRoute(builder: (BuildContext context) => RoomDisp(_model, inp[2]),);
            }
            else if(inp[1]=='1'){
              return MaterialPageRoute(builder: (BuildContext context) => RoomBookPage(_model, inp[2]),);
            }else{
              return MaterialPageRoute(builder: (BuildContext context) => PayPage(_model, inp[2]),);
            }
          },
    ));
  }
}
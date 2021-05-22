import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:soft_proj/ScopedModels/mainmodel.dart';
import 'package:soft_proj/models/user.dart';
import './gh_disp_cards.dart';

class GHPage extends StatefulWidget {
  final MainModel model;
  GHPage(this.model);

  @override
  _GHPageState createState() => _GHPageState();
}

class _GHPageState extends State<GHPage> {

  Users curruser;

  @override
  void initState() {
    
    curruser = widget.model.currUserData;
    widget.model.fetchHouse();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: _drawerFunc(),
      appBar: AppBar(
        centerTitle: true,
        title: Text('Guest Houses'),
      ),
      floatingActionButton: Container(
        height: 130.0,
        width: 130.0,
        child: FittedBox(
          child: FloatingActionButton.extended(
              icon: Icon(Icons.add),
              backgroundColor: Colors.green,
              label: Text('Book Rooms'),
              onPressed: () {
                Navigator.pushNamed(context, '/dateSelect');
              }),
        ),
      ),
      body: _buildHouseList(),
    );
  }

  Widget _buildHouseList() {
    return ScopedModelDescendant(
        builder: (BuildContext context, Widget child, MainModel model) {
      Widget content = Center(child: Text("No Guest Houses Found"));

      if (!model.isHouseLoading) {
        content = Column(
          children: <Widget>[
            Expanded(
              child: GHDispCards(),
            ),
          ],
        );
      } else {
        content = Center(child: CircularProgressIndicator());
      }

      return content;
    });
  }

  Widget _drawerFunc(){
    return Drawer(
        child: new ListView(
          children: <Widget>[
            new UserAccountsDrawerHeader(
              accountName: new Text(curruser.name),
              accountEmail: new Text(curruser.emailID),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.grey,
                child: Text('U', style: TextStyle(color: Colors.black87))
              ),
              decoration: new BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      Color.fromRGBO(91, 100, 110, 1),
                      Color.fromRGBO(68, 131, 203, 1)
                    ]),
              ),
            ),
            ListTile(
                leading: Icon(Icons.home),
                title: new Text("Hospitality"),
                onTap: () {
                  Navigator.pushNamed(context, '/hosp');
                }),
                ListTile(
                leading: Icon(Icons.shop),
                title: new Text("Bookings"),
                onTap: () {
                  Navigator.pop(context);
                  //LEFT
                }),
            ListTile(
                leading: Icon(Icons.person),
                title: Text('Profile'),
                onTap: () {
                  Navigator.pushNamed(context, '/prof');
                }),
            ListTile(
                leading: Icon(Icons.toc),
                title: new Text("About"),
                onTap: () {
                  Navigator.pop(context);
                  //LEFT
                }),
                ListTile(
                leading: Icon(Icons.help),
                title: new Text("Help"),
                onTap: () {
                  Navigator.pop(context);
                  //LEFT
                }),
            new Divider(),
            ListTile(
                leading: Icon(Icons.settings),
                title: new Text("Settings"),
                onTap: () {
                  Navigator.pop(context);
                }),
              ListTile(
                leading: Icon(Icons.exit_to_app),//power_settings_new
                title: new Text("Logout"),
                onTap: () {
                  Navigator.pop(context);
                  widget.model.deleteStoredToken();
                  Navigator.pushReplacementNamed(context, '/');
                }),
          ],
        ),);

  }

  
}

/*


                  


            ListTile(
                title: Text('Bookings'),
                onTap: () {
                  // Update the state of the app.
                }),
            ListTile(
                title: Text('About'),
                onTap: () {
                  // Update the state of the app.
                }),
            ListTile(
                title: Text('Help'),
                onTap: () {
                  // Update the state of the app.
                }),
          ],
        ),
      );*/
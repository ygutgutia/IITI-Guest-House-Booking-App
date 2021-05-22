import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:soft_proj/ScopedModels/mainmodel.dart';
import 'package:soft_proj/models/bookings.dart';

class postPay extends StatefulWidget {
  final MainModel model;
  postPay(this.model);

  @override
  _postPayState createState() => _postPayState();
}

class _postPayState extends State<postPay> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true,
        title: Text('Payement Confirmation'),
      ),
      body: _updateRoomStatus(),
    );
  }

  Widget _updateRoomStatus() {
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
      Widget content = Center(child: Text("Processing"));

      List<int> roomIndex = widget.model.productsRoomIds;
      Bookings _dataCurrent = widget.model.productUserData;
      roomIndex.forEach((element) => () {
            print("Update");
            widget.model.updateRoom(
                element,
                false,
                _dataCurrent.emailID,
                _dataCurrent.dateOfBooking.toIso8601String(),
                _dataCurrent.bookedFrom.toIso8601String(),
                _dataCurrent.bookedUpto.toIso8601String());
          });

      if (!model.isHouseLoading) {
        content = Center(child: Text('Payement Done'));
      } else {
        content = Center(child: CircularProgressIndicator());
      }

      return content;
    });
  }
}

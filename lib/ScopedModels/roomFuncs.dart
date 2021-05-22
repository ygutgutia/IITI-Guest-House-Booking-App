import './userModel.dart';
import '../models/rooms.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RoomModel extends UserModel {
  List<RoomData> _roomDet = [];
  bool _isRoomLoading = false;

  void fetchRoom() {
    _isRoomLoading = true;
    notifyListeners();
    http
        .get('https://jazzgh-254d4.firebaseio.com/AllFolders/Rooms.json?auth=${currUserData.authToken}')
        .then((http.Response response) {
      final Map<String, dynamic> roomListData = json.decode(response.body);
      final List<RoomData> fetchedRoomList = [];

      roomListData.forEach(
        (String roomIDobt, dynamic roomData) {
          final RoomData roomInit = RoomData(
              roomID: roomIDobt,
              bookedBy: roomData['bookedBy'],
              bookedOn: roomData['bookedOn'],
              gHouseName: roomData['gHouseName'],
              roomNo: roomData['roomNo'],
              floorNo: roomData['floorNo'],
              availability: roomData['availability'],
              bookedFrom: roomData['bookedFrom'],
              bookedUpto: roomData['bookedUpto'],
              picLink: roomData['picLink'],
              price: roomData['price']);
          fetchedRoomList.add(roomInit);
        },
      );

      _roomDet = fetchedRoomList;
      _isRoomLoading = false;
      notifyListeners();
    });
  }

  void updateRoom(int index, bool avail, String email, String bookOn,
      String bookedFro, String bookedTo) async {
    _isRoomLoading = true;
    notifyListeners();
    String storeId = _roomDet[index].roomID;

    Map<String, dynamic> roomUpdateData = {
      'availability': avail,
      'bookedBy': email,
      'bookedFrom': bookedFro,
      'bookedOn': bookOn,
      'bookedUpto': bookedTo,
      'floorNo': _roomDet[index].floorNo,
      'gHouseName': _roomDet[index].gHouseName,
      'picLink': _roomDet[index].picLink,
      'price': _roomDet[index].price,
      'roomNo': _roomDet[index].roomNo,
    };

    //final http.Response response = 
    await http.put(
        'https://jazzgh-254d4.firebaseio.com/AllFolders/Rooms/${storeId}.json?auth=${currUserData.authToken}',
        body: json.encode(roomUpdateData));

    RoomData temp = RoomData(
      availability: avail,
      bookedBy: email,
      bookedFrom: bookedFro,
      bookedOn: bookOn,
      bookedUpto: bookedTo,
      floorNo: _roomDet[index].floorNo,
      gHouseName: _roomDet[index].gHouseName,
      picLink: _roomDet[index].picLink,
      price: _roomDet[index].price,
      roomID: _roomDet[index].roomID,
      roomNo: _roomDet[index].roomNo,
    );

    _roomDet[index] = temp;
    _isRoomLoading = false;
    notifyListeners();
  }

  List<RoomData> get productsRoom {
    return List.from(_roomDet);
  }
}

class UtilityModelRoom extends RoomModel {
  bool get isRoomLoading {
    return _isRoomLoading;
  }
}

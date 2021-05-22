import '../models/houses.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import './userModel.dart';

class GuestHouseModel extends UserModel {
  List<GuestHouses> _guesthouses;
  bool _isHouseLoading = false;

  void fetchHouse() {
    _isHouseLoading = true;
    notifyListeners();


    http
        .get('https://jazzgh-254d4.firebaseio.com/AllFolders/GuestHouses.json?auth=${currUserData.authToken}')
        .then((http.Response response) {
      final Map<String, dynamic> gbhListData = json.decode(response.body);
      final List<GuestHouses> fetchedGBList = [];

      gbhListData.forEach(
        (String houseIDobt, dynamic ghData) {
          final GuestHouses ghInit = GuestHouses(
            houseID: houseIDobt,
            guestHouseName: ghData['guestHouseName'],
            noOfRoom: ghData['noOfRoom'],
            bookedRoom: ghData['bookedRoom'],
            picLink: ghData['picLink'],
          );

          fetchedGBList.add(ghInit);
        },
      );

      _guesthouses = fetchedGBList;

      _isHouseLoading = false;
      notifyListeners();
    });
  }

  List<GuestHouses> get products {
    return List.from(_guesthouses);
  }

  void updateHouse(int index, GuestHouses houseDetails) {
    _guesthouses[index] = houseDetails;
  }
}

class UtilityModelHouse extends GuestHouseModel {
  bool get isHouseLoading {
    return _isHouseLoading;
  }
}





/*final GuestHouses gb = GuestHouses(houseID: "ID1", guestHouseName: "CVR", noOfRoom: 5, bookedRoom: 0, picLink: "https://www.google.com/url?sa=i&url=https%3A%2F%2Fflutter.dev%2Fdocs%2Fdevelopment%2Fui%2Fwidgets%2Ftext&psig=AOvVaw2icFbpDV37dIPX5QiHGHIg&ust=1590571192455000&source=images&cd=vfe&ved=0CAIQjRxqFwoTCODpr7mZ0ekCFQAAAAAdAAAAABAJ");

  void inithouse(){

    
    final List<GuestHouses> fetchedGBList = [];

    final GuestHouses ghInit = GuestHouses(
            houseID : "ID4",
            guestHouseName : "CVR",
            noOfRoom : 6,
            bookedRoom : 3,
            picLink : "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAGQAAAB8CAMAAACoueWQAAAAclBMVEX///9F0f1g1/0CU5o6ve5k1v2u6P5Y1v0AUZlCbKc6z/37/v/c9f/y+/8AQpMATJbn+P9Py/ac4/4ed7R5jrlKwvAARZST4f6F3v5z2v2gsc2arMpvhbMezP3V8/+NudphyPIAbK6RpcaInsIAPZEsW54b4rwlAAABmklEQVRoge3Yi27CMAwF0LS0dKOU8Rh7sA22wf7/F1cqVPXhxCm2u9L5/sCRdZ0oijGUTGOPhCnJWM8CNLNADTXUGL+RyRuJGmqoccvGs48Rj8QIRzLHWIw++tDOezNe1FDjrwziOR+MMZY+bsB4VUMNNYgG7S9jMAbx77UPI77WyKYeWafeBtRHFiZ4gjnVCNH0Z1y9ux0Ms/yQNzwUeK86GajCMAeqMBlOhc3IFduKMRrWWVgNyyzMBqiwG4ByvZHYjJYCG9sVyWgoFiOKUMVp1BSrgSqIUVEcBqKgRqk4DaeS7FHjoiCGQ/EyCgU1rIqncVZww6J4G7kCvHebBqh0MKC0DUARMFqKiNFQhIyaImZUFEGjVESNiyJsFIq4cVZoRrrCjSg6kAxj9h7G5rQTVzYPk4W0khsTaaUwGJQ5bkgq29KQU6pGrrwRlSV0JuuGjNI0RJSWIaAABoNSvytBg1mxGJxKu3N+xWVwKW4jV76pyidqsChfmMGgpO9PKEJXjCpd87j4Z8pRFVWGr9yhOZGV4z2en90vni5OMJWkcncAAAAASUVORK5CYII=",
          );

          fetchedGBList.add(ghInit);
          _guesthouses = fetchedGBList;

          print("INITIALIZED LOCAL");
          print(_guesthouses);

  }

   */

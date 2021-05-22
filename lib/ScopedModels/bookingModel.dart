import 'package:scoped_model/scoped_model.dart';
import 'package:soft_proj/models/bookings.dart';

class BookingModel extends Model{

  Bookings _dataCurrent;
  List<int> _roomIndex = [];

  

  void updateUserData(DateTime ini, DateTime finale){
    _dataCurrent= Bookings(
                          emailID: 'yash.v.gutgutia@gmail.com', 
                          dateOfBooking: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day),
                          bookedFrom: ini,
                          bookedUpto: finale);
  }

  void updateRoomBooked(int roomInds, bool val){
    if(val){
      _roomIndex.add(roomInds);
    }else{
      _roomIndex.remove(roomInds);
    }
  }

  List<int> get productsRoomIds{
  return List.from(_roomIndex);
}

void clearRoomIds(){
  _roomIndex.clear();
}

Bookings get productUserData{
  return _dataCurrent;
}
  
}


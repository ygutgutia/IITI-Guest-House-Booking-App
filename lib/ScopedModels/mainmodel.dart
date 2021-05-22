import 'package:scoped_model/scoped_model.dart';
import './guestHousesFuncs.dart';
import './roomFuncs.dart';
import 'bookingModel.dart';
import './userModel.dart';

class MainModel extends Model with UserModel, GuestHouseModel, BookingModel, RoomModel, UtilityModelHouse, UtilityModelRoom, UtilityModelUser{}
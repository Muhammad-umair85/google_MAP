import 'package:flutter/cupertino.dart';
import 'package:rider_app/Models/riderAddress.dart';

class AppData extends ChangeNotifier{
RiderAddress rAddress,dAddress;
void updateRiderPickUpLocation(RiderAddress riderAddress){
      rAddress=riderAddress;
      notifyListeners();
}
void updateRiderDropOffLocation(RiderAddress dropLocation){
      dAddress=dropLocation;
      notifyListeners();
}
}
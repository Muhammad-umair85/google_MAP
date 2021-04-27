
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:rider_app/Handler/appData.dart';
import 'package:rider_app/Models/direction_place.dart';
import 'package:rider_app/Models/riderAddress.dart';

import 'package:rider_app/locationScreens/request_location.dart';

class MethodRequest {
  static Future<String> methodRequestCoordinated(Position position,context) async {
    String desiredAddress = "";
    String s1,s2,s3;
    String url =
        "https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=AIzaSyA48eQTV0t7MYh9p0Wb_ZBxZ5TZV-cXcvg";
    var response = await RequestAddress.getRequest(url);
    if (response != "failed") {

        s1= response["results"][0]["address_components"][0]["long_name"];
        s2= response["results"][0]["address_components"][1]["long_name"];
        s3= response["results"][0]["address_components"][4]["long_name"];


        desiredAddress =s1+ " , "+s2+ " , "+s3;
      RiderAddress riderAddress=new RiderAddress();
      riderAddress.longitude=position.longitude;
      riderAddress.latitude=position.latitude;
      riderAddress.pName=desiredAddress;
      Provider.of<AppData>(context,listen:false).updateRiderPickUpLocation(riderAddress);


    }
    return desiredAddress;
  }


static Future<DirectionPlace> getLocationDirections(LatLng initialPosition,LatLng finalPosition)async{

    String directionUrl="https://maps.googleapis.com/maps/api/directions/json?origin=${initialPosition.latitude},${initialPosition.longitude}&destination=${finalPosition.latitude},${finalPosition.longitude}&key=AIzaSyA48eQTV0t7MYh9p0Wb_ZBxZ5TZV-cXcvg";

    var res=await RequestAddress.getRequest(directionUrl);
    if(res=="failed"){
      return null;
    }
    DirectionPlace directionDetails=DirectionPlace();
    directionDetails.encodedPoints=res["routes"][0]["overview_polyline"]["points"];

    directionDetails.durationValue=res["routes"][0]["legs"][0]["duration"]["value"];

    directionDetails.distanceValue=res["routes"][0]["legs"][0]["distance"]["value"];
    directionDetails.distanceText=res["routes"][0]["legs"][0]["distance"]["text"];
    directionDetails.durationText=res["routes"][0]["legs"][0]["duration"]["text"];
    return directionDetails;
}
















}

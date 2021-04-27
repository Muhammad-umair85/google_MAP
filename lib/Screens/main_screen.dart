import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:rider_app/Handler/appData.dart';
import 'package:rider_app/Screens/search_screen.dart';
import 'package:rider_app/Widgets/navigation_drawer.dart';
import 'package:rider_app/locationScreens/method_request.dart';
import 'package:rider_app/locationScreens/method_request.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  String _resultAddress;
  var bPadding=0.0;
  Completer<GoogleMapController> _newGooglecontroller = Completer();
  GoogleMapController userMap;
  Position currentPosition;
  var geoLocator=Geolocator();
  List<LatLng> pLineCoordinates=[];
  Set<Polyline> polyLineSet={};


  void getCurrentLocation() async{

    Position position=await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high,);
    currentPosition=position;
    LatLng lang=LatLng(position.latitude, position.longitude);
    CameraPosition cameraPosition=CameraPosition(target: lang,zoom: 14.0);
    userMap.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
     String address= await MethodRequest.methodRequestCoordinated(position,context);
     print(address);


  }
  getSetAddress(Coordinates coordinates) async {
    final addresses =
    await Geocoder.local.findAddressesFromCoordinates(coordinates);
    setState(() {
      _resultAddress = addresses.first.addressLine;
    });

  }


  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavigationDrawer(),
      appBar: AppBar(
        title: Text("Welcome"),
      ),
      body: Stack(
        children: [
          GoogleMap(
            padding: EdgeInsets.only(bottom: bPadding),
            initialCameraPosition: _kGooglePlex,
            mapType: MapType.normal,
            zoomGesturesEnabled: true,
            zoomControlsEnabled: true,
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            polylines: polyLineSet,
            onMapCreated: (GoogleMapController controller) {
              _newGooglecontroller.complete(controller);
              userMap = controller;
              setState(() {
                bPadding=300.0;
              });
             getCurrentLocation();

            },
          ),
          Positioned(
            left: 0.0,
            right: 0.0,
            bottom: 0.0,
            child: GestureDetector(
              onTap: () async{

                var res=await Navigator.push(context, MaterialPageRoute(builder: (context) => SearchScreen()));

                if(res=="successFull"){
                 await  getPlaceDirection();
                }

              },
              child: Container(
                height: 320.0,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(18.0),
                      topRight: Radius.circular(18.0)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black54,
                      blurRadius: 16.0,
                      spreadRadius: 0.5,
                      offset: Offset(0.7,0.7),
                    ),

                  ]
                ),

                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal:24.0,vertical: 18.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 10.0,),
                      Text("Welcome...",style: TextStyle(fontSize: 15.0),),
                      Text("Where You want to go?",style: TextStyle(fontSize: 20.0,fontWeight: FontWeight.bold),),
                      SizedBox(height: 20.0,),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                            borderRadius: BorderRadius.circular(
                                5.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black54,
                                blurRadius: 6.0,
                                spreadRadius: 0.5,
                                offset: Offset(0.7,0.7),
                              ),

                            ]
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            children: [
                              Icon(Icons.search,color: Colors.blue,),
                              SizedBox(width: 16.0,),
                              Text("Search Drop Off",style: TextStyle(fontSize: 15.0,color: Colors.black),),
                            ],
                          ),
                        ),

                      ),
                      SizedBox(height: 20.0,),

                      Row(
                        children: [
                    Icon(Icons.home,color: Colors.grey,),
                          SizedBox(width: 12.0,),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(Provider.of<AppData>(context).rAddress != null
                                    ?Provider.of<AppData>(context).rAddress.pName
                                    : "Add Home",),
                                SizedBox(height: 4.0,),
                                Text("Add Your Home Location",style: TextStyle(color: Colors.grey,fontSize: 16.0,fontWeight: FontWeight.bold),),



                              ],
                            ),
                          )

                        ],
                      ),
                      SizedBox(height: 10.0,),
                      Divider(color: Colors.blue,),
                      Row(
                        children: [
                          Icon(Icons.work,color: Colors.grey,),
                          SizedBox(width: 12.0,),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Add Office",),
                              SizedBox(height: 4.0,),
                              Text("Add Your Work Location",style: TextStyle(color: Colors.grey,fontSize: 16.0,fontWeight: FontWeight.bold),),



                            ],
                          )

                        ],
                      ),



                    ],
                  ),
                ),

              ),
            ),
          )
        ],
      ),
    );
  }

  Future<void> getPlaceDirection()async {
     var initialPostion=Provider.of<AppData>(context,listen: false).rAddress;
     var finalPostion=Provider.of<AppData>(context,listen: false).dAddress;
     var pickLatLang=LatLng(initialPostion.latitude, initialPostion.longitude);
     var dropLatLang=LatLng(finalPostion.latitude, finalPostion.longitude);
     var details=await MethodRequest.getLocationDirections(pickLatLang, dropLatLang);
     print(details.encodedPoints);

     PolylinePoints polylinePoints=PolylinePoints();
     List<PointLatLng> decodePolyPoints=polylinePoints.decodePolyline(details.encodedPoints);
     if(decodePolyPoints.isNotEmpty){

         decodePolyPoints.forEach((PointLatLng pointLatLng){
           pLineCoordinates.add(LatLng(pointLatLng.latitude, pointLatLng.longitude));
         });
         polyLineSet.clear();

         setState(() {
           Polyline polyline=Polyline(
             color: Colors.blue,
             polylineId: PolylineId("PolylineID"),
             jointType: JointType.round,
             width: 6,
             endCap: Cap.squareCap,
             startCap: Cap.squareCap,
             points: pLineCoordinates,
             geodesic: true
           );
           polyLineSet.add(polyline);
         });








     }








  }



  }

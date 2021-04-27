import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rider_app/Handler/appData.dart';
import 'package:rider_app/Models/places_json.dart';
import 'package:rider_app/Models/riderAddress.dart';
import 'package:rider_app/Widgets/progress_custom.dart';
import 'package:rider_app/locationScreens/method_request.dart';
import 'package:rider_app/locationScreens/request_location.dart';
class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController pickUpController=TextEditingController();
  TextEditingController DropController=TextEditingController();
  List<PlacesJson> placePredictionList=[];



  @override
  Widget build(BuildContext context) {
    String pickUpAddress=Provider.of<AppData>(context).rAddress.pName ??" ";
    pickUpController.text=pickUpAddress;

    return Scaffold(
      body: Column(

        children: [


          SizedBox(height: 8.0,),

          Container(
            height: 240.0,
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
              BoxShadow(
              color: Colors.black54,
              blurRadius: 6.0,
              spreadRadius: 0.5,
              offset: Offset(0.7,0.7),
            )],
            ),
            child: Padding(
              padding: EdgeInsets.all(25.0),
              child: Column(
                children: [

                  Row(
                    children: [
                      Icon(Icons.arrow_back_outlined,size: 29.0,),
                      SizedBox(width: 30.0,),

                      Text("Add Your Designation",style: TextStyle(fontSize: 24.0,fontWeight: FontWeight.bold),),
                    ],
                  ),
                  SizedBox(height: 17.0,),

                  Row(
                    children: [
                      Icon(Icons.location_on_rounded,size: 25.0,),
                      Expanded(
                        
                        child:Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[400],
                            borderRadius: BorderRadius.circular(7.0),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(3.0),
                            child:TextField(
                              controller: pickUpController,
                              decoration: InputDecoration(

                                  hintText: "Add PickUp Location",
                                  fillColor: Colors.grey,
                                  filled: true,
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.all(8.0)


                              ),
                            ),
                          ),
                        ) 
                        

                      )
                    ],
                  ),
                  SizedBox(height: 10.0,),
                  Row(
                    children: [
                      Icon(Icons.location_on_rounded,size: 25.0,),
                      Expanded(

                          child:Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[400],
                              borderRadius: BorderRadius.circular(7.0),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(3.0),
                              child:TextField(
                                onChanged: (val){
                                  autoComplete(val);
                                },
                                decoration: InputDecoration(
                                    hintText: "Add Drop Location",
                                    fillColor: Colors.grey,
                                    filled: true,
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.all(8.0)


                                ),
                              ),
                            ),
                          )


                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
          (placePredictionList.length>0)
          ?Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0,horizontal: 8.0),
            child: ListView.separated(
              scrollDirection: Axis.vertical,

              shrinkWrap: true,
              padding: EdgeInsets.all(0.0),
              itemBuilder: (context,index){
                return PlaceTile(placePrediction: placePredictionList[index],);
              },
              separatorBuilder:(BuildContext context, int index)=>Divider() ,
              itemCount: placePredictionList.length,
              physics: ClampingScrollPhysics(),

            ),
          )
            :Container()

        ],
      ),
    );
  }

  void autoComplete(String placeAddress) async{
    if(placeAddress.length >1){
      String autoCompleteUrl="https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$placeAddress&key=AIzaSyA48eQTV0t7MYh9p0Wb_ZBxZ5TZV-cXcvg&sessiontoken=1234567890&components=country:us";
        var  result= await RequestAddress.getRequest(autoCompleteUrl);
        if(result == "failed"){
          return;
        }
        //print(result);
        if(result["status"]=="OK"){
          var predictions=result["predictions"];
          var placeList=(predictions as List).map ((e)=>PlacesJson.fromJson(e)).toList();
setState(() {
  placePredictionList=placeList;
});
        }

    }


  }
}


class PlaceTile extends StatelessWidget {
  PlacesJson placePrediction;



  PlaceTile({Key key,this.placePrediction}):super(key: key);
  @override
  Widget build(BuildContext context) {
    return FlatButton(
      padding: EdgeInsets.all(0.0),
      onPressed: (){
        placeDetails(placePrediction.place_id, context);
      },
      child: SingleChildScrollView(
        child: Container(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  children: [
                    Icon(Icons.add_location),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(placePrediction.main_text,overflow:TextOverflow.ellipsis,style: TextStyle(fontSize: 18.0,fontWeight: FontWeight.bold),),
                            SizedBox(height: 8.0,),
                            Text(placePrediction.secondary_text,overflow:TextOverflow.ellipsis,style: TextStyle(fontSize: 15.0,),)

                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }


  void placeDetails(String placeId,context)async{
    showDialog(
        context: context,
        builder: (BuildContext context)=>ProgressBar(message: "Loading...",)
    );
    String detailUrl="https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=AIzaSyA48eQTV0t7MYh9p0Wb_ZBxZ5TZV-cXcvg";
    var  result= await RequestAddress.getRequest(detailUrl);
    if(result == "failed"){
      return;
    }
    Navigator.pop(context);

    if(result["status"] == "OK"){

      RiderAddress riderAddress= RiderAddress();
      riderAddress.pName=result["result"]["name"];
      riderAddress.pId=placeId;
      riderAddress.longitude=result["result"]["geometry"]["location"]["lng"];
      riderAddress.latitude=result["result"]["geometry"]["location"]["lat"];
      Provider.of<AppData>(context,listen: false).updateRiderDropOffLocation(riderAddress);
      print(riderAddress.pName);
      Navigator.pop(context,"successFull");




    }

  }

}
























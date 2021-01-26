import 'dart:async';
import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_map_polyline/google_map_polyline.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:pathTracker/presentations/customs/custom_raised_buttton.dart';
import 'package:pathTracker/presentations/sign_in_page.dart';
import 'package:pathTracker/utils/string_values.dart';
import 'package:pathTracker/utils/styles.dart';
import 'package:permission/permission.dart';
import 'package:location_platform_interface/location_platform_interface.dart';

class HomePage extends StatefulWidget {
  static const String routeName = "HomePage";
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //bool currentLoc=true;
  StreamSubscription _locationSubscription;
  GoogleMapController _controller;
  Location _locationTracker = Location();
  List<Marker> marker = List<Marker>();
  Circle circle;
  final CameraPosition _initialPosition =
      CameraPosition(target: LatLng(28.4549367, 78.7786118));

  final Set<Polyline> polyline = {};
  List<LatLng> routeCoordinates = List<LatLng>();
  GoogleMapPolyline _googleMapPolyline =
      GoogleMapPolyline(apiKey: "AIzaSyBgT1FKl2AtvXo5arKR_iEoux4O_6J661g");
  double destLatitude = 28.5904;
  double destLongitude = 78.5718;

  Future<Uint8List> getMarker() async {
    ByteData byteData =
        await DefaultAssetBundle.of(context).load(Styles.green_dot);
    return byteData.buffer.asUint8List();
  }

  void updateMarkerAndCircle(LocationData newLocalData, Uint8List imageData,
      bool currLoc, bool pause) {
    LatLng latlng = LatLng(newLocalData.latitude, newLocalData.longitude);
    // doubt: this?
    if (pause && marker.isNotEmpty) {
      // this part will run when you press pause
      // preserve the green route and keep updating current location
      print("pause");
      marker.removeLast();
    }
    if (currLoc)
      marker.clear(); // this will run when you press current location and reset
    Marker currMarker = Marker(
        markerId: MarkerId("pos${marker.length}"),
        position: latlng,
        rotation: newLocalData.heading,
        draggable: false,
        zIndex: 2,
        flat: true,
        anchor: Offset(0.5, 0.5),
        icon: BitmapDescriptor.fromBytes(imageData));
    this.setState(() {
      marker.add(currMarker);
      print(marker.length);
      circle = Circle(
          circleId: CircleId("car"),
          radius: newLocalData.accuracy,
          zIndex: 1,
          strokeColor: Colors.blue,
          center: latlng,
          fillColor: Colors.blue.withAlpha(70));
    });
  }

  void play(bool currentLoc, bool pause) async {
    try {
      Uint8List imageData = await getMarker();
      LocationData location = await _locationTracker.getLocation();
      print("location");
      print(location);
      print(location.accuracy);
      print(location.heading);

      updateMarkerAndCircle(location, imageData, currentLoc, pause);

      if (_locationSubscription != null) {
        _locationSubscription.cancel();
      }

      // doubt of setstate
      this.setState(() {
        _controller.animateCamera(
          CameraUpdate.newCameraPosition(
            new CameraPosition(
                bearing: 192.8334901395799,
                target: LatLng(location.latitude, location.longitude),
                tilt: 0,
                zoom: 18.00),
          ),
        );
      });

      // when current location changes

      _locationSubscription =
          _locationTracker.onLocationChanged.listen((newLocalData) {
        if (_controller != null) {
          _controller.animateCamera(CameraUpdate.newCameraPosition(
              new CameraPosition(
                  bearing: 192.8334901395799,
                  target: LatLng(newLocalData.latitude, newLocalData.longitude),
                  tilt: 0,
                  zoom: 18.00)));
          updateMarkerAndCircle(newLocalData, imageData, currentLoc, pause);
        }
      });
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        debugPrint("Permission Denied");
      }
    }
  }

  getRoute() async {
    // var permissions =
    //     await Permission.getPermissionsStatus([PermissionName.Location]);
    // if (permissions[0].permissionStatus == PermissionStatus.notAgain) {
    //   var askpermissions =
    //       await Permission.requestPermissions([PermissionName.Location]);
    // } else {
    print("getting route");
    LocationData currLocation = await _locationTracker.getLocation();
    print(currLocation);
    print("curr location done");
    routeCoordinates = await _googleMapPolyline.getCoordinatesWithLocation(
        origin: LatLng(currLocation.latitude, currLocation.longitude),
        destination: LatLng(destLatitude, destLongitude),
        mode: RouteMode.driving);
    print("routcoordinate below");
    print(routeCoordinates);
    print("routcoordinate above");
    // }
  }

  @override
  void dispose() {
    if (_locationSubscription != null) {
      _locationSubscription.cancel();
    }
    super.dispose();
  }

  // @override
  // void initState() {
  //   super.initState();
  //   marker.add(Marker(
  //     markerId: MarkerId("home"),
  //     position: LatLng(28.4549367, 78.7786118),
  //     draggable: false,
  //     zIndex: 2,
  //     flat: true,
  //     anchor: Offset(0.5, 0.5),
  //     // icon: BitmapDescriptor.fromBytes(imageData)
  //   ));
  //   //getRoute();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(StringValue.appTitle),
        centerTitle: true,
      ),
      drawer: showDrawer(),
      body: showBodyHomePage(),
    );
  }

  showDrawer() {
    return Container(
      child: Drawer(
        child: Column(
          children: [
            SizedBox(height: ScreenUtil().setHeight(60)),
            Icon(
              Icons.location_on_sharp,
              color: Colors.lightBlue[600],
              size: ScreenUtil().setHeight(80),
            ),
            SizedBox(height: ScreenUtil().setHeight(40)),
            Text(
              "Using ${StringValue.playWord} - ",
              // textAlign: TextAlign.start,
              style: TextStyle(
                fontSize: ScreenUtil().setSp(20),
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: ScreenUtil().setHeight(5)),
            Text(
              StringValue.play,
              // textAlign: TextAlign.start,
              style: TextStyle(
                fontSize: ScreenUtil().setSp(18),
                // fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: ScreenUtil().setHeight(30)),
            Text(
              "Using ${StringValue.pauseWord} - ",
              // textAlign: TextAlign.start,
              style: TextStyle(
                fontSize: ScreenUtil().setSp(20),
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: ScreenUtil().setHeight(5)),
            Text(
              StringValue.pause,
              // textAlign: TextAlign.start,
              style: TextStyle(
                fontSize: ScreenUtil().setSp(18),
                // fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: ScreenUtil().setHeight(30)),
            Text(
              "Using ${StringValue.resetWord} - ",
              // textAlign: TextAlign.start,
              style: TextStyle(
                fontSize: ScreenUtil().setSp(20),
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: ScreenUtil().setHeight(5)),
            Text(
              StringValue.reset,
              // textAlign: TextAlign.start,
              style: TextStyle(
                fontSize: ScreenUtil().setSp(18),
                // fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: ScreenUtil().setHeight(25)),
            FlatButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.of(context).pushNamedAndRemoveUntil(
                    SignIn.routeName, (Route<dynamic> route) => false);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    StringValue.signOutWord,
                    // textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize: ScreenUtil().setSp(18),
                      // fontWeight: FontWeight.bold,
                    ),
                  ),
                  Icon(Icons.chevron_right),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  showBodyHomePage() {
    return SingleChildScrollView(
      child: Column(
        children: [
          // google map and icon button for current location
          Container(
            height: ScreenUtil().setHeight(600),
            child: Stack(
              fit: StackFit.loose,
              children: [
                GoogleMap(
                  zoomControlsEnabled: false,
                  //polylines: Set.of((polyline != null) ? polyline : []),
                  markers: Set.of((marker != null) ? marker : []),
                  circles: Set.of((circle != null) ? [circle] : []),
                  onMapCreated: (controller) {
                    setState(() {
                      _controller = controller;
                    });
                  },
                  onTap: (cordinates) {
                    _controller
                        .animateCamera(CameraUpdate.newLatLng(cordinates));
                  },
                  initialCameraPosition: _initialPosition,
                  mapType: MapType.normal,
                ),
                Container(
                  padding: EdgeInsets.only(
                      left: ScreenUtil().setWidth(320),
                      top: ScreenUtil().setHeight(550)),
                  child: IconButton(
                    icon: Icon(
                      Icons.location_on_sharp,
                      color: Colors.black,
                      size: ScreenUtil().setHeight(35),
                    ),
                    onPressed: () {
                      marker.clear();
                      play(true, false);
                    },
                  ),
                ),
              ],
            ),
          ),
          // Play - Pause
          Container(
            margin: EdgeInsets.only(top: ScreenUtil().setHeight(10)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomRaisedButton(
                  buttonColor: Colors.lightBlue[300],
                  paddingHorizontal: 25,
                  paddingVertical: 10,
                  childText: StringValue.playWord,
                  onPressed: () {
                    play(false, false);
                  },
                ),
                // Rais
                SizedBox(width: ScreenUtil().setWidth(20)),
                CustomRaisedButton(
                  buttonColor: Colors.lightBlue[300],
                  paddingHorizontal: 20,
                  paddingVertical: 10,
                  childText: StringValue.pauseWord,
                  onPressed: () {
                    play(false, true);
                  },
                ),
              ],
            ),
          ),
          SizedBox(height: ScreenUtil().setHeight(10)),
          // Reset
          CustomRaisedButton(
            buttonColor: Colors.lightBlue[300],
            paddingHorizontal: 20,
            paddingVertical: 10,
            childText: StringValue.resetWord,
            onPressed: () {
              marker.clear();
              play(true, false);
            },
          )
        ],
      ),
    );
  }
}

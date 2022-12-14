import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:plant_app/constants.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:plant_app/global.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:plant_app/screens/signin/sign_in_screen.dart';

class Body extends StatefulWidget {
  const Body({Key key}) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  File _image;
  String img64;
  final picker = ImagePicker();
  Future getInfo() async {
    final picked_image = await picker.pickImage(source: ImageSource.camera);
      setState(() {
        print("***********************");
        // print(picked_image);
      if (picked_image != null) {
        _image = File(picked_image.path);
        final bytes = File(picked_image.path).readAsBytesSync();
        img64 = base64Encode(bytes);
        GetRecycleInformation(context, img64);
        // print(img64);
        // we make a get request to backend
        // we get some info from backend, and then load a popup.
        //  set if- else tree for recycle vs non-recycle.
        // for now assuming we get recyclable as result of get request.
        // RecycleDialogFuntion(context);
        // NonRecycleDialogFuntion(context);
      } else {
        print('No image selected');
      }
     });
  }







  Future<void> GetRecycleInformation(context, img64) async {
  print("function started");
  // print(img64);
  String accessToken = "";
  if (Access_token == "") {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    accessToken = prefs.getString('access') ?? "";
  } else {
    accessToken = Access_token;
  }

  if (accessToken == "") {
    Navigator.pushNamed(context, SignInScreen.routeName);
  } else {
    final response = await http.post(
      Uri.parse(  
          'http://172.28.187.91:8000/classify'), 
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $accessToken'
      },
      body: jsonEncode(<String, String>{
        'image': img64,
      }),
    );
    
    if (response.statusCode == 200) {
      print(response.body);
      if ((response.body) == 'Recyclable') {
        setState(() {
          RecycleDialogFuntion(context);
        });
      }
      else if ((response.body) == 'Organic') {
        setState(() {
          OrganicDialogFuntion(context);
        });
      }
      else{
        setState(() {
          NonRecycleDialogFuntion(context);
        });
      }
      
    }
    else {
      InvalidPicDialogFuntion(context);
      // SharedPreferences prefs = await SharedPreferences.getInstance();
      // prefs.remove('access');
      // Navigator.pushNamed(context, SignInScreen.routeName);
    }
  }
}


void InvalidPicDialogFuntion(context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      Size size = MediaQuery.of(context).size;

      return AlertDialog(
        elevation: 24.0,
        backgroundColor: kPrimaryColor,
        title: Text(
          "Could Not Tell ! Retry",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
        content: Image.asset(
          "assets/images/recycleGif.gif",
          height: size.height * 0.15,
          width: size.height * 0.15,
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'OK'),
            child: const Text(
              "Okay",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w300,
              ),
            ),
          ),
        ],
      );
    },
  );
}











  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            "Not Sure whether your waste is Recyclable or Not? \n  Let's find out. ",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: kTextColor,
              fontSize: 30,
              fontWeight: FontWeight.w500,
            ),
          ),
          Container(
            alignment: Alignment.center,
            margin: EdgeInsets.symmetric(
                horizontal: kDefaultPadding, vertical: kDefaultPadding),
            padding: EdgeInsets.symmetric(horizontal: kDefaultPadding),
            height: 54,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  offset: Offset(0, 10),
                  blurRadius: 50,
                  color: kPrimaryColor.withOpacity(0.23),
                ),
              ],
            ),
            child: GestureDetector(
              onTap: () {
                print("Open Camera");
                getInfo();
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                // crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SvgPicture.asset("assets/icons/cameraIcon.svg"),
                  SizedBox(
                    width: size.width * 0.05,
                  ),
                  Text(
                    "Upload Photo",
                    style: TextStyle(
                      color: kTextColor,
                      fontSize: 18.0,
                    ),
                  ),
                ],
              ),
              // margin: EdgeInsets.all(15.0),
              // decoration: BoxDecoration(
              //   borderRadius: BorderRadius.circular(10.0),
              //   color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

void RecycleDialogFuntion(context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      Size size = MediaQuery.of(context).size;

      return AlertDialog(
        elevation: 24.0,
        backgroundColor: kPrimaryColor,
        title: Text(
          "Recyclable !",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
        content: Image.asset(
          "assets/images/recycleGif.gif",
          height: size.height * 0.15,
          width: size.height * 0.15,
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'OK'),
            child: const Text(
              "Okay",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w300,
              ),
            ),
          ),
        ],
      );
    },
  );
}


void OrganicDialogFuntion(context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      Size size = MediaQuery.of(context).size;

      return AlertDialog(
        elevation: 24.0,
        backgroundColor: kPrimaryColor,
        title: Text(
          "Organic !",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: Colors.blue[900],
          ),
        ),
        content: Image.asset(
          "assets/images/recycleGif.gif",
          height: size.height * 0.15,
          width: size.height * 0.15,
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'OK'),
            child: const Text(
              "Okay",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w300,
              ),
            ),
          ),
        ],
      );
    },
  );
}

void NonRecycleDialogFuntion(context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      Size size = MediaQuery.of(context).size;

      return AlertDialog(
        elevation: 24.0,
        backgroundColor: Colors.red[400],
        title: Text(
          "Non - Recyclable !",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
        content: Image.asset(
          "assets/images/nonrecycleGif.gif",
          height: size.height * 0.15,
          width: size.height * 0.15,
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'OK'),
            child: const Text(
              "Okay",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w300,
              ),
            ),
          ),
        ],
      );
    },
  );
}


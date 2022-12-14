import 'package:flutter/material.dart';

import 'package:plant_app/constants.dart';
import 'package:plant_app/size_config.dart';

final ButtonStyle flatButtonStyle = TextButton.styleFrom(
  backgroundColor: kPrimaryColor,
  foregroundColor: kPrimaryColor,
  minimumSize: Size(88, 36),
  padding: EdgeInsets.symmetric(horizontal: 16.0),
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
  
);


class DefaultButton extends StatelessWidget {
  const DefaultButton({
    Key key,
    this.text,
    this.press,
  }) : super(key: key);
  final String text;
  final Function press;


  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: getProportionateScreenHeight(56),
      child: TextButton(
        style: flatButtonStyle,
       
        onPressed: press,
        child: Text(
          text,
          style: TextStyle(
            fontSize: getProportionateScreenWidth(18),
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}


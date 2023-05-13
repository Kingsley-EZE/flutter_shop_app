import 'package:flutter/material.dart';
import 'package:shop_app/utilities/constants.dart';


class BackArrowWidget extends StatelessWidget {
  const BackArrowWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.pop(context);
      },
      child: Container(
        padding: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
            color: kBackButtonBgColor,
            shape: BoxShape.circle
        ),
        child: CircleAvatar(
          backgroundColor: Colors.transparent,
          child: Icon(Icons.arrow_back, color: Colors.black,),
        ),
      ),
    );
  }
}
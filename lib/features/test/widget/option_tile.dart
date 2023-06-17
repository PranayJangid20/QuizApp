import 'package:flutter/material.dart';
import 'package:prepaud/utils/helper.dart';
import 'package:prepaud/utils/ui_helper.dart';

class OptionTile extends StatelessWidget {
  final String text;
  final int index;
  final bool isSelected;
  final bool result;
  const OptionTile({Key? key, required this.text, required this.isSelected, required this.index, required this.result}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width:double.infinity,
      padding: EdgeInsets.symmetric(vertical: 20,horizontal: 25),
      margin: const EdgeInsets.symmetric(vertical: 10,horizontal: 20),
      decoration: BoxDecoration(
          color: isSelected && result ?Colors.green: isSelected && !result?Colors.redAccent:Colors.white,
          borderRadius: BorderRadius.circular(5),
        boxShadow: const[
          BoxShadow(
            color: Colors.black12,
            offset: Offset(2,5),
            blurRadius: 5
          )
        ]
      ),
      child: Text.rich(
        TextSpan(
          children: [
            TextSpan(text: '${indexMap[index]}  ',style: fsHeadLine2(color: Colors.black26,)),

            TextSpan(text: text, style: fsHeadLine2(color: Colors.black87,fontWeight: FontWeight.w400)),
          ],
        ),
      ));
  }
}

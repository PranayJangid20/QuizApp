import 'package:flutter/material.dart';
import 'package:prepaud/utils/app_colors.dart';
import 'package:prepaud/utils/ui_helper.dart';

class AppButton extends StatelessWidget {
  final String text;
  final bool isEnabled;
  final bool isGradient;
  const AppButton({Key? key, required this.text, required this.isEnabled, this.isGradient = true}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: !isGradient ?Colors.white:null,
            gradient: isGradient
                ? LinearGradient(
                    colors:
                        isEnabled ? AppColors.gradient : [AppColors.buttonDisabeleColor, AppColors.buttonDisabeleColor],
                  )
                : null,
            boxShadow: isEnabled ? const [BoxShadow(color: Colors.black12, offset: Offset(2, 5), blurRadius: 5)] : []),
        child: Center(
          child: Text(text, style: fsHeadLine2(color:!isGradient ? Colors.black:Colors.white,fontWeight: FontWeight.w600)),
        ));
  }
}

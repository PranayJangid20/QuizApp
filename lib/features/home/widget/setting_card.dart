import 'package:flutter/material.dart';
import 'package:prepaud/utils/app_colors.dart';
import 'package:prepaud/utils/healper.dart';
import 'package:prepaud/utils/ui_helper.dart';

class SettingCard extends StatelessWidget {
  final VoidCallback upFunc;
  final VoidCallback downFunc;
  final String data;
  const SettingCard({Key? key, required this.data, required this.upFunc, required this.downFunc}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(padding: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            color: Colors.orange,
            borderRadius: BorderRadius.circular(5),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(onPressed: upFunc, icon: const Icon(Icons.arrow_drop_up,color: Colors.white,)),

              Padding(padding: const EdgeInsets.all(8),
                child: SizedBox(
                    width: 50,
                    child: Text(data,style: fsHeadLine3(color: Colors.white,fontWeight: FontWeight.w500),textAlign: TextAlign.center,)),
              ),

              IconButton(onPressed: downFunc, icon: const Icon(Icons.arrow_drop_down,color: Colors.white))
            ],
          ),
        )
      ],
    );
  }
}

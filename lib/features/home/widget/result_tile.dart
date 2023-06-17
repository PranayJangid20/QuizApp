import 'package:flutter/material.dart';
import 'package:prepaud/features/home/model/result.dart';
import 'package:prepaud/utils/app_colors.dart';
import 'package:prepaud/utils/helper.dart';
import 'package:prepaud/utils/ui_helper.dart';

class ResultTile extends StatelessWidget {
  final Result result;

  const ResultTile({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5)
      ),
      elevation: 5,
      margin: const EdgeInsets.all(8.0),
      color: AppColors.primaryColor,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text('Score: ${result.score} points',style: fsHeadLine5(color: Colors.white,fontWeight: FontWeight.w600)),
                const Spacer(),
                Text('Act Time: ${result.actTime} sec',style: fsHeadLine5(color: Colors.white)),
              ],
            ),
            5.spaceY,
            Text('Date : ${result.time.toDate}',style: fsHeadLine5(color: Colors.white.withOpacity(0.5)),),
          ],
        ),
      ),
    );
  }
}

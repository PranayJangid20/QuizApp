import 'package:flutter/material.dart';
import 'package:prepaud/common/app_button.dart';
import 'package:prepaud/features/test/cubit/test_cubit.dart';
import 'package:prepaud/features/test/model/question.dart';
import 'package:prepaud/utils/app_colors.dart';
import 'package:prepaud/utils/helper.dart';
import 'package:prepaud/utils/ui_helper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ExplanationBoard extends StatelessWidget {
  final Question question;
  const ExplanationBoard({Key? key, required this.question}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      padding: EdgeInsets.all(12),
      height: 80*4,
      width: double.infinity,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: AppColors.primaryColor,
          )
      ),
      child: Column(
        children: [
          Text('Explanation',style: fsHeadLine2(color: Colors.black87,fontWeight: FontWeight.bold),),
          10.spaceY,
          Text(question.explanation!,style: fsHeadLine3(color: Colors.black87),textAlign: TextAlign.center,),
          const Spacer(),
          AppButton(text: 'NEXT', isEnabled: true, onTap: ()=>BlocProvider.of<TestCubit>(context).nextQuestion())
        ],
      ),
    );
  }
}

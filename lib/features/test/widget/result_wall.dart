import 'package:flutter/material.dart';
import 'package:prepaud/common/app_button.dart';
import 'package:prepaud/features/home/cubit/home_cubit.dart';
import 'package:prepaud/features/test/cubit/test_cubit.dart';
import 'package:prepaud/utils/app_colors.dart';
import 'package:prepaud/utils/helper.dart';
import 'package:prepaud/utils/ui_helper.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ResultWall extends StatelessWidget {
  final QuizOver state;
  const ResultWall({Key? key, required this.state}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.symmetric(vertical: 50, horizontal: 30),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(colors: AppColors.gradient),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10, spreadRadius: 1)],
      ),
      child: Column(
        children: [
          Text(
            "Score",
            style: fsHeadLine2(color: Colors.white, fontWeight: FontWeight.w600),
          ),
          Text(
            '${state.finalScore}/${state.question.length * 5}',
            style: fsHeadLine1(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          20.spaceY,
          Text(
            "Correctness",
            style: fsHeadLine2(color: Colors.white, fontWeight: FontWeight.w600),
          ),
          Text(
            '${state.correct} out of ${state.question.length}',
            style: fsHeadLine3(
              color: Colors.white,
            ),
          ),
          10.spaceY,
          Text(
            'Total attempted : ${state.attemp}',
            style: fsHeadLine3(
              color: Colors.white,
            ),
          ),
          10.spaceY,
          Text(
            'Act Time : ${state.actTime}',
            style: fsHeadLine3(
              color: Colors.white,
            ),
          ),
          const Spacer(),
          Lottie.asset(
            state.percent > 91
                ? 'Assets/lottie/trophy.json'
                : state.percent > 50
                ? 'Assets/lottie/rating.json'
                : 'Assets/lottie/excl.json',
          ),
          const Spacer(),

          AppButton(text: 'OKAY', isEnabled: true,isGradient: false,onTap: (){
          context.read<HomeCubit>().fetchPreviousResults();
              Navigator.pop(context);
          },)
        ],
      ),
    );
  }
}

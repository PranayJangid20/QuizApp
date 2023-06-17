import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prepaud/features/test/widget/result_wall.dart';
import 'package:prepaud/features/test/cubit/test_cubit.dart';
import 'package:prepaud/features/test/widget/option_tile.dart';
import 'package:prepaud/utils/app_colors.dart';
import 'package:prepaud/utils/helper.dart';
import 'package:prepaud/utils/ui_helper.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:circular_countdown/circular_countdown.dart';

class TestPage extends StatefulWidget {
  const TestPage({Key? key, required this.totalQuestion, required this.correctPoint, required this.wrongPoint})
      : super(key: key);
  final int totalQuestion;
  final int correctPoint;
  final int wrongPoint;

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {

  @override
  void initState() {
    context.read<TestCubit>().fetchQuestions(
        totalTQuestions: widget.totalQuestion,
        correctTPoint: widget.correctPoint,
        wrongTPoint: widget.wrongPoint);
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TestCubit, TestState>(
      builder: (context, state) {
        return WillPopScope(
          onWillPop: ()async{

            BlocProvider.of<TestCubit>(context).closeStream();
             return await true;
          },
          child: Scaffold(
            backgroundColor: AppColors.backgroundColor,
            body: state is TestQuestionUpdatedState
                ? Column(
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height * 0.2,
                        decoration: BoxDecoration(gradient: LinearGradient(colors: AppColors.gradient)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Q : ${state.current}/${widget.totalQuestion}',
                                  style: fsHeadLine3(color: Colors.white, fontWeight: FontWeight.bold),
                                ),
                              ),
                              10.spaceY,
                              Row(
                                children: [
                                  const Icon(
                                    Icons.done,
                                    color: Colors.green,
                                    size: 20,
                                  ),
                                  Text(": +${widget.correctPoint.toString()} point",
                                      style: fsHeadLine6(color: Colors.black)),
                                  10.spaceX,
                                  const Icon(
                                    Icons.cancel,
                                    color: Colors.red,
                                    size: 20,
                                  ),
                                  Text(": -${widget.wrongPoint.toString()} point",
                                      style: fsHeadLine6(color: Colors.black)),
                                ],
                              ),
                              Stack(children: [
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(Icons.sports_score, color: Colors.white),
                                      10.spaceX,
                                      Text(
                                        state.score,
                                        style: fsHeadLine1(color: Colors.white, fontWeight: FontWeight.w600),
                                      ),
                                    ],
                                  ),
                                ),
                                AnimatedAlign(
                                  alignment: state.scorePosition,
                                  duration:
                                      state.selected != -1 ? const Duration(seconds: 1) : const Duration(seconds: 0),
                                  curve: Curves.easeOut,
                                  child: AnimatedOpacity(
                                    opacity: state.scoreOpacity,
                                    duration:
                                        state.selected != -1 ? const Duration(seconds: 1) : const Duration(seconds: 0),
                                    child: Text(
                                      state.point == "0" ? '' : state.point,
                                      style: fsHeadLine1(color: Colors.white, fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ),
                              ]),
                              20.spaceY,
                              StepProgressIndicator(
                                totalSteps: widget.totalQuestion,
                                currentStep: state.current,
                                selectedColor: AppColors.backgroundColor,
                                unselectedColor: Colors.grey,
                                customStep: (index, color, size) => Container(
                                  decoration: BoxDecoration(
                                    color: (state.current - 1) != index ? color : Colors.green,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                        child: Text.rich(TextSpan(children: [
                          TextSpan(
                              text: "Q.",
                              style: fsHeadLine3(color: Colors.black.withOpacity(0.4), fontWeight: FontWeight.w500)),
                          TextSpan(
                              text: state.question.question ?? "",
                              style: fsHeadLine3(color: Colors.black.withOpacity(0.7), fontWeight: FontWeight.w600)),
                        ])),
                      ),

                      ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: state.question.options?.length ?? 0,
                          itemBuilder: (_, index) {
                            return InkWell(
                              onTap: () {
                                state.selected == -1 ? context.read<TestCubit>().onAnswer(index) : null;
                              },
                              child: OptionTile(
                                  result: state.question.answer == state.question.correctAnswer,
                                  index: index,
                                  text: state.question.options![index],
                                  isSelected: index == state.selected),
                            );
                          }),

                      const Spacer(),
                      TimeCircularCountdown(
                        unit: CountdownUnit.second,
                        countdownTotal: 5,
                        countdownRemainingColor: AppColors.primaryColor,
                        countdownCurrentColor: Colors.white,
                        repeat: true,
                        onUpdated: (unit, remainingTime) => BlocProvider.of<TestCubit>(context).updateTime(5-remainingTime),
                        // onFinished: () => print('Countdown finished'),
                      ),

                      10.spaceY
                      //AppButton(text: 'Next', isEnabled: state.selected != -1)
                    ],
                  )
                : state is QuizOver
                    ? ResultWall(
                        state: state,
                      )
                    : Center(
                        child: CircularProgressIndicator(color: AppColors.primaryColor),
                      ),
          ),
        );
      },
    );
  }
}

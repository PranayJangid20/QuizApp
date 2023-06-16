import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';
import 'package:prepaud/database/databese_service.dart';
import 'package:prepaud/features/home/model/users.dart';
import 'package:prepaud/features/test/data/test_repository.dart';
import 'package:prepaud/features/test/model/question.dart';
import 'package:prepaud/main.dart';
import 'package:prepaud/utils/healper.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';

part 'test_state.dart';

class TestCubit extends Cubit<TestState> {
  TestCubit() : super(TestInitial());
  final DatabaseService databaseService = locator<DatabaseService>();
  TestRepository? repository;

  CountDownController? counter;

  List<Question> _questions = [];

  int totalQuestions = 10;
  int currentQuestion = 0;

  int correctPoint = 5;
  int wrongPoint = 5;

  int score = 0;

  double actionTime = 0;

  Alignment scorePosition = Alignment.centerRight;
  double scoreOpacity = 1;

  setScoreAnimation() {
    scorePosition = Alignment.center;
    scoreOpacity = 0.0;
  }

  resetScoreAnimation({DataUpdatedState? state}) {
    scorePosition = Alignment.centerRight;
    scoreOpacity = 1;
    if(state != null){
      DataUpdatedState stat = state;
      stat.scoreOpacity = 1;
      stat.scorePosition = Alignment.centerRight;
      'reset'.log();
      emit(stat);
    }
  }

  onAnswer(int index) {
    String? ans = _questions.last.options?[index];
    Question question = _questions.last;
    question.answer = ans!;
    scoreTracker(question.correctAnswer == question.answer);
    setScoreAnimation();
    counter!.getTime().log();
    //actionTime += int.parse(counter!.getTime()??'0');
    emit(DataUpdatedState(
        question: question,
        current: currentQuestion,
        selected: index,
        scoreOpacity: scoreOpacity,
        scorePosition: scorePosition,
        point: question.correctAnswer == question.answer ? '+${correctPoint.toString()}' : '-${wrongPoint.toString()}',
        score: score.toString()));
  }

  scoreTracker(bool result){
    !result?score-=wrongPoint:score+= correctPoint;
  }

  void onDataReceived(String newData) {
    resetScoreAnimation();
    if(_questions.isNotEmpty && _questions.last.answer == '' ){
      //score -= missPoint;
    }
    counter!.restart(duration: 5);
    Question question = Question.fromJson(jsonDecode(newData));
    currentQuestion++;
    _questions.add(question);
    question.correctAnswer.log();

    emit(DataUpdatedState(
        question: question,
        current: currentQuestion,
        scoreOpacity: scoreOpacity,
        scorePosition: scorePosition,
        score: score.toString()));
    if(totalQuestions <= currentQuestion){
      lastQuestion();
    }
  }

  lastQuestion(){
    Future.delayed(const Duration(seconds: 5)).then((value) {
      int attemps = _questions.where((element) => element.answer !="").toList().length;
      int correct = _questions.where((element) => element.answer == element.correctAnswer).toList().length;
      if(_questions.last.answer == '' ){
        //score -= 5;
      }
      double percent = (score/(totalQuestions*correctPoint))*100;
      double actTime = actionTime/totalQuestions;
      'result'.log();
      percent.log();
      databaseService.insertScore(score.toString(), actTime.toString());
      emit(QuizOver(_questions, score,attemps,correct,percent,actTime));
      return ;
    });
  }


  fetchQuestions({required int totalTQuestions, required int correctTPoint, required int wrongTPoint,required CountDownController controller}){
    totalQuestions = totalTQuestions;
    correctPoint = correctTPoint;
    wrongPoint = wrongTPoint;
    counter = controller;
    _questions = [];
    score = 0;
    actionTime = 0;
    repository = TestRepository();
    repository!.fetchQuestions(totalQuestions, onDataReceived);
  }
}
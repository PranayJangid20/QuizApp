import 'dart:async';
import 'dart:convert';
import 'package:flip_card/flip_card_controller.dart';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';
import 'package:prepaud/database/databese_service.dart';
import 'package:prepaud/features/test/data/test_repository.dart';
import 'package:prepaud/features/test/model/question.dart';
import 'package:prepaud/main.dart';
import 'package:prepaud/utils/helper.dart';
part 'test_state.dart';

class TestCubit extends Cubit<TestState> {
  TestCubit() : super(TestInitial());
  final DatabaseService databaseService = locator<DatabaseService>();
  TestRepository? repository;

  List<Question> _questions = [];

  int totalQuestions = 10;
  int currentQuestion = 0;

  late FlipCardController _controller;

  bool waiting = false;

  late Timer _timer;
  int timeFromStart = 0;

  int correctPoint = 5;
  int wrongPoint = 5;

  int score = 0;

  double actionTime = 0;

  Alignment scorePosition = Alignment.centerRight;
  double scoreOpacity = 1;

  // responsible for setting score animation on user answer questions
  setScoreAnimation() {
    scorePosition = Alignment.center;
    scoreOpacity = 0.0;
    _controller.toggleCard();
  }

  // responsible for resetting score animation on new question arrival
  resetScoreAnimation() {
    scorePosition = Alignment.centerRight;
    scoreOpacity = 1;
    _controller.toggleCardWithoutAnimation();
  }

  // responsible for registering user selected answer and calculate act time
  onAnswer(int index) async {

    // it store details in questions model
    Question question = _questions[currentQuestion];
    String? ans = question.options?[index];
    question.answer = ans!;
    scoreTracker(question.correctAnswer == ans);
    setScoreAnimation();
    actionTime += timeFromStart;

    'time to act $timeFromStart'.log();
    _timer.cancel();
    timeFromStart = 0;

    emit(TestQuestionUpdatedState(
        question: question,
        current: currentQuestion,
        selected: index,
        scoreOpacity: scoreOpacity,
        scorePosition: scorePosition,
        point: question.correctAnswer == ans ? '+${correctPoint.toString()}' : '-${wrongPoint.toString()}',
        score: score.toString()));

  }

  // responsible for getting state ready for displaying next question
  nextQuestion() {
    startTimer();
    currentQuestion++;
    resetScoreAnimation();

    if (totalQuestions != _questions.length) {
      // if not all questions received it emit loading state and wait for remaining questions
      waiting = true;
      emit(TestLoading());
    } else if (currentQuestion < _questions.length) {
      emit(TestQuestionUpdatedState(
          question: _questions[currentQuestion],
          current: currentQuestion,
          score: score.toString(),
          scorePosition: scorePosition,
          scoreOpacity: scoreOpacity));
    } else {
      // if user answers all the questions then it will calculate score and display score board
      quizOver();
    }
  }

  // Timer to track time taken to act by user
  // on every questions it start the timer
  startTimer() {
    "timer started".log();
    Timer.periodic(const Duration(seconds: 1), (timer) {
      _timer = timer;
      timeFromStart++;
    });
  }

  // add or subtract score
  scoreTracker(bool result) {
    !result ? score -= wrongPoint : score += correctPoint;
  }

  // this function received questions by repository
  // responsible to start game
  void onQuestionReceived(Question question) {
    //resetScoreAnimation();

    _questions.add(question);
    question.correctAnswer.log();

    "from on data".log();

    if (_questions.length == 1) {
      startTimer();
      emit(TestQuestionUpdatedState(
          question: question,
          current: currentQuestion,
          scoreOpacity: scoreOpacity,
          scorePosition: scorePosition,
          score: score.toString()));
    }

    // if there is condition when api takes long time to receive data it is responsible to resume game
    // like user started game for 10 questions and only 8 question recieved then it will resume game
    // on receiving remaining question
    if (waiting) {
      startTimer();
      waiting = false;
      emit(TestQuestionUpdatedState(
          question: question,
          current: currentQuestion,
          scoreOpacity: scoreOpacity,
          scorePosition: scorePosition,
          score: score.toString()));
    }
  }

  // this is responsible for calculating score and various parameters on quiz ends
  // responsible for emitting Quiz Over state and display score board
  quizOver() {
    int attemps = _questions.where((element) => element.answer != "").toList().length;
    int correct = _questions.where((element) => element.answer == element.correctAnswer).toList().length;
    if (_questions.last.answer == '') {
      //score -= 5;
    }
    double percent = (score / (totalQuestions * correctPoint)) * 100;
    double actTime = actionTime / totalQuestions;
    'result'.log();
    percent.log();
    databaseService.insertScore(score.toString(), actTime.toString());
    emit(QuizOver(_questions, score, attemps, correct, percent, actTime));
  }

  // This is responsible for triggering questions fetching from repository and network
  fetchQuestions(
      {required int totalTQuestions,
      required int correctTPoint,
      required int wrongTPoint,
      required FlipCardController controller}) {
    totalQuestions = totalTQuestions;
    correctPoint = correctTPoint;
    wrongPoint = wrongTPoint;
    _controller = controller;
    _questions = [];
    score = 0;
    actionTime = 0;
    repository = TestRepository();
    repository!.fetchQuestions(totalQuestions, onQuestionReceived);
  }

  closeStream() {
    repository != null ? repository!.closeStream() : null;
  }
}

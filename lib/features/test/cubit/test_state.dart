part of 'test_cubit.dart';

@immutable
abstract class TestState extends Equatable {}

class TestInitial extends TestState {
  @override
  List<Object> get props => [];
}
class DataUpdatedState extends TestState {
  Question question;
  final int selected;

  String score;
  String point;
  Alignment scorePosition;
  double scoreOpacity;
  int current;
  DataUpdatedState(
      {required this.question,
        required this.current,
      this.selected = -1,
      required this.score,
      this.point = '0',
      required this.scorePosition,
      required this.scoreOpacity});

  @override
  // TODO: implement props
  List<Object?> get props => [question, selected, scoreOpacity, scorePosition, score];
}

class QuizOver extends TestState {
  final List<Question> question;
  final int finalScore;
  final int attemp;
  final int correct;
  final double percent;
  final double actTime;

  QuizOver(this.question, this.finalScore, this.attemp, this.correct, this.percent, this.actTime);

  @override
  // TODO: implement props
  List<Object?> get props => [question, finalScore, attemp];
}

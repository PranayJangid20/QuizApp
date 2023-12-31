import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:prepaud/database/databese_service.dart';
import 'package:prepaud/features/home/data/home_repository.dart';
import 'package:prepaud/features/home/model/result.dart';
import 'package:prepaud/main.dart';
part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());

  // Get Database instance from locator
  DatabaseService databaseService = locator<DatabaseService>();
  HomeRepository repository = HomeRepository();

  // array to store previous results
  List<Result> results = [];

  int numberOfQues = 10;

  List lvlList = ["Easy", "Mid", "Pro"];

  int lvlSeleted = 0;

  String level = 'Easy';

  // this is map that has value as [PointsOnCorrectAnswer, PointsToDeductWrongAnswer] acc to selected level
  Map<String, List> pointMap = {
    "Easy": [5, 0],
    "Mid": [5, 2],
    'Pro': [5, 5]
  };

  // responsible for selecting total numbers of question
  questionUp() {
    if (numberOfQues == 30) {
      numberOfQues = 10;
    } else {
      numberOfQues += 10;
    }
    emit(HomePageLoaded(results, lvlList[lvlSeleted], numberOfQues, pointMap[level]!));
  }

  questionDown() {
    if (numberOfQues == 10) {
      numberOfQues = 30;
    } else {
      numberOfQues -= 10;
    }
    emit(HomePageLoaded(results, lvlList[lvlSeleted], numberOfQues, pointMap[level]!));
  }

  // responsible for selecting total level of game
  levelUp() {

      lvlSeleted += 1;
      lvlSeleted = lvlSeleted.clamp(0, lvlList.length-1);

      level = lvlList[lvlSeleted];
    emit(HomePageLoaded(results, lvlList[lvlSeleted], numberOfQues, pointMap[level]!));
  }

  levelDown() {

      lvlSeleted -= 1;
      lvlSeleted = lvlSeleted.clamp(0, lvlList.length-1);


      level = lvlList[lvlSeleted];

    emit(HomePageLoaded(results, lvlList[lvlSeleted], numberOfQues, pointMap[level]!));
  }

  // responsible for collecting previous results
  // and store them in results array in Result Model form
  fetchPreviousResults() async {
    var result = await databaseService.getScores();
    if (result.isNotEmpty) {
      results = result.reversed.map((e) => Result.fromMap(e)).toList();
    }
    else{
      results = [];
    }

    emit(HomePageLoaded(results, lvlList[lvlSeleted], numberOfQues, pointMap[level]!));
  }
}

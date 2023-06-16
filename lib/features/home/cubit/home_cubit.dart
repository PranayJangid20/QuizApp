import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:prepaud/database/databese_service.dart';
import 'package:prepaud/features/home/data/home_repository.dart';
import 'package:prepaud/features/home/model/users.dart';
import 'package:prepaud/main.dart';
import 'package:prepaud/service/network_service.dart';
import 'package:prepaud/service/sse_network_service.dart';
import 'package:prepaud/utils/app_constant.dart';
import 'package:prepaud/utils/healper.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());
  List<Result> results = [];

  int numberOfQues = 10;

  List lvlList = ["Easy", "Mid", "Pro"];

  int lvlSeleted = 0;

  String level = 'Easy';

  Map<String, List> pointMap = {
    "Easy": [5, 0],
    "Mid": [5, 2],
    'Pro': [5, 5]
  };

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

  DatabaseService databaseService = locator<DatabaseService>();

  HomeRepository repository = HomeRepository();
  fetchPreviousResults() async {
    var result = await databaseService.getScores();
    if (result.isNotEmpty) {
      results = result.map((e) => Result.fromMap(e)).toList();
    }
    else{
      results = [];
    }

    emit(HomePageLoaded(results, lvlList[lvlSeleted], numberOfQues, pointMap[level]!));
  }
}

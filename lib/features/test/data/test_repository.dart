import 'dart:convert';

import 'package:prepaud/features/test/model/question.dart';
import 'package:prepaud/service/network_service.dart';
import 'package:prepaud/utils/helper.dart';

class TestRepository {
  final NetworkService _networkService = NetworkService();
  var _callback;

  // responsible to get call SSE api and send Question Model via _callback
  fetchQuestions(int maxQuestion, void Function(Question) onQuestionReceived) async {
    _callback = onQuestionReceived;
    _networkService.eventSource('questions?n=${maxQuestion.toString()}', getQuestion);
  }

  closeStream() {
    _networkService.closeStream();
  }

  //responsible for converting response to QuestionModel
  getQuestion(String response) {
    var json = jsonDecode(response);

    'fom_getQuestion $response'.log();

    Question question = Question.fromJson(json);

    _callback(question);
  }
}

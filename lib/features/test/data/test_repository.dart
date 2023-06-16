import 'package:prepaud/service/network_service.dart';
import 'package:prepaud/utils/healper.dart';

class TestRepository {
  final NetworkService _networkService = NetworkService();
   fetchQuestions(int maxQuestion,void Function(String) onDataReceived) async {
     _networkService.eventSource('questions?n=${maxQuestion.toString()}',onDataReceived).then((stream) {

     });
   }
}

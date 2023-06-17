import 'package:prepaud/service/network_service.dart';
class TestRepository {
  final NetworkService _networkService = NetworkService();
   fetchQuestions(int maxQuestion,void Function(String) onDataReceived) async {
     _networkService.eventSource('questions?n=${maxQuestion.toString()}',onDataReceived);
   }

   closeStream(){
     _networkService.closeStream();
   }


}

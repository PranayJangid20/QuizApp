import 'package:prepaud/service/network_service.dart';

class HomeRepository {
  NetworkService networkService = NetworkService();
   Future<Map<String, dynamic>> fetchData(String page) async {
    
    try {
      return await NetworkService.get(page);
    } catch (e) {
      return {'success': false, 'result': 501};
    }
  }

  
}

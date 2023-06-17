import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:prepaud/utils/app_constant.dart';
import 'package:eventsource/eventsource.dart';
import 'package:prepaud/utils/helper.dart';

class NetworkService {
  var client = http.Client();
  late EventSource _eventSource;
  static Future<Map<String, dynamic>> get(String page) async {
    String url = AppConstant.url + page;
    try {
      var response = await http.get(Uri.parse(url));
      return _fetchResponse(response);
    } catch (e) {
      return {'success': false, 'result': 501};
    }
  }

  eventSource(String param, void Function(String) onDataReceived) async {
    try {
      _eventSource = await EventSource.connect(AppConstant.url + param);

      _eventSource.listen((Event event) {
        var data = event.data.toString() ?? '';
        onDataReceived(data);
      });

      _eventSource.onError.listen((error) {
        // Handle SSE connection closure
        'SSE connection closed: $error'.log();
        // Perform additional actions like reconnection or error display
      });
    }
    catch(e){
      "Network Error".log();
    }
  }

  closeStream() {
    if (_eventSource != null) {
      try{
        _eventSource.client.close();
      }on SocketException catch(e){
        'No internet connection'.log();
      }on HttpException catch(e){
        "Client disconnected".log();
      }catch(e){
        "Other Problem".log();
      }

    }
  }

  static dynamic _fetchResponse(http.Response response) {
    var responseJson;
    if (response.body.isNotEmpty) {
      responseJson = json.decode(response.body);
    } else {
      responseJson = <dynamic, String>{};
    }

    if (response.statusCode == 200 || response.statusCode == 201) {
      return {'success': true, 'data': responseJson};
    } else {
      return {'success': false};
    }
  }
}

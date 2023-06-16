import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:prepaud/utils/app_constant.dart';
import 'package:eventsource/eventsource.dart';
import 'package:sse_channel/sse_channel.dart';


class NetworkService {

  late SseChannel _channel ;
  static Future<Map<String, dynamic>> get(String page) async {
    String url = AppConstant.url + page;
    try {
      var response = await http.get(Uri.parse(url));
      return _fetchResponse(response);
    } catch (e) {
      return {'success': false, 'result': 501};
    }
  }

  eventSource(String param,void Function(String) onDataReceived)async{
    EventSource eventSource = await EventSource.connect(AppConstant.url+param);
    eventSource.listen((Event event) {
      var data = event.data.toString()??'';
      onDataReceived(data);
    });

  }

  startSse(){
    _channel = SseChannel.connect(Uri.parse('http://127.0.0.1:8080/sseHandler'));
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

import 'package:http/http.dart' show get;
import 'dart:convert' as json;

class API {
  static final _typeNames = ["Shot-Left", "Pass-Left", "Walking"];

  static Future<void> getTrainData(idSujeto, idTipo) async {
    // TODO pedir datos de entrenamiento a la API (video, etc)
    return Future.delayed(Duration(milliseconds: 500));
  }

  static Future<dynamic> compareData(idSujeto, idTipo) async {
    var resp = await get(
        'http://63.35.172.207:8000/getData/00$idSujeto/${_typeNames[idTipo]}-1');
    return json.jsonDecode(resp.body);
  }
}

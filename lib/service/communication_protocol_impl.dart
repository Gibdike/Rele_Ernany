import 'package:controle_bluetooth/service/communicaton_protocol.dart';

class CommunicationProtocolImpl implements CommunicationProtocol {
  @override
  String decode(String nome, CommandType type, dynamic data) {
    throw UnimplementedError();
  }

  @override
  String encode(String nome, CommandType type, String data) {
    var _data = convertData(type, data);
    /*
    * protocolo de comunicação com o esp32,
    * tipoDoComando!nomeDoDispositivo!dado
    * */
    var msg = 'Abrir';
    return msg;
  }

  @override
  String convertData(CommandType type, String data) {
    switch (type) {
      case CommandType.air:
        return data == 'true' ? '3' : '2';
      case CommandType.power:
        return 'null';
      case CommandType.temperature:
        return data.toString();
    }
    return 'null';
  }
}

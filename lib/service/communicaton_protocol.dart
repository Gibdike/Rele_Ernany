enum CommandType {
  ligar,
  air,
}

abstract class CommunicationProtocol {
  String encode(String nome, CommandType type, String data);
  String decode(String nome, CommandType type, dynamic data);
  String convertData(CommandType type, String data);
}

const String serverIp = 'localhost';
const int serverPort = 3000;

String get baseUrl => 'http://$serverIp:$serverPort/api';
String get socketUrl => 'ws://$serverIp:$serverPort';

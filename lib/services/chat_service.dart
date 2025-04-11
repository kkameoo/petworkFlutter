// import 'package:stomp_dart_client/stomp.dart';
// import 'package:stomp_dart_client/stomp_config.dart';
// import 'package:stomp_dart_client/stomp_frame.dart';
//
// class ChatService {
//   late StompClient stompClient;
//
//   void connect(String userId) {
//     stompClient = StompClient(
//       config: StomConfig(
//         url: 'http://localhost:8087/ws',
//         onConnect: (StompFrame frame) {
//           print("WebSocket 연결됨");
//           stompClient.subscribe(
//             destination: '/user/$userId/notification',
//             callback: (frame) {
//               print("메시지 수신: ${frame.body}");
//             },
//           );
//         },
//         beforeConnect: () async {
//           print("WebSocket 연결 시도 중...");
//         },
//         onDisconnect: (frame) {
//           print("WebSocket 연결 종료");
//         },
//       ),
//     );
//
//     stompClient.activate();
//   }
//
//   void sendMessage(String userId, String message) {
//     stompClient.send(
//       destination: "/app/chat",
//       body: message,
//       headers: {"userId": userId},
//     );
//   }
// }

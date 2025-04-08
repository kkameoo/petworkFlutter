import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final List<Map<String, dynamic>> _messages = [];
  final ImagePicker _picker = ImagePicker();

  void _sendMessage({String? text, List<File>? imageFiles}) {
    if ((text != null && text.isNotEmpty) || (imageFiles != null && imageFiles.isNotEmpty)) {
      setState(() {
        _messages.add({
          'text': text,
          'images': imageFiles ?? [],
          'isMe': true,
          'timestamp': DateTime.now(),
        });
      });
      _messageController.clear();
    }
  }

  Future<void> _pickImages() async {
    final List<XFile> pickedFiles = await _picker.pickMultiImage();
    if (pickedFiles.isNotEmpty) {
      List<File> files = pickedFiles.map((xfile) => File(xfile.path)).toList();
      _sendMessage(imageFiles: files);
    }
  }

  void _deleteImage(int messageIndex, int imageIndex) {
    setState(() {
      _messages[messageIndex]['images'].removeAt(imageIndex);
    });
  }

  Widget _buildMessage(Map<String, dynamic> message, int messageIndex) {
    final bool isMe = message['isMe'];
    final String time = DateFormat('HH:mm').format(message['timestamp']);
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 6, horizontal: 10),
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isMe ? Colors.green[100] : Colors.grey[300],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment:
          isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            if (message['text'] != null)
              Text(message['text'], style: TextStyle(fontSize: 16)),
            if (message['images'] != null)
              Column(
                children: List.generate(message['images'].length, (imgIndex) {
                  final imageFile = message['images'][imgIndex];
                  return Stack(
                    alignment: Alignment.topRight,
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 8),
                        height: 150,
                        child: Image.file(imageFile),
                      ),
                      IconButton(
                        icon: Icon(Icons.close, color: Colors.red),
                        onPressed: () => _deleteImage(messageIndex, imgIndex),
                      )
                    ],
                  );
                }),
              ),
            SizedBox(height: 5),
            Text(time, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('채팅 테스트')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return _buildMessage(_messages[index], index);
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.image),
                  onPressed: _pickImages,
                ),
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(labelText: '메시지 입력'),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () => _sendMessage(text: _messageController.text),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

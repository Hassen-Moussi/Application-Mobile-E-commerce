import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../services/services.dart';

class ChatScreen extends StatefulWidget {
  final String employeeId;

  ChatScreen({required this.employeeId});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _textEditingController = TextEditingController();
  final userformservice _chatService = userformservice();
  List<dynamic> _messages = [];

  @override
  void initState() {
    super.initState();
    _getMessages();
  }

  void _getMessages() async {
    dynamic emplyid = await storage.read(key: 'idvalue');
    final messages = await _chatService.getMessages('a989935b-6023-4bd1-b86e-592c16f634fd');
    if (messages != null) {
      setState(() {
        _messages = messages ;
      });
    } else {
      // display error message
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Failed to load messages'),
            actions: [
              TextButton(
                child: Text('OK'),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          );
        },
      );
    }
  }

  void _addMessage(String message) async {
    await _chatService.addMessage('a989935b-6023-4bd1-b86e-592c16f634fd', message);
    _getMessages();
  }

  Widget _buildMessage(dynamic message) {
    final dateTime = DateTime.parse(message['created_at']);
    final formattedTime = DateFormat.jm().format(dateTime);
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            message['message'],
            style: TextStyle(fontSize: 16.0),
          ),
          SizedBox(height: 5.0),
          Text(
            formattedTime,
            style: TextStyle(fontSize: 12.0, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageList() {
    return Expanded(
      child: ListView.builder(
        itemCount: _messages.length,
        itemBuilder: (BuildContext context, int index) {
          final message = _messages[index];
          return _buildMessage(message);
        },
      ),
    );
  }

  void _sendMessage() {
    final message = _textEditingController.text;
    if (message.isNotEmpty) {
      _addMessage(message);
      _textEditingController.clear();
    }
  }

  Widget _buildChatInput() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _textEditingController,
              decoration: InputDecoration(
                hintText: 'Type your message here...',
              ),
            ),
          ),
          SizedBox(width: 8.0),
          IconButton(
            icon: Icon(Icons.send),
            onPressed: _sendMessage,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat'),
      ),
      body: Column(
        children: [
          _buildMessageList(),
          _buildChatInput(),
        ],
      ),
    );
  }
}
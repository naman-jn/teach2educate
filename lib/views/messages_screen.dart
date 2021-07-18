import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teach2educate/colors.dart';
import 'package:teach2educate/models/model.dart';
import 'package:teach2educate/services/database_service.dart';

class MessagesScreen extends StatelessWidget {
  final TextEditingController _messageController = TextEditingController();
  final bool? isMobile;

  MessagesScreen({Key? key, this.isMobile}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    ActiveChat _activeChat = Provider.of<ActiveChat>(context);
    Passenger? _passenger = Provider.of<Passenger?>(context);

    showChatEndDialog(BuildContext context) {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text(
                  "Alert",
                  style: TextStyle(
                    fontSize: 25,
                    color: kNavy,
                  ),
                ),
                content: Text(
                  "Confirm closing chat room",
                  style: TextStyle(fontSize: 18),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      "No",
                      style: TextStyle(fontSize: 16, color: kYellow),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      if (isMobile != null) Navigator.pop(context);
                      DatabaseService().updateChatRequest(
                          _activeChat.chatRoomId!, RequestStatus.notConnected);
                      _activeChat.deActivateChat();
                    },
                    child: Text(
                      "Yes",
                      style: TextStyle(fontSize: 16, color: kRed),
                    ),
                  ),
                ],
              ));
    }

    return _activeChat.isChatInActive
        ? Container(
            child: Center(child: Text("Select a chat to start messaging")),
          )
        : SafeArea(
            child: Scaffold(
              body: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.all(5),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (isMobile != null)
                            IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: Icon(
                                Icons.arrow_back,
                              ),
                            )
                          else
                            SizedBox(width: 10),
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Icon(Icons.person_outline_outlined),
                          ),
                          SizedBox(width: 3),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: 12,
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: 100,
                                    child: Text(
                                      _activeChat.coPassenger!.name
                                          .split(" ")
                                          .first,
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    'xxxxxx' +
                                        _activeChat.coPassenger!.phoneNumber
                                            .substring(8),
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 10,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 3),
                              Text(
                                _activeChat.coPassenger!.role,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.black,
                                ),
                              ),
                              Text(
                                _activeChat.coPassenger!.company,
                                style: TextStyle(
                                  fontWeight: FontWeight.w300,
                                  fontSize: 10,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                          Spacer(),
                          IconButton(
                              onPressed: () {
                                showChatEndDialog(context);
                              },
                              icon: Icon(Icons.close))
                        ],
                      ),
                    ),
                    Divider(
                      color: Colors.black54,
                      endIndent: 20,
                      indent: 20,
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: StreamBuilder<List<Message>>(
                            stream: DatabaseService()
                                .getChatMesaages(_activeChat.chatRoomId!),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return Container();
                              }

                              List<Message> _messages = snapshot.data!;
                              return ListView.builder(
                                  itemCount: _messages.length,
                                  itemBuilder: (context, index) {
                                    Message message = _messages[index];
                                    return _buildMessage(message.content,
                                        isSend:
                                            message.senderId == _passenger!.id);
                                  });
                            }),
                      ),
                    ),
                    SizedBox(height: 20),
                    Container(
                      margin: EdgeInsets.all(10),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _messageController,
                              decoration: InputDecoration(
                                hintText: "Write a message...",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 7,
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.send_rounded,
                            ),
                            onPressed: () async {
                              if (_messageController.text.trim().isNotEmpty) {
                                await DatabaseService().sendMessage(
                                    _activeChat.chatRoomId!,
                                    Message(
                                        content: _messageController.text.trim(),
                                        senderId: _passenger!.id,
                                        timestamp: DateTime.now()));
                                _messageController.clear();
                              }
                            },
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
  }

  Widget _buildMessage(String message, {bool isSend = false}) {
    return Align(
      alignment: isSend ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.only(
            bottom: 10, left: isSend ? 15 : 0, right: isSend ? 0 : 15),
        decoration: BoxDecoration(
          border: Border.all(color: isSend ? kYellow : Colors.black),
          borderRadius: BorderRadius.circular(20),
        ),
        padding: EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 15,
        ),
        child: Text(
          message,
          style: TextStyle(color: isSend ? kYellow : Colors.black),
        ),
      ),
    );
  }
}

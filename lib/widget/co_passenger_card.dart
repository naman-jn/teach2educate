import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:teach2educate/colors.dart';
import 'package:teach2educate/models/model.dart';
import 'package:teach2educate/services/database_service.dart';
import 'package:teach2educate/views/messages_screen.dart';
import 'package:teach2educate/controllers/chat_room_controller.dart';

class CoPassengerCard extends StatelessWidget {
  final Passenger coPassenger;
  final Widget? trailing;

  CoPassengerCard({Key? key, required this.coPassenger, this.trailing})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    DeviceScreenType deviceScreenType =
        getDeviceType(MediaQuery.of(context).size);
    final ChatRoomController _chatRoomController = ChatRoomController();
    Passenger? passenger = Provider.of<Passenger?>(context);
    _chatRoomController.coPassengerId = coPassenger.id;
    _chatRoomController.passenger = passenger;

    Widget buildTrailing(RequestStatus requestStatus) {
      switch (requestStatus) {
        case RequestStatus.connected:
          return Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(
                Icons.done,
                size: 30,
                color: kYellow,
              ),
              SizedBox(
                height: 15,
              ),
              Text("Connected",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  )),
            ],
          );
        case RequestStatus.notConnected:
          return Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () {
                  _chatRoomController.sendRequest();
                },
                child: Icon(
                  Icons.add,
                  size: 30,
                  color: Colors.black,
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Text("Tap to connect",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  )),
            ],
          );
        case RequestStatus.requestSent:
          return Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () {
                  _chatRoomController.discardRequest();
                },
                child: Icon(
                  Icons.replay,
                  size: 30,
                  color: kRed,
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Text("Undo Request",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  )),
            ],
          );
        case RequestStatus.requestReceieved:
          return Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  InkWell(
                    onTap: () {
                      _chatRoomController.denyRequest();
                    },
                    child: Icon(
                      Icons.person_remove_alt_1_outlined,
                      size: 30,
                      color: kRed,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  InkWell(
                    onTap: () {
                      _chatRoomController.acceptRequest();
                    },
                    child: Icon(
                      Icons.person_add_alt_1_outlined,
                      size: 30,
                      color: kYellow,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 15,
              ),
              Text(
                  "${coPassenger.name.split(" ").first} has requested to connect",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  )),
            ],
          );
        case RequestStatus.requestDenied:
          return Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () {},
                child: Icon(
                  Icons.close,
                  size: 30,
                  color: kRed,
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Text("Your request was denied",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  )),
            ],
          );
        default:
          return Container();
      }
    }

    return Container(
      margin: EdgeInsets.only(bottom: 20),
      // decoration: BoxDecoration(
      //   borderRadius: BorderRadius.circular(12),
      //   boxShadow: [
      //     BoxShadow(
      //       color: Colors.grey.withOpacity(0.2),
      //       blurRadius: 5.0,
      //     )
      //   ],
      // ),
      child: ListTile(
        tileColor: Colors.white,
        contentPadding: EdgeInsets.all(10),
        shape: RoundedRectangleBorder(
            side: BorderSide(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(15)),
        onTap: () {
          if (_chatRoomController.chatRoom == null) {
            denyMessaging(context);
            return;
          }
          if (_chatRoomController.chatRoom!.requestStatus !=
              RequestStatus.connected) {
            denyMessaging(context);
            return;
          }
          ActiveChat _activeChat =
              Provider.of<ActiveChat>(context, listen: false);
          _activeChat.setActiveChat(
              chatRoomId: _chatRoomController.chatRoom!.id,
              coPassenger: coPassenger);
          if (deviceScreenType == DeviceScreenType.mobile) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return MessagesScreen(
                    isMobile: true,
                  );
                },
              ),
            );
          }
        },
        title: Stack(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.person_outline_outlined),
                SizedBox(width: 5),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 3,
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 110,
                          child: Text(
                            coPassenger.name.split(" ").first,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),
                        Text(
                          'xxxxxx' + coPassenger.phoneNumber.substring(8),
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 10,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 5),
                    Text(
                      coPassenger.role,
                      style: TextStyle(
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      coPassenger.company,
                      style: TextStyle(
                        fontWeight: FontWeight.w300,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Row(
              children: [
                Spacer(),
                if (passenger!.chatRooms[coPassenger.id] == null)
                  buildTrailing(RequestStatus.notConnected)
                else
                  StreamBuilder<ChatRoom?>(
                      stream: DatabaseService().getChatRoomDetails(
                          passenger.chatRooms[coPassenger.id]),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData)
                          return CircularProgressIndicator(
                            color: kGrey1,
                          );
                        _chatRoomController.chatRoom = snapshot.data;
                        return buildTrailing(
                            _chatRoomController.getRequestStatus());
                      }),
              ],
            )
          ],
        ),
      ),
    );
  }

  void denyMessaging(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text("You're not Connected with ${coPassenger.name}"),
      duration: Duration(seconds: 2),
    ));
  }
}

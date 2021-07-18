import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:teach2educate/models/passenger_model.dart';
import 'package:teach2educate/views/chat_rooms.dart';
import 'package:teach2educate/views/messages_screen.dart';
import '../widget/widget.dart';

class ChatScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Passenger? passenger = Provider.of<Passenger?>(context);
    if (passenger != null) print(passenger.name);

    return Scaffold(
      body: ScreenTypeLayout(
        breakpoints: ScreenBreakpoints(desktop: 900, tablet: 660, watch: 300),
        desktop: buildDesktopTablet(),
        tablet: buildDesktopTablet(),
        mobile: Column(
          children: [
            Expanded(
              child: ChatRooms(),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildDesktopTablet() {
    return Row(
      children: [
        Expanded(
          child: Column(
            children: [
              Divider(),
              Expanded(
                child: Row(
                  children: [
                    Container(
                      width: 400,
                      child: ChatRooms(),
                    ),
                    CustomDivider(),
                    Expanded(child: MessagesScreen()),
                  ],
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}

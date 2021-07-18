import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teach2educate/models/passenger_model.dart';
import 'package:teach2educate/widget/co_passenger_card.dart';

class ChatRooms extends StatelessWidget {
  const ChatRooms({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 25),
      child: Column(
        children: [
          Expanded(
            child: Container(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Co-passengers in your vicinity",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 19,
                        ),
                      ),
                    ),
                    SizedBox(height: 15),
                    Consumer<List<Passenger>>(builder: (_, passengers, __) {
                      return Column(
                        children: List.generate(
                          passengers.length,
                          (index) => CoPassengerCard(
                            coPassenger: passengers[index],
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

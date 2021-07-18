import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teach2educate/models/active_chat_room.dart';
import 'package:teach2educate/models/passenger_model.dart';
import 'package:teach2educate/routes/routers.dart';
import 'package:teach2educate/services/database_service.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<Passenger?>(
          create: (context) => DatabaseService().getPassengerDataStream(),
          initialData: null,
        ),
        StreamProvider<List<Passenger>>(
          create: (context) => DatabaseService().getCoPassengerss(),
          initialData: [],
        ),
        ChangeNotifierProvider(create: (context) => ActiveChat())
      ],
      child: MaterialApp(
        title: 'Chat Application',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(fontFamily: 'Montserrat'),
        initialRoute: '/',
        onGenerateRoute: Routers.generateRoute,
        navigatorKey: Routers.navigatorKey,
      ),
    );
  }
}

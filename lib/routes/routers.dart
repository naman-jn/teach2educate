import 'package:flutter/material.dart';
import 'package:teach2educate/views/chat_screen.dart';
import 'package:teach2educate/views/initial_details_page.dart';
import 'package:teach2educate/views/landing_page.dart';

class Routers {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static MaterialPageRoute<dynamic> switchRoutes(String routeName) {
    switch (routeName) {
      case '/':
        return MaterialPageRoute(builder: (_) => LandingPage());
      case '/home':
        return MaterialPageRoute(builder: (_) => ChatScreen());
      default:
        return MaterialPageRoute(builder: (_) {
          return Scaffold(
            body: Center(
              child: Text('No route defined for $routeName'),
            ),
          );
        });
    }
  }

  static Route<dynamic> generateRoute(RouteSettings settings) {
    return switchRoutes(settings.name!);
  }

  static pushNamed(String routeName) async {
    switch (routeName) {
      case '/home':
        navigatorKey.currentState!
            .push(MaterialPageRoute(builder: (context) => ChatScreen()));
        break;
      case '/initial':
        navigatorKey.currentState!
            .push(MaterialPageRoute(builder: (context) => InitialDetailPage()));
        break;
    }
  }
}

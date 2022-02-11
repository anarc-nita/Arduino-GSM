import 'package:flutter/material.dart';
import 'package:gsm/data.dart';
import 'package:gsm/home.dart';
import 'package:gsm/settings.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import 'package:telephony/telephony.dart';

onBackgroundMessage(SmsMessage message) {
  debugPrint("onBackgroundMessage called");
}

void main() {
  runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => Info()),
      ],
      child: const MyApp(),
    ),);
}


class MyApp extends StatelessWidget {
  const MyApp({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Home(),
      routes: {
        Settings.routeName: (context) => const Settings(),
      },
    );
  }
}
// class MyApp extends StatefulWidget {
//   @override
//   _MyAppState createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> {
//   String _message = "";
//   final telephony = Telephony.instance;
//   String _address = "";

//   @override
//   void initState() {
//     super.initState();
//     initPlatformState();
//   }

//   onMessage(SmsMessage message) async {
//     setState(() {
//       _message = message.body ?? "Error reading message body.";
//       _address = message.address!;
//     });
//   }

//   onSendStatus(SendStatus status) {
//     setState(() {
//       _message = status == SendStatus.SENT ? "sent" : "delivered";
//     });
//   }

//   Future<void> initPlatformState() async {
//     final bool? result = await telephony.requestPhoneAndSmsPermissions;

//     if (result != null && result) {
//       telephony.listenIncomingSms(
//           onNewMessage: onMessage, onBackgroundMessage: onBackgroundMessage);
//     }

//     if (!mounted) return;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//         home: Scaffold(
//       appBar: AppBar(
//         title: const Text('Plugin example app'),
//       ),
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Center(child: Text("Latest received SMS: $_message")),
//           Center(
//             child: Text(_address),
//           ),
//           TextButton(
//             onPressed: () async {
//               await telephony.openDialer("123413453");
//             },
//             child: Text('Open Dialer'),
//           )
//         ],
//       ),
//     ));
//   }
// }

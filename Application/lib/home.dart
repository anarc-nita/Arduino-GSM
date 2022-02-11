import 'package:flutter/material.dart';
import 'package:gsm/data.dart';
import 'package:gsm/settings.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import 'package:telephony/telephony.dart';

onBackgroundMessage(SmsMessage message) {
  debugPrint("onBackgroundMessage called");
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String _message = "10001";
  final telephony = Telephony.instance;
  String _address = "";
  int channel = 1;
  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  onMessage(SmsMessage message) async {
    if (message.address == _address) {
      setState(() {
        _message = message.body ?? "Error reading message body.";
      });
    }
    setState(() {
      _message = message.body ?? "Error reading message body.";
    });
  }

  onSendStatus(SendStatus status) {
    setState(() {
      _message = status == SendStatus.SENT ? "sent" : "delivered";
    });
  }

  Future<void> initPlatformState() async {
    final bool? result = await telephony.requestPhoneAndSmsPermissions;

    if (result != null && result) {
      telephony.listenIncomingSms(
        onNewMessage: onMessage,
        onBackgroundMessage: onBackgroundMessage,
      );
    }

    if (!mounted) return;
  }

  @override
  Widget build(BuildContext context) {
    final d = Provider.of<Info>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('GSM'),
        actions: [
          Center(child: Text(_message)),
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(Settings.routeName);
            },
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: d.channels,
        itemBuilder: (context, index) {
          if (_message.length == d.channels) {
            return ListTile(
              title: Text('Motor ${index + 1}'),
              trailing:
                  _message[index] == '1' ? const Text('ON') : const Text('OFF'),
            );
          }
          return const Center(
            child: Text('The message length and the channels do not match'),
          );
        },
      ),
    );
  }
}

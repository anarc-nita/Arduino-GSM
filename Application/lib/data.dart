import 'package:flutter/cupertino.dart';

class Info with ChangeNotifier {
  String _address = '';
  int _channels = 0;

  void updateAddress(String number) {
    _address = number;
    notifyListeners();
  }

  void updateChannels(int chan) {
    _channels = chan;
    notifyListeners();
  }

  String get address {
    return _address;
  }

  int get channels {
    debugPrint(_channels.toString());
    return _channels;
  }
}

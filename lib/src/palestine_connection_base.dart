import 'dart:async';
import 'dart:developer' as developer;
import 'dart:io';

import 'package:palestine_connection/palestine_connection.dart';

typedef VoidCallback = void Function();

class PalConnection {
  factory PalConnection() => _singleton;
  PalConnection._internal() {
    developer.log('--PalConnection-- (Instance Created --> Singleton)');
  }
  static final PalConnection _singleton = PalConnection._internal();

  /// Connection check variable
  bool hasConnection = false;

  /// Timer object
  Timer? timer;

  final StreamController _streamController = StreamController();
  bool prevConnectionState = true;

  ///---
  /// initialize package
  ///---
  /// Start periodic process to check connection..
  void initialize({
    String domain = PalDomain.random,
    required int periodicInSeconds,
    required VoidCallback onConnectionLost,
    required VoidCallback onConnectionRestored,
  }) {
    String _domain = domain;

    if (domain == PalDomain.random) {
      _domain = getRandomDomain();
    }

    timer = Timer.periodic(
      Duration(seconds: periodicInSeconds),
      (Timer timer) => periodicCheck(
        domain: _domain,
        onConnectionLost: onConnectionLost,
        onConnectionRestored: onConnectionRestored,
      ),
    );

    _streamController.stream.listen((event) {
      if (event != prevConnectionState) {
        prevConnectionState = event as bool;
        event ? onConnectionRestored() : onConnectionLost();
      }
    });
  }

  /// Stop the process..
  bool dispose() {
    if (timer != null && timer!.isActive) {
      timer!.cancel();
      _streamController.close();

      return true;
    }
    return false;
  }

  ///---
  /// Connection Check
  ///---
  /// Should not be invoked directly
  Future<bool> checkConnection(String domain) async {
    try {
      final List<InternetAddress> result = await InternetAddress.lookup(domain);

      hasConnection = result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      hasConnection = false;
    }

    return hasConnection;
  }

  String getRandomDomain() {
    final List<String> _domainsList = <String>[
      PalDomain.google,
      PalDomain.github,
      PalDomain.yahoo,
      PalDomain.facebook,
      PalDomain.microsoft,
      PalDomain.youtube,
      PalDomain.twitter,
      PalDomain.wikipedia,
      PalDomain.instagram,
    ];

    return (_domainsList..shuffle()).first;
  }

  Future periodicCheck({
    required String domain,
    required VoidCallback onConnectionLost,
    required VoidCallback onConnectionRestored,
  }) async {
    final bool state = await checkConnection(domain);
    _streamController.add(state);
  }
}

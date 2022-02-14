import 'dart:async';
import 'dart:developer' as developer;
import 'dart:io';

import 'package:palestine_connection/palestine_connection.dart';

typedef VoidCallback = void Function();
typedef DomainCallback = void Function(String? domain);

class PalConnection {
  factory PalConnection() => _singleton;
  PalConnection._internal() {
    developer.log('--PalConnection-- (Instance Created --> Singleton)');
  }
  static final PalConnection _singleton = PalConnection._internal();

  /// Timer object
  List<Timer?> timers = [null];

  List<bool> prevConnectionStates = [false];

  ///---
  /// initialize package
  ///---
  /// Start periodic process to check connection..
  Future<void> initialize({
    String domain = PalDomain.random,
    required int periodicInSeconds,
    required VoidCallback onConnectionLost,
    required VoidCallback onConnectionRestored,
  }) async {
    timers = List.generate(
      1,
      (index) => Timer.periodic(
        Duration(seconds: periodicInSeconds),
        (Timer timer) async {
          final bool state = await checkConnection(domain);
          if (state != prevConnectionStates.elementAt(index)) {
            prevConnectionStates[index] = state;
            state ? onConnectionRestored() : onConnectionLost();
          }
        },
      ),
    );
  }

  Future<void> initializeMulti({
    List<String> domains = const [PalDomain.random],
    required int periodicInSeconds,
    required DomainCallback onConnectionLost,
    required DomainCallback onConnectionRestored,
  }) async {
    prevConnectionStates = List.generate(domains.length, (index) => false);
    timers = List.generate(
      domains.length,
      (index) => Timer.periodic(
        Duration(seconds: periodicInSeconds),
        (Timer timer) async {
          final bool state = await checkConnection(domains.elementAt(index));
          if (state != prevConnectionStates.elementAt(index)) {
            prevConnectionStates[index] = state;
            state
                ? onConnectionRestored(domains.elementAt(index))
                : onConnectionLost(domains.elementAt(index));
          }
        },
      ),
    );
  }

  /// Stop the process..
  bool dispose() {
    for (final timer in timers) {
      if (timer != null && timer.isActive) {
        timer.cancel();
      }
    }

    return timers.isNotEmpty;
  }

  ///---
  /// Connection Check
  ///---
  /// Should not be invoked directly
  Future<bool> checkConnection(String domain) async {
    try {
      final String _domain = getDomainOrRandom(domain);

      final List<InternetAddress> result =
          await InternetAddress.lookup(_domain);

      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      developer.log('--PalConnection-- (Error) -> checkConnection');
      return false;
    }
  }

  String getDomainOrRandom(String domain) {
    return domain == PalDomain.random || !isValidDomainName(domain)
        ? getRandomDomain()
        : domain;
  }

  bool isValidDomainName(String domain) {
    return domain.contains('.');
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
}

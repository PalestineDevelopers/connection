import 'package:palestine_connection/palestine_connection.dart';
import 'package:test/test.dart';

void main() {
  group('PalConnection', () {
    const String testInitValues = 'if variables has start type';
    const String testGetRandomDomain = 'if getRandomDomain return String';
    const String testInit = 'if init working and timer assigned';
    const String testCheckConnection = 'if checkConnection is working';
    const String testDispose = 'if dispose is working';

    final PalConnection _connection = PalConnection();
    test(testInitValues, () async {
      expect(_connection.prevConnectionState.runtimeType, bool);
      expect(_connection.prevConnectionState, anyOf([true, false]));
      expect(_connection.timer, null);
    });

    test(testGetRandomDomain, () {
      expect(_connection.getRandomDomain().runtimeType, String);
    });

    test(testInit, () async {
      await _connection.initialize(
        periodicInSeconds: 3,
        onConnectionLost: () {},
        onConnectionRestored: () {},
      );

      expect(_connection.timer, isNot(null));
      expect(_connection.timer!.isActive, true);

      expect(_connection.prevConnectionState, anyOf([true, false]));

      // waits for timer to complete
      await Future.delayed(const Duration(seconds: 3 * 3), () {});
    });

    test(testCheckConnection, () async {
      expect(
        _connection.getDomainOrRandom(PalDomain.google).runtimeType,
        String,
      );
      expect(
        await _connection.checkConnection(PalDomain.google),
        anyOf([true, false]),
      );
      expect(
        await _connection.checkConnection(''),
        anyOf([true, false]),
      );
      expect(
        await _connection.checkConnection('4'),
        anyOf([true, false]),
      );
      expect(
        await _connection.checkConnection('4.y'),
        anyOf([true, false]),
      );
    });

    test(testDispose, () async {
      // TODO : Change to true
      expect(_connection.dispose(), true);
    });
  });
}

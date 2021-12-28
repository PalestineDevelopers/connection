import 'package:palestine_connection/palestine_connection.dart';
import 'package:test/test.dart';

void main() {
  group('PalConnection', () {
    test('connection process', () async {
      final PalConnection _connection = PalConnection();

      expect(_connection.hasConnection, false);
      _connection.hasConnection = true;
      expect(_connection.hasConnection, true);
      _connection.hasConnection = false;
      expect(_connection.hasConnection, false);

      expect(_connection.timer, null);
      expect(_connection.dispose(), false);

      expect(_connection.getRandomDomain(), const TypeMatcher('String'));

      _connection.initialize(
        periodicInSeconds: 3,
        onConnectionLost: () {},
        onConnectionRestored: () {},
      );

      expect(
        _connection.prevConnectionState,
        anyOf([true, false]),
      );

      expect(_connection.timer, isNot(null));

      expect(_connection.timer!.isActive, true);

      expect(
        await _connection.checkConnection(PalDomain.random),
        anyOf([true, false]),
      );

      expect(
        _connection.hasConnection,
        anyOf([true, false]),
      );

      expect(
        await _connection.periodicCheck(
          domain: PalDomain.google,
          onConnectionLost: () {},
          onConnectionRestored: () {},
        ),
        null,
      );

      expect(
        _connection.prevConnectionState,
        anyOf([true, false]),
      );

      expect(_connection.dispose(), true);
    });
  });
}

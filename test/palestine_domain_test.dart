import 'package:palestine_connection/palestine_connection.dart';
import 'package:test/test.dart';

void main() {
  group('PalDomain', () {
    test('connection process', () async {
      expect(PalDomain.random, 'random');
      expect(PalDomain.google, 'google.com');
      expect(PalDomain.github, 'github.com');
    });
  });
}

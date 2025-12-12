import 'package:flutter_project/providers/auth_provider.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AuthProvider Logic', () {
    test('Initial state should be logged out', () {
      final provider = AuthProvider();
      expect(provider.isAuthenticated, false);
      expect(provider.user, null);
    });
  });
}

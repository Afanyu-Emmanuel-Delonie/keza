import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/repositories/auth_repository.dart';

class InMemoryAuthRepository implements AuthRepository {
  static const _keyAuth = 'keza_is_authenticated';
  static const _keyOnboarding = 'keza_onboarding_seen';
  static const _keyName = 'keza_user_name';
  static const _keyEmail = 'keza_user_email';

  bool _isAuthenticated = false;
  bool _hasSeenOnboarding = false;
  String _name = '';
  String _email = '';

  // Call this once at startup to hydrate from prefs
  static Future<InMemoryAuthRepository> create() async {
    final repo = InMemoryAuthRepository();
    final prefs = await SharedPreferences.getInstance();
    repo._isAuthenticated = prefs.getBool(_keyAuth) ?? false;
    repo._hasSeenOnboarding = prefs.getBool(_keyOnboarding) ?? false;
    repo._name = prefs.getString(_keyName) ?? '';
    repo._email = prefs.getString(_keyEmail) ?? '';
    return repo;
  }

  @override
  bool get isAuthenticated => _isAuthenticated;

  @override
  bool get hasSeenOnboarding => _hasSeenOnboarding;

  @override
  String get currentName => _name;

  @override
  String get currentEmail => _email;

  @override
  Future<void> loginWithEmail(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 800));
    _isAuthenticated = true;
    _email = email;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyAuth, true);
    await prefs.setString(_keyEmail, email);
  }

  @override
  Future<void> registerWithEmail(String name, String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 900));
    _isAuthenticated = true;
    _name = name;
    _email = email;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyAuth, true);
    await prefs.setString(_keyName, name);
    await prefs.setString(_keyEmail, email);
  }

  @override
  Future<void> loginWithGoogle() async {
    await Future.delayed(const Duration(milliseconds: 700));
    _isAuthenticated = true;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyAuth, true);
  }

  @override
  Future<void> loginWithFacebook() async {
    await Future.delayed(const Duration(milliseconds: 700));
    _isAuthenticated = true;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyAuth, true);
  }

  @override
  Future<void> loginWithApple() async {
    await Future.delayed(const Duration(milliseconds: 700));
    _isAuthenticated = true;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyAuth, true);
  }

  @override
  Future<void> forgotPassword(String email) async {
    await Future.delayed(const Duration(milliseconds: 600));
  }

  @override
  Future<void> logout() async {
    _isAuthenticated = false;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyAuth, false);
  }

  @override
  Future<void> markOnboardingSeen() async {
    _hasSeenOnboarding = true;
    _isAuthenticated = true;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyOnboarding, true);
    await prefs.setBool(_keyAuth, true);
  }

  @override
  Future<void> resetOnboarding() async {
    _hasSeenOnboarding = false;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyOnboarding, false);
  }
}

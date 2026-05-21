import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/repositories/auth_repository.dart';

class InMemoryAuthRepository implements AuthRepository {
  static const _keyAuth = 'keza_is_authenticated';
  static const _keyOnboarding = 'keza_onboarding_seen';

  bool _isAuthenticated = false;
  bool _hasSeenOnboarding = false;

  // Call this once at startup to hydrate from prefs
  static Future<InMemoryAuthRepository> create() async {
    final repo = InMemoryAuthRepository();
    final prefs = await SharedPreferences.getInstance();
    repo._isAuthenticated = prefs.getBool(_keyAuth) ?? false;
    repo._hasSeenOnboarding = prefs.getBool(_keyOnboarding) ?? false;
    return repo;
  }

  @override
  bool get isAuthenticated => _isAuthenticated;

  @override
  bool get hasSeenOnboarding => _hasSeenOnboarding;

  @override
  Future<void> loginWithEmail(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 800));
    _isAuthenticated = true;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyAuth, true);
  }

  @override
  Future<void> registerWithEmail(String name, String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 900));
    _isAuthenticated = true;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyAuth, true);
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

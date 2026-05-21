import 'package:flutter/material.dart';
import '../domain/repositories/auth_repository.dart';

enum AuthStatus { idle, loading, success, error }

class AuthProvider extends ChangeNotifier {
  final AuthRepository _repository;

  AuthProvider({required AuthRepository repository}) : _repository = repository;

  bool get isAuthenticated => _repository.isAuthenticated;
  bool get hasSeenOnboarding => _repository.hasSeenOnboarding;

  AuthStatus _status = AuthStatus.idle;
  String? _error;

  AuthStatus get status => _status;
  String? get error => _error;
  bool get isLoading => _status == AuthStatus.loading;

  void _setLoading() {
    _status = AuthStatus.loading;
    _error = null;
    notifyListeners();
  }

  void _setError(String msg) {
    _status = AuthStatus.error;
    _error = msg;
    notifyListeners();
  }

  void _setSuccess() {
    _status = AuthStatus.success;
    _error = null;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    _status = AuthStatus.idle;
    notifyListeners();
  }

  Future<bool> loginWithEmail(String email, String password) async {
    _setLoading();
    try {
      await _repository.loginWithEmail(email, password);
      _setSuccess();
      return true;
    } catch (e) {
      _setError('Invalid email or password. Please try again.');
      return false;
    }
  }

  Future<bool> registerWithEmail(String name, String email, String password) async {
    _setLoading();
    try {
      await _repository.registerWithEmail(name, email, password);
      _setSuccess();
      return true;
    } catch (e) {
      _setError('Registration failed. Please try again.');
      return false;
    }
  }

  Future<bool> loginWithGoogle() async {
    _setLoading();
    try {
      await _repository.loginWithGoogle();
      _setSuccess();
      return true;
    } catch (e) {
      _setError('Google sign-in failed.');
      return false;
    }
  }

  Future<bool> loginWithFacebook() async {
    _setLoading();
    try {
      await _repository.loginWithFacebook();
      _setSuccess();
      return true;
    } catch (e) {
      _setError('Facebook sign-in failed.');
      return false;
    }
  }

  Future<bool> loginWithApple() async {
    _setLoading();
    try {
      await _repository.loginWithApple();
      _setSuccess();
      return true;
    } catch (e) {
      _setError('Apple sign-in failed.');
      return false;
    }
  }

  Future<bool> forgotPassword(String email) async {
    _setLoading();
    try {
      await _repository.forgotPassword(email);
      _setSuccess();
      return true;
    } catch (e) {
      _setError('Could not send reset email. Please try again.');
      return false;
    }
  }

  Future<void> logout() async {
    await _repository.logout();
    _status = AuthStatus.idle;
    notifyListeners();
  }

  Future<void> markOnboardingSeen() async {
    await _repository.markOnboardingSeen();
    notifyListeners();
  }

  Future<void> resetOnboarding() async {
    await _repository.resetOnboarding();
    notifyListeners();
  }
}

abstract class AuthRepository {
  bool get isAuthenticated;
  bool get hasSeenOnboarding;

  Future<void> loginWithEmail(String email, String password);
  Future<void> registerWithEmail(String name, String email, String password);
  Future<void> loginWithGoogle();
  Future<void> loginWithFacebook();
  Future<void> loginWithApple();
  Future<void> forgotPassword(String email);
  Future<void> logout();
  Future<void> markOnboardingSeen();
  Future<void> resetOnboarding(); // dev only
}

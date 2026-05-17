import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import '../../features/auth/providers/auth_provider.dart';

/// Centralized list of providers for the entire application.
List<SingleChildWidget> getProviders() {
  return [
    ChangeNotifierProvider(create: (_) => AuthProvider()),
    // Add more providers here as you develop new features
  ];
}

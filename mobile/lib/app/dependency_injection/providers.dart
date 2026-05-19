import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import '../../features/auth/providers/auth_provider.dart';
import '../../features/trips/providers/trips_provider.dart';

/// Centralized list of providers for the entire application.
List<SingleChildWidget> getProviders() {
  return [
    ChangeNotifierProvider(create: (_) => AuthProvider()),
    ChangeNotifierProvider(create: (_) => TripsProvider()),
  ];
}

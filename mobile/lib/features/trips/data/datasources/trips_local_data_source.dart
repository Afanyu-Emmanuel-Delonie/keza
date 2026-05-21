import '../../../../core/constants/app_seed_data.dart';
import '../../domain/entities/trip_entities.dart';

class TripsLocalDataSource {
  const TripsLocalDataSource();

  List<TripItem> initialFavourites() => [];
  List<TripItem> initialAddedTrips() => [];
  List<BookedTrip> initialBookedTrips() => List.of(AppSeedData.bookedTrips);
  List<TripGroup> initialGroups() => List.of(AppSeedData.tripGroups);
  Map<String, List<TourGuide>> tourGuidesByProvince() =>
      Map.of(AppSeedData.tourGuidesByProvince);
}

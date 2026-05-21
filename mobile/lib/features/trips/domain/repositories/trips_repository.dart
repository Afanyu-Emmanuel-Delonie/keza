import '../entities/trip_entities.dart';

abstract class TripsRepository {
  bool isAccommodationLiked(String id);
  bool isAccommodationSelected(String id);
  AccommodationBooking? bookingForProvince(String province);
  TripItem? selectedAccommodationForProvince(String province);

  Map<String, AccommodationBooking> get allBookings;
  Map<String, GuideBooking> get allGuideBookings;
  List<TripItem> get favourites;
  List<TripItem> get addedTrips;
  List<BookedTrip> get bookedTrips;
  List<TripGroup> get myGroups;
  TripGroup? get activeGroup;
  Set<String> get selectedIds;
  List<TripItem> get selectedTrips;
  Map<String, List<TourGuide>> get tourGuidesByProvince;
  TripPlanningProfile get tripProfile;
  TripPlanType get selectedPlanType;
  List<TripPlanOption> get planOptions;
  TripPlanOption? get selectedPlan;

  bool isFavourite(String id);
  bool isAdded(String id);
  bool isSelected(String id);
  bool isInTrip(String name);

  void toggleLikeAccommodation(TripItem item);
  void confirmAccommodationBooking(AccommodationBooking booking);
  void cancelAccommodationBooking(String province);
  void confirmGuideBooking(GuideBooking booking);
  void cancelGuideBooking(String province);
  void markGuideConfirmed(String province);
  void addBookedTrip(BookedTrip trip);
  void toggleSelectAccommodation(TripItem item);
  void toggleSelected(String id);
  void toggleFavourite(TripItem item);
  void toggleAddTrip(TripItem item);
  void removeFromTrip(String id);
  void setActiveGroup(TripGroup? group);
  void createGroup(String name);
  void updateTripProfile(TripPlanningProfile profile);
  void selectPlanType(TripPlanType type);

  Map<String, List<TripItem>> get tripsByProvince;
  double get selectedTripCost;
  double get totalAccommodationCost;
  double get totalGuideCost;
  double get totalTripCost;
  double get serviceFee;
  double get grandTotal;
  TripReadiness get tripReadiness;
}

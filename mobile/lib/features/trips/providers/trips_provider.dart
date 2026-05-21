import 'package:flutter/material.dart';

import '../domain/entities/trip_entities.dart';
import '../domain/repositories/trips_repository.dart';

export '../domain/entities/trip_entities.dart';

class TripsProvider extends ChangeNotifier {
  final TripsRepository _repository;

  TripsProvider({required TripsRepository repository}) : _repository = repository;

  bool isAccommodationLiked(String id) => _repository.isAccommodationLiked(id);
  bool isAccommodationSelected(String id) => _repository.isAccommodationSelected(id);
  AccommodationBooking? bookingForProvince(String province) =>
      _repository.bookingForProvince(province);
  TripItem? selectedAccommodationForProvince(String province) =>
      _repository.selectedAccommodationForProvince(province);

  Map<String, AccommodationBooking> get allBookings => _repository.allBookings;
  Map<String, GuideBooking> get allGuideBookings => _repository.allGuideBookings;
  List<TripItem> get favourites => _repository.favourites;
  List<TripItem> get addedTrips => _repository.addedTrips;
  List<BookedTrip> get bookedTrips => _repository.bookedTrips;
  List<TripGroup> get myGroups => _repository.myGroups;
  TripGroup? get activeGroup => _repository.activeGroup;
  Set<String> get selectedIds => _repository.selectedIds;
  List<TripItem> get selectedTrips => _repository.selectedTrips;
  Map<String, List<TourGuide>> get tourGuidesByProvince => _repository.tourGuidesByProvince;
  TripPlanningProfile get tripProfile => _repository.tripProfile;
  TripPlanType get selectedPlanType => _repository.selectedPlanType;
  List<TripPlanOption> get planOptions => _repository.planOptions;
  TripPlanOption? get selectedPlan => _repository.selectedPlan;

  bool isFavourite(String id) => _repository.isFavourite(id);
  bool isAdded(String id) => _repository.isAdded(id);
  bool isSelected(String id) => _repository.isSelected(id);
  bool isInTrip(String name) => _repository.isInTrip(name);

  void toggleLikeAccommodation(TripItem item) {
    _repository.toggleLikeAccommodation(item);
    notifyListeners();
  }

  void confirmAccommodationBooking(AccommodationBooking booking) {
    _repository.confirmAccommodationBooking(booking);
    notifyListeners();
  }

  void cancelAccommodationBooking(String province) {
    _repository.cancelAccommodationBooking(province);
    notifyListeners();
  }

  void confirmGuideBooking(GuideBooking booking) {
    _repository.confirmGuideBooking(booking);
    notifyListeners();
  }

  void cancelGuideBooking(String province) {
    _repository.cancelGuideBooking(province);
    notifyListeners();
  }

  void markGuideConfirmed(String province) {
    _repository.markGuideConfirmed(province);
    notifyListeners();
  }

  void addBookedTrip(BookedTrip trip) {
    _repository.addBookedTrip(trip);
    notifyListeners();
  }

  void toggleSelectAccommodation(TripItem item) {
    _repository.toggleSelectAccommodation(item);
    notifyListeners();
  }

  void toggleSelected(String id) {
    _repository.toggleSelected(id);
    notifyListeners();
  }

  void toggleFavourite(TripItem item) {
    _repository.toggleFavourite(item);
    notifyListeners();
  }

  void toggleAddTrip(TripItem item) {
    _repository.toggleAddTrip(item);
    notifyListeners();
  }

  void removeFromTrip(String id) {
    _repository.removeFromTrip(id);
    notifyListeners();
  }

  void setActiveGroup(TripGroup? group) {
    _repository.setActiveGroup(group);
    notifyListeners();
  }

  void createGroup(String name) {
    _repository.createGroup(name);
    notifyListeners();
  }

  void updateTripProfile(TripPlanningProfile profile) {
    _repository.updateTripProfile(profile);
    notifyListeners();
  }

  void selectPlanType(TripPlanType type) {
    _repository.selectPlanType(type);
    notifyListeners();
  }

  Map<String, List<TripItem>> get tripsByProvince => _repository.tripsByProvince;
  double get selectedTripCost => _repository.selectedTripCost;
  double get totalAccommodationCost => _repository.totalAccommodationCost;
  double get totalGuideCost => _repository.totalGuideCost;
  double get totalTripCost => _repository.totalTripCost;
  double get serviceFee => _repository.serviceFee;
  double get grandTotal => _repository.grandTotal;
  TripReadiness get tripReadiness => _repository.tripReadiness;
}

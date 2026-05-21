import 'dart:math';

import '../../domain/entities/trip_entities.dart';
import '../../domain/repositories/trips_repository.dart';
import '../datasources/trips_local_data_source.dart';

class InMemoryTripsRepository implements TripsRepository {
  final Set<String> _likedAccommodationIds = {};
  final Map<String, AccommodationBooking> _bookings = {};
  final Map<String, GuideBooking> _guideBookings = {};
  final List<TripItem> _favourites;
  final List<TripItem> _addedTrips;
  final List<TripGroup> _myGroups;
  final List<BookedTrip> _bookedTrips;
  TripGroup? _activeGroup;
  final Set<String> _selectedIds = {};
  final Map<String, List<TourGuide>> _tourGuidesByProvince;
  TripPlanningProfile _tripProfile = const TripPlanningProfile.defaults();
  TripPlanType _selectedPlanType = TripPlanType.balanced;

  InMemoryTripsRepository({TripsLocalDataSource? dataSource})
      : _favourites = List<TripItem>.of((dataSource ?? const TripsLocalDataSource()).initialFavourites()),
        _addedTrips = List<TripItem>.of((dataSource ?? const TripsLocalDataSource()).initialAddedTrips()),
        _myGroups = List<TripGroup>.of((dataSource ?? const TripsLocalDataSource()).initialGroups()),
        _bookedTrips = List<BookedTrip>.of((dataSource ?? const TripsLocalDataSource()).initialBookedTrips()),
        _tourGuidesByProvince =
            Map<String, List<TourGuide>>.from((dataSource ?? const TripsLocalDataSource()).tourGuidesByProvince());

  List<TripItem> get _planningTrips => _selectedIds.isNotEmpty
      ? _addedTrips.where((trip) => _selectedIds.contains(trip.id)).toList()
      : List<TripItem>.of(_addedTrips);

  double _parseMoney(String value) {
    final raw = value.replaceAll(RegExp(r'[^0-9.]'), '');
    return double.tryParse(raw) ?? 0.0;
  }

  String _provinceLabel(String province) {
    switch (province) {
      case 'Kigali City':
        return 'Kigali welcome';
      case 'Northern Province':
        return 'Northern adventure';
      case 'Western Province':
        return 'Western escape';
      case 'Eastern Province':
        return 'Eastern safari';
      case 'Southern Province':
        return 'Southern culture';
      default:
        return province;
    }
  }

  double _stayRate(TripStayStyle stayStyle, TripPlanType type) {
    final base = switch (stayStyle) {
      TripStayStyle.recommended => 70.0,
      TripStayStyle.ownStay => 35.0,
      TripStayStyle.premium => 140.0,
    };
    final planMultiplier = switch (type) {
      TripPlanType.value => 0.85,
      TripPlanType.balanced => 1.0,
      TripPlanType.premium => 1.35,
    };
    return base * planMultiplier;
  }

  double _transportRate(TripTransportStyle style, TripPlanType type) {
    final base = switch (style) {
      TripTransportStyle.sharedVehicle => 55.0,
      TripTransportStyle.selfDrive => 40.0,
      TripTransportStyle.airportPickup => 95.0,
    };
    final planMultiplier = switch (type) {
      TripPlanType.value => 0.9,
      TripPlanType.balanced => 1.0,
      TripPlanType.premium => 1.2,
    };
    return base * planMultiplier;
  }

  double _guideRate(TripPlanType type) {
    return switch (type) {
      TripPlanType.value => 25.0,
      TripPlanType.balanced => 45.0,
      TripPlanType.premium => 75.0,
    };
  }

  List<List<TripItem>> _splitTrips(List<TripItem> trips, int days) {
    if (days <= 0) return const [];
    if (trips.isEmpty) {
      return List<List<TripItem>>.generate(days, (_) => <TripItem>[]);
    }

    final result = List<List<TripItem>>.generate(days, (_) => <TripItem>[]);
    final baseCount = trips.length ~/ days;
    final remainder = trips.length % days;
    var index = 0;

    for (var day = 0; day < days; day++) {
      final take = baseCount + (day < remainder ? 1 : 0);
      if (take <= 0) continue;
      final end = min(index + take, trips.length);
      result[day] = trips.sublist(index, end);
      index = end;
    }

    if (index < trips.length && result.isNotEmpty) {
      result[days - 1] = [...result[days - 1], ...trips.sublist(index)];
    }

    return result;
  }

  List<TripDayPlan> _buildDayPlans({
    required List<TripItem> trips,
    required TripPlanningProfile profile,
    required TripPlanType type,
  }) {
    final slices = _splitTrips(trips, profile.days);
    final peopleFactor = max(1, (profile.people / 2).ceil());
    final dayPlans = <TripDayPlan>[];

    for (var i = 0; i < slices.length; i++) {
      final stops = slices[i];
      final dayNumber = i + 1;
      final province = stops.isNotEmpty ? stops.first.province : 'Rwanda';
      final dayTripCost = stops.fold<double>(0.0, (sum, trip) => sum + _parseMoney(trip.price));
      final stayCost = stops.isEmpty ? 0.0 : _stayRate(profile.stayStyle, type);
      final transportCost = _transportRate(profile.transportStyle, type) * peopleFactor;
      final guideCost = _guideRate(type) * (profile.pace == TripPace.adventurous ? 1.1 : 1.0);
      final dayCost = (dayTripCost + stayCost + transportCost + guideCost) * switch (type) {
        TripPlanType.value => 0.95,
        TripPlanType.balanced => 1.0,
        TripPlanType.premium => 1.15,
      };

      final title = stops.isEmpty
          ? 'Day $dayNumber: Slow travel and local discovery'
          : 'Day $dayNumber: ${_provinceLabel(province)}';

      final summary = stops.isEmpty
          ? 'Keep the pace light with a relaxed morning, local lunch, and open time for spontaneous stops.'
          : 'Visit ${stops.length} place${stops.length == 1 ? '' : 's'} with a ${profile.pace.name} pace and enough space to enjoy each stop.';

      final stayNote = switch (profile.stayStyle) {
        TripStayStyle.recommended => 'Recommended stay close to the day route.',
        TripStayStyle.ownStay => 'You can keep your own stay and just book the day route.',
        TripStayStyle.premium => 'Premium stay selected for extra comfort and shorter transfers.',
      };

      dayPlans.add(
        TripDayPlan(
          dayNumber: dayNumber,
          title: title,
          province: province,
          summary: summary,
          stops: stops,
          stayNote: stayNote,
          estimatedCost: dayCost,
        ),
      );
    }

    return dayPlans;
  }

  List<TripPlanOption> _buildPlanOptions() {
    final trips = _planningTrips;
    if (trips.isEmpty) return const [];

    final tripSpend = trips.fold<double>(0.0, (sum, trip) => sum + _parseMoney(trip.price));
    final configs = <TripPlanType, ({String name, String description, String fitNote, String transportNote, String stayNote, double multiplier})>{
      TripPlanType.value: (
        name: 'Value Explorer',
        description: 'Best for keeping the trip light, efficient, and budget-friendly.',
        fitNote: 'Great when you want the most important stops without unnecessary extras.',
        transportNote: 'Shared movement with simple transfers and fewer premium add-ons.',
        stayNote: 'Comfortable recommended stays or your own accommodation.',
        multiplier: 0.92,
      ),
      TripPlanType.balanced: (
        name: 'Balanced Journey',
        description: 'A flexible mix of sightseeing, comfort, and smooth pacing.',
        fitNote: 'A good middle ground for most travellers and mixed budgets.',
        transportNote: 'Comfortable routing with enough flexibility for your selected pace.',
        stayNote: 'Recommended accommodation with room for upgrades where needed.',
        multiplier: 1.0,
      ),
      TripPlanType.premium: (
        name: 'Signature Escape',
        description: 'More comfort, smoother transfers, and a premium feel throughout.',
        fitNote: 'Best when comfort matters as much as the experience itself.',
        transportNote: 'Private-style routing with higher-end transfers and support.',
        stayNote: 'Premium stays with more relaxed timing and stronger service levels.',
        multiplier: 1.22,
      ),
    };

    return configs.entries.map((entry) {
      final type = entry.key;
      final config = entry.value;
      final days = _buildDayPlans(trips: trips, profile: _tripProfile, type: type);
      final peopleFactor = max(1, (_tripProfile.people / 2).ceil());
      final stayCost = _stayRate(_tripProfile.stayStyle, type) * max(1, _tripProfile.days);
      final transportCost = _transportRate(_tripProfile.transportStyle, type) * peopleFactor * max(1, _tripProfile.days);
      final guideCost = _guideRate(type) * max(1, _tripProfile.days);
      final estimatedCost = (tripSpend + stayCost + transportCost + guideCost) * config.multiplier;
      final withinBudget = estimatedCost <= _tripProfile.budget;
      final budgetGap = estimatedCost - _tripProfile.budget;
      final fitNote = withinBudget
          ? '${config.fitNote} You are about \$${(_tripProfile.budget - estimatedCost).abs().toStringAsFixed(0)} under budget.'
          : 'This option is about \$${budgetGap.toStringAsFixed(0)} over budget.';

      return TripPlanOption(
        type: type,
        name: config.name,
        description: config.description,
        fitNote: fitNote,
        transportNote: config.transportNote,
        stayNote: config.stayNote,
        estimatedCost: estimatedCost,
        withinBudget: withinBudget,
        days: days,
      );
    }).toList();
  }

  @override
  bool isAccommodationLiked(String id) => _likedAccommodationIds.contains(id);

  @override
  bool isAccommodationSelected(String id) => _bookings.values.any((booking) => booking.item.id == id);

  @override
  AccommodationBooking? bookingForProvince(String province) => _bookings[province];

  @override
  TripItem? selectedAccommodationForProvince(String province) => _bookings[province]?.item;

  @override
  Map<String, AccommodationBooking> get allBookings => Map.unmodifiable(_bookings);

  @override
  Map<String, GuideBooking> get allGuideBookings => Map.unmodifiable(_guideBookings);

  @override
  List<TripItem> get favourites => List.unmodifiable(_favourites);

  @override
  List<TripItem> get addedTrips => List.unmodifiable(_addedTrips);

  @override
  List<BookedTrip> get bookedTrips => List.unmodifiable(_bookedTrips);

  @override
  List<TripGroup> get myGroups => List.unmodifiable(_myGroups);

  @override
  TripGroup? get activeGroup => _activeGroup;

  @override
  Set<String> get selectedIds => Set.unmodifiable(_selectedIds);

  @override
  List<TripItem> get selectedTrips => _addedTrips.where((trip) => _selectedIds.contains(trip.id)).toList();

  @override
  Map<String, List<TourGuide>> get tourGuidesByProvince =>
      Map.unmodifiable(_tourGuidesByProvince.map((key, value) => MapEntry(key, List<TourGuide>.unmodifiable(value))));

  @override
  TripPlanningProfile get tripProfile => _tripProfile;

  @override
  TripPlanType get selectedPlanType => _selectedPlanType;

  @override
  List<TripPlanOption> get planOptions => _buildPlanOptions();

  @override
  TripPlanOption? get selectedPlan {
    final options = planOptions;
    if (options.isEmpty) return null;
    return options.firstWhere(
      (option) => option.type == _selectedPlanType,
      orElse: () => options.first,
    );
  }

  @override
  bool isFavourite(String id) => _favourites.any((item) => item.id == id);

  @override
  bool isAdded(String id) => _addedTrips.any((item) => item.id == id);

  @override
  bool isSelected(String id) => _selectedIds.contains(id);

  @override
  bool isInTrip(String name) => _addedTrips.any((trip) => trip.name == name);

  @override
  void toggleLikeAccommodation(TripItem item) {
    if (_likedAccommodationIds.contains(item.id)) {
      _likedAccommodationIds.remove(item.id);
      _favourites.removeWhere((f) => f.id == item.id);
    } else {
      _likedAccommodationIds.add(item.id);
      if (!_favourites.any((f) => f.id == item.id)) {
        _favourites.add(item);
      }
    }
  }

  @override
  void confirmAccommodationBooking(AccommodationBooking booking) {
    _bookings[booking.item.province] = booking;
  }

  @override
  void cancelAccommodationBooking(String province) {
    _bookings.remove(province);
  }

  @override
  void confirmGuideBooking(GuideBooking booking) {
    _guideBookings[booking.guide.province] = booking;
  }

  @override
  void cancelGuideBooking(String province) {
    _guideBookings.remove(province);
  }

  @override
  void markGuideConfirmed(String province) {
    final booking = _guideBookings[province];
    if (booking != null) {
      _guideBookings[province] = booking.copyWith(status: GuideBookingStatus.confirmed);
    }
  }

  @override
  void addBookedTrip(BookedTrip trip) {
    _bookedTrips.add(trip);
  }

  @override
  void toggleSelectAccommodation(TripItem item) {
    final existing = _bookings[item.province];
    if (existing?.item.id == item.id) {
      _bookings.remove(item.province);
    } else {
      _bookings.remove(item.province);
    }
  }

  @override
  void toggleSelected(String id) {
    if (_selectedIds.contains(id)) {
      _selectedIds.remove(id);
    } else {
      _selectedIds.add(id);
    }
  }

  @override
  void toggleFavourite(TripItem item) {
    final index = _favourites.indexWhere((favourite) => favourite.id == item.id);
    if (index >= 0) {
      _favourites.removeAt(index);
    } else {
      _favourites.add(item);
    }
  }

  @override
  void toggleAddTrip(TripItem item) {
    final index = _addedTrips.indexWhere((trip) => trip.id == item.id);
    if (index >= 0) {
      _addedTrips.removeAt(index);
      _selectedIds.remove(item.id);
    } else {
      _addedTrips.add(item);
    }
  }

  @override
  void removeFromTrip(String id) {
    _addedTrips.removeWhere((trip) => trip.id == id);
    _selectedIds.remove(id);
  }

  @override
  void setActiveGroup(TripGroup? group) {
    _activeGroup = group;
  }

  @override
  void createGroup(String name) {
    final group = TripGroup(
      id: 'g${_myGroups.length + 1}',
      name: name,
      memberCount: 1,
    );
    _myGroups.add(group);
    _activeGroup = group;
  }

  @override
  void updateTripProfile(TripPlanningProfile profile) {
    _tripProfile = profile;
  }

  @override
  void selectPlanType(TripPlanType type) {
    _selectedPlanType = type;
  }

  @override
  Map<String, List<TripItem>> get tripsByProvince {
    final map = <String, List<TripItem>>{};
    for (final trip in _planningTrips) {
      map.putIfAbsent(trip.province, () => []).add(trip);
    }
    return map;
  }

  @override
  double get selectedTripCost {
    return _planningTrips.fold(0.0, (sum, trip) => sum + _parseMoney(trip.price));
  }

  @override
  double get totalAccommodationCost => _bookings.values.fold(0.0, (sum, booking) => sum + booking.totalCost);

  @override
  double get totalGuideCost => _guideBookings.values.fold(0.0, (sum, booking) => sum + booking.totalCost);

  @override
  double get totalTripCost => selectedTripCost;

  @override
  double get serviceFee => (totalAccommodationCost + totalTripCost + totalGuideCost) * 0.05;

  @override
  double get grandTotal => totalAccommodationCost + totalTripCost + totalGuideCost + serviceFee;

  @override
  TripReadiness get tripReadiness {
    if (_bookings.isEmpty && _guideBookings.isEmpty) return TripReadiness.incomplete;
    final hasAwaitingGuide = _guideBookings.values.any(
      (booking) => booking.guide.needsManualConfirmation && booking.status == GuideBookingStatus.pending,
    );
    if (hasAwaitingGuide) return TripReadiness.awaitingConfirmation;
    return TripReadiness.ready;
  }
}

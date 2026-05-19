import 'package:flutter/material.dart';

class TripItem {
  final String id;
  final String name;
  final String location;
  final String province;
  final String image;
  final String price;
  final String rating;
  final bool isAccommodation;

  const TripItem({
    required this.id,
    required this.name,
    required this.location,
    required this.province,
    required this.image,
    required this.price,
    required this.rating,
    this.isAccommodation = false,
  });
}

class BookedTrip {
  final String id;
  final String name;
  final String location;
  final String image;
  final String price;
  final String bookingDate;
  final String travelDate;
  final BookingStatus status;

  const BookedTrip({
    required this.id,
    required this.name,
    required this.location,
    required this.image,
    required this.price,
    required this.bookingDate,
    required this.travelDate,
    required this.status,
  });
}

class TripGroup {
  final String id;
  final String name;
  final int memberCount;

  const TripGroup({required this.id, required this.name, required this.memberCount});
}

enum BookingStatus { pending, confirmed, completed }

class TripsProvider extends ChangeNotifier {
  // ── Favourites ──────────────────────────────────────────────
  final List<TripItem> _favourites = [
    const TripItem(
      id: 'fav_2',
      name: 'Luxury Green Villa',
      location: 'Musanze, Rwanda',
      province: 'Northern Province',
      image: 'https://images.unsplash.com/photo-1566073771259-6a8506099945?q=80&w=400&fit=crop',
      price: '\$120.00',
      rating: '4.8',
      isAccommodation: true,
    ),
    const TripItem(
      id: 'fav_4',
      name: 'Nyandungu Eco-Park',
      location: 'Kigali',
      province: 'Kigali City',
      image: 'https://images.unsplash.com/photo-1501785888041-af3ef285b470?q=80&w=400&fit=crop',
      price: '\$10.00',
      rating: '4.5',
    ),
  ];

  // ── Added to trip ────────────────────────────────────────────
  final List<TripItem> _addedTrips = [
    const TripItem(
      id: 'trip_1',
      name: 'Volcanoes National Park',
      location: 'Musanze',
      province: 'Northern Province',
      image: 'https://images.unsplash.com/photo-1462331940025-496dfbfc7564?q=80&w=400&fit=crop',
      price: '\$1500.00',
      rating: '5.0',
    ),
    const TripItem(
      id: 'trip_2',
      name: 'Twin Lakes',
      location: 'Burera & Ruhondo',
      province: 'Northern Province',
      image: 'https://images.unsplash.com/photo-1501785888041-af3ef285b470?q=80&w=400&fit=crop',
      price: '\$20.00',
      rating: '4.7',
    ),
    const TripItem(
      id: 'trip_3',
      name: 'Akagera National Park',
      location: 'Kayonza',
      province: 'Eastern Province',
      image: 'https://images.unsplash.com/photo-1547407139-3c921a66005c?q=80&w=400&fit=crop',
      price: '\$50.00',
      rating: '4.8',
    ),
  ];

  // ── Selected (accepted) trip IDs — empty by default ──
  final Set<String> _selectedIds = {};

  // ── Group booking ────────────────────────────────────────────
  final List<TripGroup> _myGroups = [
    const TripGroup(id: 'g1', name: 'Rwanda Adventure Crew', memberCount: 4),
    const TripGroup(id: 'g2', name: 'Family Trip 2025', memberCount: 6),
  ];
  TripGroup? _activeGroup;

  // ── Booked trips ─────────────────────────────────────────────
  final List<BookedTrip> _bookedTrips = [
    const BookedTrip(
      id: 'book_1',
      name: 'Kigali Genocide Memorial',
      location: 'Gisozi, Kigali',
      image: 'https://images.unsplash.com/photo-1579208575657-c595a05383b7?q=80&w=400&fit=crop',
      price: 'Free',
      bookingDate: 'Jan 10, 2025',
      travelDate: 'Feb 14, 2025',
      status: BookingStatus.confirmed,
    ),
    const BookedTrip(
      id: 'book_2',
      name: 'Lake Kivu Boat Tour',
      location: 'Rubavu',
      image: 'https://images.unsplash.com/photo-1501785888041-af3ef285b470?q=80&w=400&fit=crop',
      price: '\$35.00',
      bookingDate: 'Jan 15, 2025',
      travelDate: 'Mar 01, 2025',
      status: BookingStatus.pending,
    ),
    const BookedTrip(
      id: 'book_3',
      name: 'Volcanoes Gorilla Trek',
      location: 'Musanze',
      image: 'https://images.unsplash.com/photo-1462331940025-496dfbfc7564?q=80&w=400&fit=crop',
      price: '\$1500.00',
      bookingDate: 'Dec 20, 2024',
      travelDate: 'Jan 05, 2025',
      status: BookingStatus.completed,
    ),
  ];

  // ── Getters ──────────────────────────────────────────────────
  List<TripItem> get favourites => List.unmodifiable(_favourites);
  List<TripItem> get addedTrips => List.unmodifiable(_addedTrips);
  List<BookedTrip> get bookedTrips => List.unmodifiable(_bookedTrips);
  List<TripGroup> get myGroups => List.unmodifiable(_myGroups);
  TripGroup? get activeGroup => _activeGroup;
  Set<String> get selectedIds => Set.unmodifiable(_selectedIds);

  List<TripItem> get selectedTrips =>
      _addedTrips.where((t) => _selectedIds.contains(t.id)).toList();

  bool isFavourite(String id) => _favourites.any((f) => f.id == id);
  bool isAdded(String id) => _addedTrips.any((t) => t.id == id);
  bool isSelected(String id) => _selectedIds.contains(id);
  bool isInTrip(String name) => _addedTrips.any((t) => t.name == name);

  void toggleSelected(String id) {
    if (_selectedIds.contains(id)) {
      _selectedIds.remove(id);
    } else {
      _selectedIds.add(id);
    }
    notifyListeners();
  }

  void toggleFavourite(TripItem item) {
    // Cannot favourite something already in the trip
    if (isInTrip(item.name)) return;
    final idx = _favourites.indexWhere((f) => f.name == item.name);
    if (idx >= 0) {
      _favourites.removeAt(idx);
    } else {
      _favourites.add(item);
    }
    notifyListeners();
  }

  void toggleAddTrip(TripItem item) {
    final idx = _addedTrips.indexWhere((t) => t.id == item.id);
    if (idx >= 0) {
      _addedTrips.removeAt(idx);
      _selectedIds.remove(item.id);
    } else {
      _addedTrips.add(item);
      _selectedIds.add(item.id);
      // Auto-remove from favourites when added to trip
      _favourites.removeWhere((f) => f.name == item.name);
    }
    notifyListeners();
  }

  void removeFromTrip(String id) {
    _addedTrips.removeWhere((t) => t.id == id);
    _selectedIds.remove(id);
    notifyListeners();
  }

  void setActiveGroup(TripGroup? group) {
    _activeGroup = group;
    notifyListeners();
  }

  void createGroup(String name) {
    final group = TripGroup(
      id: 'g${_myGroups.length + 1}',
      name: name,
      memberCount: 1,
    );
    _myGroups.add(group);
    _activeGroup = group;
    notifyListeners();
  }

  Map<String, List<TripItem>> get tripsByProvince {
    final map = <String, List<TripItem>>{};
    for (final trip in _addedTrips) {
      map.putIfAbsent(trip.province, () => []).add(trip);
    }
    return map;
  }

  double get selectedTripCost {
    return selectedTrips.fold(0.0, (sum, t) {
      final raw = t.price.replaceAll('\$', '').replaceAll(',', '');
      return sum + (double.tryParse(raw) ?? 0.0);
    });
  }

  // legacy — kept for booked tab
  double get totalTripCost => selectedTripCost;
}

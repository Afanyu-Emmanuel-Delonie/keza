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

class AccommodationBooking {
  final TripItem item;
  final DateTime checkIn;
  final DateTime checkOut;
  final int guests;
  final String roomType;
  final String? notes;

  const AccommodationBooking({
    required this.item,
    required this.checkIn,
    required this.checkOut,
    required this.guests,
    required this.roomType,
    this.notes,
  });

  int get nights => checkOut.difference(checkIn).inDays;

  double get totalCost {
    final raw = item.price.replaceAll(RegExp(r'[^\d.]'), '');
    return (double.tryParse(raw) ?? 0) * nights;
  }
}

class TourGuide {
  final String id;
  final String name;
  final String specialty;
  final String province;
  final String image;
  final String pricePerDay;
  final String rating;
  final List<String> languages;
  final bool needsManualConfirmation;

  const TourGuide({
    required this.id,
    required this.name,
    required this.specialty,
    required this.province,
    required this.image,
    required this.pricePerDay,
    required this.rating,
    required this.languages,
    this.needsManualConfirmation = false,
  });

  double get dailyRate {
    final raw = pricePerDay.replaceAll(RegExp(r'[^\d.]'), '');
    return double.tryParse(raw) ?? 0;
  }
}

class GuideBooking {
  final TourGuide guide;
  final DateTime date;
  final int days;
  final GuideBookingStatus status;

  const GuideBooking({
    required this.guide,
    required this.date,
    required this.days,
    this.status = GuideBookingStatus.pending,
  });

  double get totalCost => guide.dailyRate * days;

  GuideBooking copyWith({GuideBookingStatus? status}) => GuideBooking(
        guide: guide,
        date: date,
        days: days,
        status: status ?? this.status,
      );
}

enum GuideBookingStatus { pending, confirmed }
enum BookingStatus { pending, confirmed, completed }
enum TripReadiness { incomplete, awaitingConfirmation, ready }

class TripsProvider extends ChangeNotifier {
  // ── Liked accommodations ─────────────────────────────────────
  final Set<String> _likedAccommodationIds = {};

  // ── Selected accommodation + booking details per province ────
  final Map<String, AccommodationBooking> _bookings = {};

  // ── Guide bookings per province ──────────────────────────────
  final Map<String, GuideBooking> _guideBookings = {};

  bool isAccommodationLiked(String id) => _likedAccommodationIds.contains(id);

  bool isAccommodationSelected(String id) =>
      _bookings.values.any((b) => b.item.id == id);

  AccommodationBooking? bookingForProvince(String province) => _bookings[province];

  TripItem? selectedAccommodationForProvince(String province) =>
      _bookings[province]?.item;

  Map<String, AccommodationBooking> get allBookings => Map.unmodifiable(_bookings);
  Map<String, GuideBooking> get allGuideBookings => Map.unmodifiable(_guideBookings);

  void toggleLikeAccommodation(TripItem item) {
    if (_likedAccommodationIds.contains(item.id)) {
      _likedAccommodationIds.remove(item.id);
    } else {
      _likedAccommodationIds.add(item.id);
    }
    notifyListeners();
  }

  void confirmAccommodationBooking(AccommodationBooking booking) {
    _bookings[booking.item.province] = booking;
    notifyListeners();
  }

  void cancelAccommodationBooking(String province) {
    _bookings.remove(province);
    notifyListeners();
  }

  void confirmGuideBooking(GuideBooking booking) {
    _guideBookings[booking.guide.province] = booking;
    notifyListeners();
  }

  void cancelGuideBooking(String province) {
    _guideBookings.remove(province);
    notifyListeners();
  }

  void markGuideConfirmed(String province) {
    final b = _guideBookings[province];
    if (b != null) {
      _guideBookings[province] = b.copyWith(status: GuideBookingStatus.confirmed);
      notifyListeners();
    }
  }

  // legacy toggle kept for compatibility
  void toggleSelectAccommodation(TripItem item) {
    final existing = _bookings[item.province];
    if (existing?.item.id == item.id) {
      _bookings.remove(item.province);
    } else {
      // select without booking details — will be filled via form
      _bookings.remove(item.province);
    }
    notifyListeners();
  }

  Map<String, TripItem> get selectedAccommodations =>
      Map.fromEntries(_bookings.entries.map((e) => MapEntry(e.key, e.value.item)));

  // ── Favourites ───────────────────────────────────────────────
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

  final Set<String> _selectedIds = {};

  final List<TripGroup> _myGroups = [
    const TripGroup(id: 'g1', name: 'Rwanda Adventure Crew', memberCount: 4),
    const TripGroup(id: 'g2', name: 'Family Trip 2025', memberCount: 6),
  ];
  TripGroup? _activeGroup;

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

  double get totalAccommodationCost =>
      _bookings.values.fold(0.0, (sum, b) => sum + b.totalCost);

  double get totalGuideCost =>
      _guideBookings.values.fold(0.0, (sum, b) => sum + b.totalCost);

  double get totalTripCost => selectedTripCost;

  static const double serviceFeeRate = 0.05; // 5%

  double get serviceFee =>
      (totalAccommodationCost + totalTripCost + totalGuideCost) * serviceFeeRate;

  double get grandTotal =>
      totalAccommodationCost + totalTripCost + totalGuideCost + serviceFee;

  TripReadiness get tripReadiness {
    if (_bookings.isEmpty && _guideBookings.isEmpty) return TripReadiness.incomplete;
    final hasAwaitingGuide = _guideBookings.values.any(
      (b) => b.guide.needsManualConfirmation && b.status == GuideBookingStatus.pending,
    );
    if (hasAwaitingGuide) return TripReadiness.awaitingConfirmation;
    return TripReadiness.ready;
  }
}

// ── Static tour guide data per province ──────────────────────────────────────
const kTourGuides = <String, List<TourGuide>>{
  'Kigali City': [
    TourGuide(
      id: 'guide_kgl_1',
      name: 'Amina Uwase',
      specialty: 'City & Culture',
      province: 'Kigali City',
      image: 'https://images.unsplash.com/photo-1531123897727-8f129e1688ce?q=80&w=400&fit=crop',
      pricePerDay: '\$60/day',
      rating: '4.9',
      languages: ['English', 'French', 'Kinyarwanda'],
    ),
    TourGuide(
      id: 'guide_kgl_2',
      name: 'Jean-Pierre Habimana',
      specialty: 'History & Heritage',
      province: 'Kigali City',
      image: 'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?q=80&w=400&fit=crop',
      pricePerDay: '\$50/day',
      rating: '4.7',
      languages: ['English', 'Kinyarwanda'],
      needsManualConfirmation: true,
    ),
  ],
  'Northern Province': [
    TourGuide(
      id: 'guide_north_1',
      name: 'Eric Nkurunziza',
      specialty: 'Gorilla Trekking',
      province: 'Northern Province',
      image: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?q=80&w=400&fit=crop',
      pricePerDay: '\$120/day',
      rating: '5.0',
      languages: ['English', 'French', 'Kinyarwanda'],
      needsManualConfirmation: true,
    ),
    TourGuide(
      id: 'guide_north_2',
      name: 'Claudine Mukamana',
      specialty: 'Volcano Hiking',
      province: 'Northern Province',
      image: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?q=80&w=400&fit=crop',
      pricePerDay: '\$90/day',
      rating: '4.8',
      languages: ['English', 'Kinyarwanda'],
    ),
  ],
  'Eastern Province': [
    TourGuide(
      id: 'guide_east_1',
      name: 'Samuel Bizimana',
      specialty: 'Wildlife Safari',
      province: 'Eastern Province',
      image: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?q=80&w=400&fit=crop',
      pricePerDay: '\$80/day',
      rating: '4.6',
      languages: ['English', 'Kinyarwanda'],
    ),
  ],
  'Western Province': [
    TourGuide(
      id: 'guide_west_1',
      name: 'Diane Ingabire',
      specialty: 'Lake & Nature',
      province: 'Western Province',
      image: 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?q=80&w=400&fit=crop',
      pricePerDay: '\$70/day',
      rating: '4.8',
      languages: ['English', 'French', 'Kinyarwanda'],
    ),
  ],
  'Southern Province': [
    TourGuide(
      id: 'guide_south_1',
      name: 'Patrick Nzeyimana',
      specialty: 'Cultural Tours',
      province: 'Southern Province',
      image: 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?q=80&w=400&fit=crop',
      pricePerDay: '\$55/day',
      rating: '4.5',
      languages: ['English', 'Kinyarwanda'],
    ),
  ],
};

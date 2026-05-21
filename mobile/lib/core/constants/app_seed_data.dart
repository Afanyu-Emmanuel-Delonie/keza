import '../../features/trips/domain/entities/trip_entities.dart';

/// Seed data used by [TripsLocalDataSource] to pre-populate the in-memory
/// repository. Replace with API calls when the backend is ready.
class AppSeedData {
  // ── Booked trips ────────────────────────────────────────────────────────────
  static const List<BookedTrip> bookedTrips = [
    BookedTrip(
      id: 'book_1',
      name: 'Kigali Genocide Memorial',
      location: 'Gisozi, Kigali',
      image: 'https://images.unsplash.com/photo-1579208575657-c595a05383b7?q=80&w=400&fit=crop',
      price: 'Free',
      bookingDate: 'Jan 10, 2025',
      travelDate: 'Feb 14, 2025',
      status: BookingStatus.confirmed,
    ),
    BookedTrip(
      id: 'book_2',
      name: 'Lake Kivu Boat Tour',
      location: 'Rubavu',
      image: 'https://images.unsplash.com/photo-1501785888041-af3ef285b470?q=80&w=400&fit=crop',
      price: '\$35.00',
      bookingDate: 'Jan 15, 2025',
      travelDate: 'Mar 01, 2025',
      status: BookingStatus.pending,
    ),
    BookedTrip(
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

  // ── Trip groups ─────────────────────────────────────────────────────────────
  static const List<TripGroup> tripGroups = [
    TripGroup(id: 'g1', name: 'Rwanda Adventure Crew', memberCount: 4),
    TripGroup(id: 'g2', name: 'Family Trip 2025', memberCount: 6),
  ];

  // ── Tour guides by province ─────────────────────────────────────────────────
  static const Map<String, List<TourGuide>> tourGuidesByProvince = {
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
}

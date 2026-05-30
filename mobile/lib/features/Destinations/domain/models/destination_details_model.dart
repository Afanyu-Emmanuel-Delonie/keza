import 'package:flutter/material.dart';

// ── Available spot ────────────────────────────────────────────────────────────
class AvailableSpot {
  final DateTime date;
  final String time;
  final String price;
  final int spotsLeft;
  final bool isPopular;

  const AvailableSpot({
    required this.date,
    required this.time,
    required this.price,
    required this.spotsLeft,
    this.isPopular = false,
  });
}

// ── Review ────────────────────────────────────────────────────────────────────
class DestReview {
  final String name;
  final String avatar; // initials fallback
  final double rating;
  final String comment;
  final String date;
  const DestReview({
    required this.name,
    required this.avatar,
    required this.rating,
    required this.comment,
    required this.date,
  });
}

// ── Time slot ─────────────────────────────────────────────────────────────────
class TimeSlot {
  final String time;
  final bool available;
  const TimeSlot({required this.time, required this.available});
}

// ── Itinerary stop ────────────────────────────────────────────────────────────
class DestItineraryStop {
  final String time;
  final String title;
  final String detail;
  const DestItineraryStop({
    required this.time,
    required this.title,
    required this.detail,
  });
}

// ── Activity info ─────────────────────────────────────────────────────────────
class ActivityInfo {
  final String cancellationPolicy;
  final String tourGuide;
  final String duration;
  final List<String> languages;
  final String meetingPoint;
  final String groupSize;
  final String departureAndReturn;

  const ActivityInfo({
    required this.cancellationPolicy,
    required this.tourGuide,
    required this.duration,
    required this.languages,
    required this.meetingPoint,
    required this.groupSize,
    required this.departureAndReturn,
  });
}

// ── Full destination detail data ──────────────────────────────────────────────
class DestinationDetailData {
  final ActivityInfo activityInfo;
  final List<DestReview> reviews;
  final List<TimeSlot> timeSlots;
  final List<DestItineraryStop> itinerary;
  final List<String> highlights;
  final List<String> whatToCarry;
  final List<String> restrictions;
  final List<Map<String, String>> similarPlaces;
  final List<AvailableSpot> availableSpots;
  final List<String> whatToExpect;
  final List<String> whatIsIncluded;
  final List<String> accessibility;
  final List<String> additionalInfo;

  const DestinationDetailData({
    required this.activityInfo,
    required this.reviews,
    required this.timeSlots,
    required this.itinerary,
    required this.highlights,
    required this.whatToCarry,
    required this.restrictions,
    required this.similarPlaces,
    required this.availableSpots,
    required this.whatToExpect,
    required this.whatIsIncluded,
    required this.accessibility,
    required this.additionalInfo,
  });
}

// ── Default data (used when no specific data is passed) ───────────────────────
final kDefaultDestinationData = DestinationDetailData(
  availableSpots: [
    AvailableSpot(
      date: DateTime.now().add(const Duration(days: 1)),
      time: '06:00 AM',
      price: '\$50',
      spotsLeft: 4,
      isPopular: true,
    ),
  ],
  activityInfo: const ActivityInfo(
    cancellationPolicy: 'Free cancellation up to 48 hours before the activity. No refund within 48 hours.',
    tourGuide: 'Expert English-speaking guide included',
    duration: 'Full day (8–10 hours)',
    languages: ['English', 'French', 'Kinyarwanda'],
    meetingPoint: 'Kigali Convention Centre, Main Entrance',
    groupSize: 'Max 8 people per group',
    departureAndReturn: 'Departs from Kigali Convention Centre at 06:00 AM. Returns to the same point by 06:30 PM.',
  ),
  reviews: const [
    DestReview(
      name: 'Sarah M.',
      avatar: 'SM',
      rating: 5.0,
      comment: 'Absolutely life-changing experience. The guide was incredibly knowledgeable and the scenery was breathtaking.',
      date: 'Nov 2024',
    ),
    DestReview(
      name: 'James K.',
      avatar: 'JK',
      rating: 4.5,
      comment: 'Well organised, punctual and very professional. Rwanda is stunning — highly recommend this tour.',
      date: 'Oct 2024',
    ),
    DestReview(
      name: 'Amina T.',
      avatar: 'AT',
      rating: 5.0,
      comment: 'One of the best experiences of my life. The gorillas were incredible and the whole team was amazing.',
      date: 'Sep 2024',
    ),
  ],
  timeSlots: const [
    TimeSlot(time: '06:00 AM', available: true),
    TimeSlot(time: '07:30 AM', available: true),
    TimeSlot(time: '09:00 AM', available: false),
    TimeSlot(time: '11:00 AM', available: true),
    TimeSlot(time: '02:00 PM', available: false),
  ],
  itinerary: const [
    DestItineraryStop(
      time: '06:00',
      title: 'Hotel Pickup',
      detail: 'Pick up from your Kigali hotel and drive to the starting point.',
    ),
    DestItineraryStop(
      time: '08:30',
      title: 'Arrival & Briefing',
      detail: 'Arrive at the park headquarters. Receive safety briefing from rangers.',
    ),
    DestItineraryStop(
      time: '09:00',
      title: 'Activity Begins',
      detail: 'Begin the main activity with your expert guide.',
    ),
    DestItineraryStop(
      time: '12:30',
      title: 'Lunch Break',
      detail: 'Enjoy a packed lunch in a scenic spot.',
    ),
    DestItineraryStop(
      time: '14:00',
      title: 'Continued Exploration',
      detail: 'Continue exploring the area with your guide.',
    ),
    DestItineraryStop(
      time: '16:30',
      title: 'Return Journey',
      detail: 'Drive back to Kigali. Arrive approximately 18:30.',
    ),
  ],
  highlights: const [
    'Expert certified guide throughout',
    'Small group — max 8 people',
    'All park entry fees included',
    'Bottled water & snacks provided',
    'Hotel pickup & drop-off from Kigali',
    'Certificate of participation',
  ],
  whatToCarry: const [
    'Comfortable hiking boots or sturdy shoes',
    'Light rain jacket or poncho',
    'Sunscreen and insect repellent',
    'Camera (no flash photography)',
    'Valid passport or ID',
    'Personal medication if needed',
    'Small backpack for personal items',
  ],
  restrictions: const [
    'Not suitable for children under 10 years',
    'Not recommended for adults over 70 with mobility issues',
    'Pregnant women are advised not to participate',
    'Visitors with flu, cold or infectious illness will be turned away',
    'No drones or flash photography allowed',
    'Smoking and alcohol strictly prohibited on site',
  ],
  whatToExpect: const [
    'A guided trek through lush volcanic forest terrain',
    'Close encounter with mountain gorillas in their natural habitat',
    'Scenic views of the Virunga mountain range',
    'Cultural interaction with local communities along the trail',
    'Certificate of participation upon completion',
    'Briefing by certified park rangers before the activity',
  ],
  whatIsIncluded: const [
    'Round-trip hotel transfers from Kigali',
    'Expert certified English-speaking guide',
    'All national park entry fees',
    'Bottled water and light snacks',
    'Packed lunch at a scenic rest point',
    'First aid kit and emergency support',
    'Certificate of participation',
  ],
  accessibility: const [
    'Moderate to strenuous physical activity — good fitness required',
    'Terrain involves steep and uneven forest paths',
    'Not wheelchair accessible',
    'Participants must be at least 15 years old',
    'Not recommended for individuals with heart or respiratory conditions',
    'Walking sticks provided on request at the park entrance',
  ],
  additionalInfo: const [
    'Wear neutral-coloured, long-sleeved clothing to blend with the environment',
    'Flash photography is strictly prohibited near wildlife',
    'Maintain a minimum distance of 7 metres from the gorillas at all times',
    'Visitors showing signs of illness may be denied entry for wildlife safety',
    'Smoking and alcohol are not permitted on the trail',
    'All waste must be carried out — leave no trace policy applies',
  ],
  similarPlaces: const [
    {
      'name': 'Akagera Safari',
      'location': 'Kayonza, East',
      'image': 'https://images.unsplash.com/photo-1547407139-3c921a66005c?q=80&w=400&fit=crop',
      'price': '\$50',
      'rating': '4.7',
    },
    {
      'name': 'Nyungwe Canopy Walk',
      'location': 'Nyungwe, South',
      'image': 'https://images.unsplash.com/photo-1501785888041-af3ef285b470?q=80&w=400&fit=crop',
      'price': '\$60',
      'rating': '4.8',
    },
    {
      'name': 'Twin Lakes',
      'location': 'Burera, North',
      'image': 'https://images.unsplash.com/photo-1501785888041-af3ef285b470?q=80&w=400&fit=crop',
      'price': '\$20',
      'rating': '4.7',
    },
    {
      'name': 'Lake Kivu Kayaking',
      'location': 'Rubavu, West',
      'image': 'https://images.unsplash.com/photo-1540541338287-41700207dee6?q=80&w=400&fit=crop',
      'price': '\$25',
      'rating': '4.6',
    },
  ],
);

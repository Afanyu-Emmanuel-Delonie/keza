import 'package:flutter/material.dart';

class AppConstants {
  // ── Categories ──────────────────────────────────────────────────────────────
  static const List<Map<String, dynamic>> categories = [
    {'id': 'nature',           'name': 'Nature',    'icon': Icons.park_outlined},
    {'id': 'wild_life',        'name': 'Wild Life', 'icon': Icons.pets_outlined},
    {'id': 'volcano',          'name': 'Volcano',   'icon': Icons.terrain_outlined},
    {'id': 'accommodation',    'name': 'Stay',      'icon': Icons.hotel_outlined},
    {'id': 'culture_history',  'name': 'Culture',   'icon': Icons.museum_outlined},
    {'id': 'adventure_trails', 'name': 'Adventure', 'icon': Icons.hiking_outlined},
    {'id': 'travel_toolkit',   'name': 'Travel',    'icon': Icons.luggage_outlined},
  ];

  // ── Category keyword filters (used by Home & Explore screens) ───────────────
  static const Map<String, List<String>> categoryKeywords = {
    'nature':           ['park', 'lake', 'eco', 'forest', 'twin'],
    'wild_life':        ['akagera', 'gorilla', 'wildlife', 'volcanoes'],
    'volcano':          ['volcano', 'volcanoes'],
    'culture_history':  ['memorial', 'museum', 'cultural'],
    'adventure_trails': ['hiking', 'trail', 'trek'],
  };

  // ── Quick services ──────────────────────────────────────────────────────────
  static const List<Map<String, dynamic>> quickServices = [
    {'icon': Icons.hotel,          'label': 'Hotels'},
    {'icon': Icons.flight,         'label': 'Flights'},
    {'icon': Icons.restaurant,     'label': 'Food'},
    {'icon': Icons.directions_bus, 'label': 'Transport'},
  ];

  // ── Provinces ───────────────────────────────────────────────────────────────
  static const List<Map<String, dynamic>> provinces = [
    {
      'name': 'Kigali City',
      'image': 'https://images.unsplash.com/photo-1589551403423-380f2d5f8f26?q=80&w=400&fit=crop',
      'places_count': '12 Places',
      'destinations': [
        {
          'name': 'Kigali Genocide Memorial',
          'location': 'Gisozi, Kigali',
          'image': 'https://images.unsplash.com/photo-1579208575657-c595a05383b7?q=80&w=400&fit=crop',
          'rating': '4.9',
          'price': 'Free',
        },
        {
          'name': 'Nyandungu Eco-Park',
          'location': 'Nyarugunga, Kigali',
          'image': 'https://images.unsplash.com/photo-1501785888041-af3ef285b470?q=80&w=400&fit=crop',
          'rating': '4.5',
          'price': '\$10.00',
        },
      ],
    },
    {
      'name': 'Northern Province',
      'image': 'https://images.unsplash.com/photo-1551632811-561732d1e306?q=80&w=400&fit=crop',
      'places_count': '8 Places',
      'destinations': [
        {
          'name': 'Volcanoes National Park',
          'location': 'Musanze',
          'image': 'https://images.unsplash.com/photo-1462331940025-496dfbfc7564?q=80&w=400&fit=crop',
          'rating': '5.0',
          'price': '\$1500.00',
        },
        {
          'name': 'Twin Lakes',
          'location': 'Burera & Ruhondo',
          'image': 'https://images.unsplash.com/photo-1501785888041-af3ef285b470?q=80&w=400&fit=crop',
          'rating': '4.7',
          'price': '\$20.00',
        },
      ],
    },
    {
      'name': 'Western Province',
      'image': 'https://images.unsplash.com/photo-1501785888041-af3ef285b470?q=80&w=400&fit=crop',
      'places_count': '15 Places',
      'destinations': [
        {
          'name': 'Lake Kivu',
          'location': 'Rubavu',
          'image': 'https://images.unsplash.com/photo-1501785888041-af3ef285b470?q=80&w=400&fit=crop',
          'rating': '4.8',
          'price': 'Free',
        },
      ],
    },
    {
      'name': 'Eastern Province',
      'image': 'https://images.unsplash.com/photo-1547407139-3c921a66005c?q=80&w=400&fit=crop',
      'places_count': '6 Places',
      'destinations': [
        {
          'name': 'Akagera National Park',
          'location': 'Kayonza',
          'image': 'https://images.unsplash.com/photo-1547407139-3c921a66005c?q=80&w=400&fit=crop',
          'rating': '4.8',
          'price': '\$50.00',
        },
      ],
    },
  ];

  // ── Things to do in Rwanda ────────────────────────────────────────────────
  static const List<Map<String, String>> thingsToDo = [
    {
      'id': 'todo_gorilla',
      'title': 'Gorilla Trekking',
      'category': 'Wildlife',
      'location': 'Volcanoes NP',
      'duration': 'Full day',
      'price': '\$1,500',
      'emoji': '🦍',
      'image': 'https://images.unsplash.com/photo-1516426122078-c23e76319801?q=80&w=600&fit=crop',
      'description': 'Trek through Volcanoes NP to encounter mountain gorillas face to face.',
    },
    {
      'id': 'todo_safari',
      'title': 'Akagera Safari',
      'category': 'Wildlife',
      'location': 'Akagera NP',
      'duration': 'Half day',
      'price': '\$50',
      'emoji': '🐘',
      'image': 'https://images.unsplash.com/photo-1547407139-3c921a66005c?q=80&w=600&fit=crop',
      'description': 'Spot the Big Five on a guided game drive through Rwanda\'s only savanna park.',
    },
    {
      'id': 'todo_canopy',
      'title': 'Canopy Walk',
      'category': 'Adventure',
      'location': 'Nyungwe Forest',
      'duration': '3 hrs',
      'price': '\$60',
      'emoji': '🌿',
      'image': 'https://images.unsplash.com/photo-1501785888041-af3ef285b470?q=80&w=600&fit=crop',
      'description': 'Walk above the ancient rainforest canopy with breathtaking views.',
    },
    {
      'id': 'todo_kayak',
      'title': 'Lake Kivu Kayaking',
      'category': 'Adventure',
      'location': 'Rubavu',
      'duration': '3 hrs',
      'price': '\$25',
      'emoji': '🚣',
      'image': 'https://images.unsplash.com/photo-1540541338287-41700207dee6?q=80&w=600&fit=crop',
      'description': 'Paddle through the islands of Lake Kivu — peaceful and scenic.',
    },
    {
      'id': 'todo_culture',
      'title': 'Cultural Village Tour',
      'category': 'Culture',
      'location': 'Kinigi, Musanze',
      'duration': '2 hrs',
      'price': '\$30',
      'emoji': '🏛️',
      'image': 'https://images.unsplash.com/photo-1523805009345-7448845a9e53?q=80&w=600&fit=crop',
      'description': 'Experience traditional Rwandan dance, crafts and storytelling.',
    },
    {
      'id': 'todo_caves',
      'title': 'Musanze Caves',
      'category': 'Adventure',
      'location': 'Musanze',
      'duration': '2 hrs',
      'price': '\$15',
      'emoji': '🕳️',
      'image': 'https://images.unsplash.com/photo-1516426122078-c23e76319801?q=80&w=600&fit=crop',
      'description': 'Explore ancient lava tubes with fascinating geological history.',
    },
    {
      'id': 'todo_boat',
      'title': 'Lake Kivu Boat Tour',
      'category': 'Nature',
      'location': 'Rubavu',
      'duration': '2 hrs',
      'price': '\$35',
      'emoji': '⛵',
      'image': 'https://images.unsplash.com/photo-1501785888041-af3ef285b470?q=80&w=600&fit=crop',
      'description': 'Sunset boat cruise across the stunning Lake Kivu.',
    },
    {
      'id': 'todo_kigali_tour',
      'title': 'Kigali City Tour',
      'category': 'Culture',
      'location': 'Kigali',
      'duration': 'Half day',
      'price': '\$20',
      'emoji': '🏙️',
      'image': 'https://images.unsplash.com/photo-1589551403423-380f2d5f8f26?q=80&w=600&fit=crop',
      'description': 'Explore Africa\'s cleanest city — markets, art, food and history.',
    },
  ];

  // ── Top destinations (home feed & explore list) ─────────────────────────────
  static const List<Map<String, String>> topDestinations = [
    {
      'name': 'Volcanoes National Park',
      'location': 'Musanze, North',
      'image': 'https://images.unsplash.com/photo-1551632811-561732d1e306?q=80&w=400&fit=crop',
      'rating': '4.9',
      'price': '\$1500.00',
    },
    {
      'name': 'Lake Kivu',
      'location': 'Rubavu, West',
      'image': 'https://images.unsplash.com/photo-1501785888041-af3ef285b470?q=80&w=400&fit=crop',
      'rating': '4.8',
      'price': 'Free',
    },
    {
      'name': 'Akagera National Park',
      'location': 'Kayonza, East',
      'image': 'https://images.unsplash.com/photo-1547407139-3c921a66005c?q=80&w=400&fit=crop',
      'rating': '4.7',
      'price': '\$50.00',
    },
    {
      'name': 'Kigali Genocide Memorial',
      'location': 'Gisozi, Kigali',
      'image': 'https://images.unsplash.com/photo-1579208575657-c595a05383b7?q=80&w=400&fit=crop',
      'rating': '4.9',
      'price': 'Free',
    },
    {
      'name': 'Nyungwe Forest',
      'location': 'Nyungwe, South',
      'image': 'https://images.unsplash.com/photo-1501785888041-af3ef285b470?q=80&w=400&fit=crop',
      'rating': '4.8',
      'price': '\$60.00',
    },
    {
      'name': 'Twin Lakes',
      'location': 'Burera & Ruhondo, North',
      'image': 'https://images.unsplash.com/photo-1501785888041-af3ef285b470?q=80&w=400&fit=crop',
      'rating': '4.7',
      'price': '\$20.00',
    },
  ];

  // ── Featured stays (home screen) ────────────────────────────────────────────
  static const List<Map<String, String>> featuredStays = [
    {
      'id': 'stay_kigali_0',
      'name': 'Kigali Serena Hotel',
      'location': 'Kiyovu, Kigali',
      'province': 'Kigali City',
      'image': 'https://images.unsplash.com/photo-1566073771259-6a8506099945?q=80&w=400&fit=crop',
      'price': '\$180.00',
      'rating': '4.9',
      'reviews': '312',
    },
    {
      'id': 'stay_kigali_1',
      'name': 'Radisson Blu Kigali',
      'location': 'Gasabo, Kigali',
      'province': 'Kigali City',
      'image': 'https://images.unsplash.com/photo-1582719508461-905c673771fd?q=80&w=400&fit=crop',
      'price': '\$150.00',
      'rating': '4.7',
      'reviews': '198',
    },
    {
      'id': 'stay_kigali_2',
      'name': 'Nyandungu Eco Lodge',
      'location': 'Nyarugunga, Kigali',
      'province': 'Kigali City',
      'image': 'https://images.unsplash.com/photo-1520250497591-112f2f40a3f4?q=80&w=400&fit=crop',
      'price': '\$95.00',
      'rating': '4.5',
      'reviews': '87',
    },
  ];

  // ── All stays (all stays screen) ────────────────────────────────────────────
  static const List<Map<String, String>> allStays = [
    {
      'id': 'stay_kigali_0',
      'name': 'Kigali Serena Hotel',
      'location': 'Kiyovu, Kigali',
      'province': 'Kigali City',
      'image': 'https://images.unsplash.com/photo-1566073771259-6a8506099945?q=80&w=400&fit=crop',
      'price': '\$180.00',
      'rating': '4.9',
      'reviews': '312',
    },
    {
      'id': 'stay_kigali_1',
      'name': 'Radisson Blu Kigali',
      'location': 'Gasabo, Kigali',
      'province': 'Kigali City',
      'image': 'https://images.unsplash.com/photo-1582719508461-905c673771fd?q=80&w=400&fit=crop',
      'price': '\$150.00',
      'rating': '4.7',
      'reviews': '198',
    },
    {
      'id': 'stay_kigali_2',
      'name': 'Nyandungu Eco Lodge',
      'location': 'Nyarugunga, Kigali',
      'province': 'Kigali City',
      'image': 'https://images.unsplash.com/photo-1520250497591-112f2f40a3f4?q=80&w=400&fit=crop',
      'price': '\$95.00',
      'rating': '4.5',
      'reviews': '87',
    },
    {
      'id': 'stay_north_0',
      'name': 'Five Volcanoes Boutique Hotel',
      'location': 'Musanze, Northern Province',
      'province': 'Northern Province',
      'image': 'https://images.unsplash.com/photo-1582719508461-905c673771fd?q=80&w=400&fit=crop',
      'price': '\$120.00',
      'rating': '4.8',
      'reviews': '143',
    },
    {
      'id': 'stay_west_0',
      'name': 'Lake Kivu Serena Hotel',
      'location': 'Rubavu, Western Province',
      'province': 'Western Province',
      'image': 'https://images.unsplash.com/photo-1540541338287-41700207dee6?q=80&w=400&fit=crop',
      'price': '\$150.00',
      'rating': '4.8',
      'reviews': '221',
    },
    {
      'id': 'stay_east_0',
      'name': 'Akagera Game Lodge',
      'location': 'Kayonza, Eastern Province',
      'province': 'Eastern Province',
      'image': 'https://images.unsplash.com/photo-1551882547-ff40c63fe5fa?q=80&w=400&fit=crop',
      'price': '\$95.00',
      'rating': '4.6',
      'reviews': '98',
    },
    {
      'id': 'stay_south_0',
      'name': 'Nyungwe Forest Lodge',
      'location': 'Nyungwe, Southern Province',
      'province': 'Southern Province',
      'image': 'https://images.unsplash.com/photo-1520250497591-112f2f40a3f4?q=80&w=400&fit=crop',
      'price': '\$110.00',
      'rating': '4.7',
      'reviews': '76',
    },
  ];

  // ── AI proposed places catalogue ────────────────────────────────────────────
  static const List<Map<String, dynamic>> aiProposedPlaces = [
    {
      'id': 'pp_gorilla',
      'name': 'Gorilla Trekking',
      'location': 'Volcanoes NP, Musanze',
      'province': 'Northern Province',
      'image': 'https://images.unsplash.com/photo-1516426122078-c23e76319801?q=80&w=600&fit=crop',
      'category': 'Wildlife',
      'entryFee': 1500.0,
      'duration': 'Full day',
      'description': 'Trek through Volcanoes NP to see mountain gorillas in their natural habitat.',
    },
    {
      'id': 'pp_akagera',
      'name': 'Akagera Safari',
      'location': 'Akagera NP, Kayonza',
      'province': 'Eastern Province',
      'image': 'https://images.unsplash.com/photo-1547407139-3c921a66005c?q=80&w=600&fit=crop',
      'category': 'Wildlife',
      'entryFee': 50.0,
      'duration': 'Half day',
      'description': 'Big Five safari — lions, elephants, hippos, buffalos & leopards.',
    },
    {
      'id': 'pp_twin_lakes',
      'name': 'Twin Lakes',
      'location': 'Burera & Ruhondo',
      'province': 'Northern Province',
      'image': 'https://images.unsplash.com/photo-1501785888041-af3ef285b470?q=80&w=600&fit=crop',
      'category': 'Nature',
      'entryFee': 20.0,
      'duration': '3 hrs',
      'description': 'Stunning crater lakes perfect for kayaking and photography.',
    },
    {
      'id': 'pp_kivu',
      'name': 'Lake Kivu',
      'location': 'Rubavu, Western Province',
      'province': 'Western Province',
      'image': 'https://images.unsplash.com/photo-1540541338287-41700207dee6?q=80&w=600&fit=crop',
      'category': 'Nature',
      'entryFee': 0.0,
      'duration': 'Half day',
      'description': 'Scenic lake with boat tours, kayaking and beach relaxation.',
    },
    {
      'id': 'pp_nyungwe',
      'name': 'Nyungwe Canopy Walk',
      'location': 'Nyungwe Forest',
      'province': 'Southern Province',
      'image': 'https://images.unsplash.com/photo-1501785888041-af3ef285b470?q=80&w=600&fit=crop',
      'category': 'Adventure',
      'entryFee': 60.0,
      'duration': '3 hrs',
      'description': 'Walk above the ancient rainforest canopy — breathtaking views.',
    },
    {
      'id': 'pp_memorial',
      'name': 'Kigali Genocide Memorial',
      'location': 'Gisozi, Kigali',
      'province': 'Kigali City',
      'image': 'https://images.unsplash.com/photo-1579208575657-c595a05383b7?q=80&w=600&fit=crop',
      'category': 'Culture',
      'entryFee': 0.0,
      'duration': '2 hrs',
      'description': "A deeply moving memorial — essential for understanding Rwanda's history.",
    },
    {
      'id': 'pp_inema',
      'name': 'Inema Arts Center',
      'location': 'Kacyiru, Kigali',
      'province': 'Kigali City',
      'image': 'https://images.unsplash.com/photo-1523805009345-7448845a9e53?q=80&w=600&fit=crop',
      'category': 'Culture',
      'entryFee': 10.0,
      'duration': '1.5 hrs',
      'description': 'Contemporary Rwandan art gallery — vibrant and inspiring.',
    },
    {
      'id': 'pp_musanze_caves',
      'name': 'Musanze Caves',
      'location': 'Musanze',
      'province': 'Northern Province',
      'image': 'https://images.unsplash.com/photo-1516426122078-c23e76319801?q=80&w=600&fit=crop',
      'category': 'Adventure',
      'entryFee': 15.0,
      'duration': '2 hrs',
      'description': 'Ancient lava tubes with fascinating geological history.',
    },
    {
      'id': 'pp_nyamirambo',
      'name': 'Nyamirambo Walking Tour',
      'location': 'Nyamirambo, Kigali',
      'province': 'Kigali City',
      'image': 'https://images.unsplash.com/photo-1523805009345-7448845a9e53?q=80&w=600&fit=crop',
      'category': 'Culture',
      'entryFee': 25.0,
      'duration': '2 hrs',
      'description': 'Local neighbourhood — street food, mosques, markets & real Kigali life.',
    },
    {
      'id': 'pp_kivu_kayak',
      'name': 'Lake Kivu Kayaking',
      'location': 'Rubavu',
      'province': 'Western Province',
      'image': 'https://images.unsplash.com/photo-1501785888041-af3ef285b470?q=80&w=600&fit=crop',
      'category': 'Adventure',
      'entryFee': 25.0,
      'duration': '3 hrs',
      'description': 'Paddle through the islands of Lake Kivu — peaceful and scenic.',
    },
  ];

  // ── AI accommodation catalogue (used by trip plan generator) ────────────────
  static const List<Map<String, dynamic>> aiAccommodations = [
    {
      'id': 'acc_serena_kigali',
      'name': 'Kigali Serena Hotel',
      'province': 'Kigali City',
      'image': 'https://images.unsplash.com/photo-1566073771259-6a8506099945?q=80&w=600&fit=crop',
      'pricePerNight': 180.0,
      'rating': '4.9',
      'tier': 'luxury',
    },
    {
      'id': 'acc_radisson_kigali',
      'name': 'Radisson Blu Kigali',
      'province': 'Kigali City',
      'image': 'https://images.unsplash.com/photo-1582719508461-905c673771fd?q=80&w=600&fit=crop',
      'pricePerNight': 150.0,
      'rating': '4.7',
      'tier': 'mid',
    },
    {
      'id': 'acc_nyandungu',
      'name': 'Nyandungu Eco Lodge',
      'province': 'Kigali City',
      'image': 'https://images.unsplash.com/photo-1520250497591-112f2f40a3f4?q=80&w=600&fit=crop',
      'pricePerNight': 95.0,
      'rating': '4.5',
      'tier': 'budget',
    },
    {
      'id': 'acc_five_volcanoes',
      'name': 'Five Volcanoes Boutique Hotel',
      'province': 'Northern Province',
      'image': 'https://images.unsplash.com/photo-1582719508461-905c673771fd?q=80&w=600&fit=crop',
      'pricePerNight': 120.0,
      'rating': '4.8',
      'tier': 'mid',
    },
    {
      'id': 'acc_kivu_serena',
      'name': 'Lake Kivu Serena Hotel',
      'province': 'Western Province',
      'image': 'https://images.unsplash.com/photo-1540541338287-41700207dee6?q=80&w=600&fit=crop',
      'pricePerNight': 150.0,
      'rating': '4.8',
      'tier': 'luxury',
    },
    {
      'id': 'acc_akagera_lodge',
      'name': 'Akagera Game Lodge',
      'province': 'Eastern Province',
      'image': 'https://images.unsplash.com/photo-1551882547-ff40c63fe5fa?q=80&w=600&fit=crop',
      'pricePerNight': 95.0,
      'rating': '4.6',
      'tier': 'mid',
    },
    {
      'id': 'acc_nyungwe_lodge',
      'name': 'Nyungwe Forest Lodge',
      'province': 'Southern Province',
      'image': 'https://images.unsplash.com/photo-1520250497591-112f2f40a3f4?q=80&w=600&fit=crop',
      'pricePerNight': 110.0,
      'rating': '4.7',
      'tier': 'mid',
    },
  ];

  // ── Province inference helper ────────────────────────────────────────────────
  static String inferProvince(String location) {
    final l = location.toLowerCase();
    if (l.contains('kigali')) return 'Kigali City';
    if (l.contains('musanze') || l.contains('north') || l.contains('burera') || l.contains('ruhondo')) {
      return 'Northern Province';
    }
    if (l.contains('rubavu') || l.contains('west') || l.contains('kivu')) return 'Western Province';
    if (l.contains('kayonza') || l.contains('east') || l.contains('akagera')) return 'Eastern Province';
    if (l.contains('huye') || l.contains('south') || l.contains('nyanza') || l.contains('nyungwe')) {
      return 'Southern Province';
    }
    return 'Kigali City';
  }
}

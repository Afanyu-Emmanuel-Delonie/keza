import 'package:flutter/material.dart';

class AppConstants {
  static const List<Map<String, dynamic>> categories = [
    {'id': 'nature',           'name': 'Nature',        'icon': Icons.park_outlined},
    {'id': 'wild_life',        'name': 'Wild Life',     'icon': Icons.pets_outlined},
    {'id': 'volcano',          'name': 'Volcano',       'icon': Icons.terrain_outlined},
    {'id': 'accommodation',    'name': 'Stay',          'icon': Icons.hotel_outlined},
    {'id': 'culture_history',  'name': 'Culture',       'icon': Icons.museum_outlined},
    {'id': 'adventure_trails', 'name': 'Adventure',     'icon': Icons.hiking_outlined},
    {'id': 'travel_toolkit',   'name': 'Travel',        'icon': Icons.luggage_outlined},
  ];

  static const List<Map<String, dynamic>> quickServices = [
    {'icon': Icons.hotel, 'label': 'Hotels'},
    {'icon': Icons.flight, 'label': 'Flights'},
    {'icon': Icons.restaurant, 'label': 'Food'},
    {'icon': Icons.directions_bus, 'label': 'Transport'},
  ];

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
      ]
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
      ]
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
      ]
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
      ]
    },
  ];

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
  ];
}

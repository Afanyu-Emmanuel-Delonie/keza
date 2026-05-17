import 'package:flutter/material.dart';

class AppConstants {
  static const List<Map<String, String>> categories = [
    {
      'id': 'nature',
      'name': 'Nature',
      'image': 'https://images.unsplash.com/photo-1441974231531-c6227db76b6e?q=80&w=200&auto=format&fit=crop'
    },
    {
      'id': 'wild_life',
      'name': 'Wild Life',
      'image': 'https://images.unsplash.com/photo-1549366021-9f761d450615?q=80&w=200&auto=format&fit=crop'
    },
    {
      'id': 'volcano',
      'name': 'Volcano',
      'image': 'https://images.unsplash.com/photo-1580231189569-7004313f822a?q=80&w=200&auto=format&fit=crop'
    },
    {
      'id': 'accommodation',
      'name': 'Accommodation',
      'image': 'https://images.unsplash.com/photo-1566073771259-6a8506099945?q=80&w=200&auto=format&fit=crop'
    },
    {
      'id': 'culture_history',
      'name': 'Culture',
      'image': 'https://images.unsplash.com/photo-1518998053574-53f1f61f9b86?q=80&w=200&auto=format&fit=crop'
    },
    {
      'id': 'adventure_trails',
      'name': 'Adventure',
      'image': 'https://images.unsplash.com/photo-1551632811-561732d1e306?q=80&w=200&auto=format&fit=crop'
    },
    {
      'id': 'travel_toolkit',
      'name': 'Travel',
      'image': 'https://images.unsplash.com/photo-1527631746610-bca00a040d60?q=80&w=200&auto=format&fit=crop'
    },
  ];

  static const List<Map<String, dynamic>> quickServices = [
    {'icon': Icons.hotel, 'label': 'Hotels'},
    {'icon': Icons.flight, 'label': 'Flights'},
    {'icon': Icons.restaurant, 'label': 'Food'},
    {'icon': Icons.directions_bus, 'label': 'Transport'},
  ];
}

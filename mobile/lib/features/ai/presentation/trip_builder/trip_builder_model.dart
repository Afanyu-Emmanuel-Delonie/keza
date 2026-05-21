import '../../../../core/constants/app_constants.dart';

// ── Trip preferences ──────────────────────────────────────────────────────────
class TripPrefs {
  final DateTime startDate;
  final DateTime endDate;
  final double budget; // total budget in USD
  final int people;
  final List<String> interests;

  const TripPrefs({
    required this.startDate,
    required this.endDate,
    required this.budget,
    required this.people,
    required this.interests,
  });

  int get days => endDate.difference(startDate).inDays.clamp(1, 30);
  double get budgetPerPerson => budget / people;
}

// ── A proposed destination the user can pick ──────────────────────────────────
class ProposedPlace {
  final String id;
  final String name;
  final String location;
  final String province;
  final String image;
  final String category; // matches interest
  final double entryFee; // per person
  final String duration;
  final String description;

  const ProposedPlace({
    required this.id,
    required this.name,
    required this.location,
    required this.province,
    required this.image,
    required this.category,
    required this.entryFee,
    required this.duration,
    required this.description,
  });
}

// ── A single stop in a day ────────────────────────────────────────────────────
class TripStop {
  final String id;
  final String name;
  final String location;
  final String image;
  final String duration;
  final String type; // 'destination' | 'stay' | 'transport'
  final String? note;
  final double? costPerPerson;

  const TripStop({
    required this.id,
    required this.name,
    required this.location,
    required this.image,
    required this.duration,
    required this.type,
    this.note,
    this.costPerPerson,
  });

  String get priceLabel => costPerPerson != null
      ? costPerPerson! == 0
          ? 'Free'
          : '\$${costPerPerson!.toStringAsFixed(0)}/person'
      : '';
}

// ── One day in the itinerary ──────────────────────────────────────────────────
class ItineraryDay {
  final int day;
  final DateTime date;
  final String title;
  final String province;
  final List<TripStop> stops;

  ItineraryDay({
    required this.day,
    required this.date,
    required this.title,
    required this.province,
    required this.stops,
  });

  // mutable copy for customisation
  ItineraryDay copyWith({List<TripStop>? stops}) => ItineraryDay(
        day: day,
        date: date,
        title: title,
        province: province,
        stops: stops ?? this.stops,
      );
}

// ── Generated trip plan ───────────────────────────────────────────────────────
class TripPlan {
  final String id;
  final TripPrefs prefs;
  final List<ItineraryDay> days;
  final double estimatedCost; // total for all people
  final List<String> highlights;
  final String? accommodationNote;

  TripPlan({
    required this.id,
    required this.prefs,
    required this.days,
    required this.estimatedCost,
    required this.highlights,
    this.accommodationNote,
  });

  bool get isOverBudget => estimatedCost > prefs.budget;
  double get overBy => estimatedCost - prefs.budget;
  double get savingsNeeded => isOverBudget ? overBy : 0;

  TripPlan copyWith({List<ItineraryDay>? days, double? estimatedCost}) => TripPlan(
        id: id,
        prefs: prefs,
        days: days ?? this.days,
        estimatedCost: estimatedCost ?? this.estimatedCost,
        highlights: highlights,
        accommodationNote: accommodationNote,
      );
}

// ── All proposed places catalogue ────────────────────────────────────────────
List<ProposedPlace> get kAllProposedPlaces => AppConstants.aiProposedPlaces
    .map((m) => ProposedPlace(
          id: m['id'] as String,
          name: m['name'] as String,
          location: m['location'] as String,
          province: m['province'] as String,
          image: m['image'] as String,
          category: m['category'] as String,
          entryFee: (m['entryFee'] as num).toDouble(),
          duration: m['duration'] as String,
          description: m['description'] as String,
        ))
    .toList();

// ── Accommodation catalogue ───────────────────────────────────────────────────
List<Map<String, dynamic>> get kAccommodations => AppConstants.aiAccommodations;

// ── Filter proposed places by interests ──────────────────────────────────────
List<ProposedPlace> getProposedPlaces(List<String> interests) {
  if (interests.isEmpty) return kAllProposedPlaces;
  return kAllProposedPlaces
      .where((p) => interests.contains(p.category))
      .toList();
}

// ── Pick best accommodation for a province given budget tier ─────────────────
String _budgetTier(double budgetPerPerson) {
  if (budgetPerPerson >= 300) return 'luxury';
  if (budgetPerPerson >= 150) return 'mid';
  return 'budget';
}

Map<String, dynamic>? _accForProvince(String province, String tier) {
  final matches = kAccommodations.where((a) => a['province'] == province).toList();
  if (matches.isEmpty) return kAccommodations.first;
  // prefer matching tier, fallback to any
  return matches.firstWhere((a) => a['tier'] == tier, orElse: () => matches.first);
}

// ── Generate itinerary from selected places ───────────────────────────────────
TripPlan generatePlan(TripPrefs prefs, List<ProposedPlace> selected) {
  final tier = _budgetTier(prefs.budgetPerPerson);
  final days = <ItineraryDay>[];
  double totalCost = 0;
  final highlights = <String>[];

  // Group selected places by province for logical routing
  final byProvince = <String, List<ProposedPlace>>{};
  for (final p in selected) {
    byProvince.putIfAbsent(p.province, () => []).add(p);
  }

  // Always start in Kigali
  final provinces = ['Kigali City', ...byProvince.keys.where((k) => k != 'Kigali City')];

  int dayNum = 0;
  for (final province in provinces) {
    if (dayNum >= prefs.days) break;
    final places = byProvince[province] ?? [];
    if (places.isEmpty && province != 'Kigali City') continue;

    final date = prefs.startDate.add(Duration(days: dayNum));
    final stops = <TripStop>[];

    // Transport stop if not first day
    if (dayNum > 0) {
      stops.add(TripStop(
        id: 'transport_$dayNum',
        name: 'Drive to $province',
        location: province,
        image: 'https://images.unsplash.com/photo-1501785888041-af3ef285b470?q=80&w=600&fit=crop',
        duration: '2–3 hrs',
        type: 'transport',
      ));
    }

    // Destination stops
    for (final place in places) {
      stops.add(TripStop(
        id: place.id,
        name: place.name,
        location: place.location,
        image: place.image,
        duration: place.duration,
        type: 'destination',
        note: place.description,
        costPerPerson: place.entryFee,
      ));
      totalCost += place.entryFee * prefs.people;
      highlights.add(place.name);
    }

    // Accommodation
    final acc = _accForProvince(province, tier);
    if (acc != null) {
      final nightCost = (acc['pricePerNight'] as double);
      stops.add(TripStop(
        id: acc['id'] as String,
        name: acc['name'] as String,
        location: province,
        image: acc['image'] as String,
        duration: '1 night',
        type: 'stay',
        note: 'AI Pick — ${acc['rating']}★ · ${tier[0].toUpperCase()}${tier.substring(1)} tier',
        costPerPerson: nightCost,
      ));
      totalCost += nightCost; // per room, not per person
    }

    days.add(ItineraryDay(
      day: dayNum + 1,
      date: date,
      title: province == 'Kigali City' && dayNum == 0
          ? 'Arrival · Kigali'
          : _dayTitle(province, places),
      province: province,
      stops: stops,
    ));

    dayNum++;
  }

  // Fill remaining days if selected places < days
  while (dayNum < prefs.days) {
    final date = prefs.startDate.add(Duration(days: dayNum));
    days.add(ItineraryDay(
      day: dayNum + 1,
      date: date,
      title: dayNum == prefs.days - 1 ? 'Departure Day' : 'Free Day · Kigali',
      province: 'Kigali City',
      stops: [
        TripStop(
          id: 'free_$dayNum',
          name: dayNum == prefs.days - 1 ? 'Departure from Kigali Airport' : 'Free time in Kigali',
          location: 'Kigali',
          image: 'https://images.unsplash.com/photo-1523805009345-7448845a9e53?q=80&w=600&fit=crop',
          duration: dayNum == prefs.days - 1 ? 'Departure' : 'Full day',
          type: 'transport',
        ),
      ],
    ));
    dayNum++;
  }

  return TripPlan(
    id: 'plan_${DateTime.now().millisecondsSinceEpoch}',
    prefs: prefs,
    days: days,
    estimatedCost: totalCost,
    highlights: highlights.take(5).toList(),
    accommodationNote: 'AI auto-selected ${tier} tier accommodation for each stop.',
  );
}

String _dayTitle(String province, List<ProposedPlace> places) {
  if (places.isEmpty) return province;
  if (places.length == 1) return '${places.first.name} · $province';
  return '$province · ${places.length} stops';
}

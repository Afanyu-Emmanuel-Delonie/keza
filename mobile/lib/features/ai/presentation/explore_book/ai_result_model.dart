import '../../../trips/domain/entities/trip_entities.dart';

enum ResultType { destination, accommodation }

class AiResult {
  final String id;
  final String name;
  final String location;
  final String image;
  final String price;
  final String priceLabel;
  final String rating;
  final String reviews;
  final ResultType type;
  final String? tag;

  const AiResult({
    required this.id,
    required this.name,
    required this.location,
    required this.image,
    required this.price,
    required this.priceLabel,
    required this.rating,
    required this.reviews,
    required this.type,
    this.tag,
  });

  TripItem toTripItem() => TripItem(
        id: id,
        name: name,
        location: location,
        province: _inferProvince(location),
        image: image,
        price: price,
        rating: rating,
        isAccommodation: type == ResultType.accommodation,
      );

  static String _inferProvince(String location) {
    final l = location.toLowerCase();
    if (l.contains('kigali')) return 'Kigali City';
    if (l.contains('musanze') || l.contains('volcanoes')) return 'Northern Province';
    if (l.contains('rubavu') || l.contains('kivu') || l.contains('gisenyi')) return 'Western Province';
    if (l.contains('akagera') || l.contains('kayonza')) return 'Eastern Province';
    if (l.contains('huye') || l.contains('nyungwe')) return 'Southern Province';
    return 'Kigali City';
  }
}

// ── Static destination data ───────────────────────────────────────────────────
const kDestinationResults = [
  AiResult(
    id: 'dest_0',
    name: 'Volcanoes National Park',
    location: 'Musanze, Northern Province',
    image: 'https://images.unsplash.com/photo-1516426122078-c23e76319801?q=80&w=600&fit=crop',
    price: '\$1,500',
    priceLabel: 'per person',
    rating: '5.0',
    reviews: '432',
    type: ResultType.destination,
    tag: 'AI Pick',
  ),
  AiResult(
    id: 'dest_1',
    name: 'Golden Monkey Trek',
    location: 'Volcanoes National Park',
    image: 'https://images.unsplash.com/photo-1547471080-7cc2caa01a7e?q=80&w=600&fit=crop',
    price: '\$100',
    priceLabel: 'per person',
    rating: '4.7',
    reviews: '189',
    type: ResultType.destination,
    tag: 'Popular',
  ),
  AiResult(
    id: 'dest_2',
    name: 'Lake Kivu Boat Tour',
    location: 'Rubavu, Western Province',
    image: 'https://images.unsplash.com/photo-1501785888041-af3ef285b470?q=80&w=600&fit=crop',
    price: '\$35',
    priceLabel: 'per person',
    rating: '4.6',
    reviews: '210',
    type: ResultType.destination,
  ),
  AiResult(
    id: 'dest_3',
    name: 'Kigali Genocide Memorial',
    location: 'Gisozi, Kigali',
    image: 'https://images.unsplash.com/photo-1579208575657-c595a05383b7?q=80&w=600&fit=crop',
    price: 'Free',
    priceLabel: 'entry',
    rating: '4.9',
    reviews: '876',
    type: ResultType.destination,
  ),
];

const kAccommodationResults = [
  AiResult(
    id: 'acc_0',
    name: 'Five Volcanoes Boutique Hotel',
    location: 'Musanze, Northern Province',
    image: 'https://images.unsplash.com/photo-1566073771259-6a8506099945?q=80&w=600&fit=crop',
    price: '\$120',
    priceLabel: 'per night',
    rating: '4.8',
    reviews: '214',
    type: ResultType.accommodation,
    tag: 'AI Pick',
  ),
  AiResult(
    id: 'acc_1',
    name: 'Sabyinyo Silverback Lodge',
    location: 'Kinigi, Northern Province',
    image: 'https://images.unsplash.com/photo-1520250497591-112f2f40a3f4?q=80&w=600&fit=crop',
    price: '\$350',
    priceLabel: 'per night',
    rating: '4.9',
    reviews: '98',
    type: ResultType.accommodation,
    tag: 'Luxury',
  ),
  AiResult(
    id: 'acc_2',
    name: 'Mountain Gorilla View Lodge',
    location: 'Musanze, Northern Province',
    image: 'https://images.unsplash.com/photo-1582719508461-905c673771fd?q=80&w=600&fit=crop',
    price: '\$85',
    priceLabel: 'per night',
    rating: '4.6',
    reviews: '156',
    type: ResultType.accommodation,
    tag: 'Best Value',
  ),
  AiResult(
    id: 'acc_3',
    name: 'Lake Kivu Serena Hotel',
    location: 'Rubavu, Western Province',
    image: 'https://images.unsplash.com/photo-1540541338287-41700207dee6?q=80&w=600&fit=crop',
    price: '\$150',
    priceLabel: 'per night',
    rating: '4.8',
    reviews: '301',
    type: ResultType.accommodation,
  ),
];

// ── Simulate search ───────────────────────────────────────────────────────────
({String summary, List<AiResult> destinations}) simulateSearch(String query) {
  final q = query.toLowerCase();
  List<AiResult> dests;
  String summary;

  if (q.contains('gorilla') || q.contains('volcanoes') || q.contains('musanze')) {
    dests = kDestinationResults.where((d) =>
        d.location.toLowerCase().contains('musanze') ||
        d.location.toLowerCase().contains('volcanoes')).toList();
    summary = 'Found ${dests.length} experiences near Volcanoes National Park.';
  } else if (q.contains('kigali')) {
    dests = kDestinationResults.where((d) => d.location.toLowerCase().contains('kigali')).toList();
    summary = 'Found ${dests.length} things to do in Kigali.';
  } else if (q.contains('lake') || q.contains('kivu')) {
    dests = kDestinationResults.where((d) => d.location.toLowerCase().contains('kivu') || d.location.toLowerCase().contains('rubavu')).toList();
    summary = 'Found ${dests.length} experiences around Lake Kivu.';
  } else {
    dests = kDestinationResults;
    summary = 'Here are ${dests.length} top destinations in Rwanda for you.';
  }

  if (dests.isEmpty) dests = kDestinationResults;
  return (summary: summary, destinations: dests);
}

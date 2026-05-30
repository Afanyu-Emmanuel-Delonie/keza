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

enum TripPace { relaxed, balanced, adventurous }
enum TripPlanType { value, balanced, premium }
enum TripTransportStyle { sharedVehicle, selfDrive, airportPickup }
enum TripStayStyle { recommended, ownStay, premium }

class TripPlanningProfile {
  final int people;
  final double budget;
  final int days;
  final TripPace pace;
  final TripTransportStyle transportStyle;
  final TripStayStyle stayStyle;
  final List<String> interests;
  final String notes;

  const TripPlanningProfile({
    required this.people,
    required this.budget,
    required this.days,
    required this.pace,
    required this.transportStyle,
    required this.stayStyle,
    required this.interests,
    required this.notes,
  });

  const TripPlanningProfile.defaults()
      : people = 2,
        budget = 600,
        days = 3,
        pace = TripPace.balanced,
        transportStyle = TripTransportStyle.sharedVehicle,
        stayStyle = TripStayStyle.recommended,
        interests = const ['Culture', 'Nature'],
        notes = '';

  TripPlanningProfile copyWith({
    int? people,
    double? budget,
    int? days,
    TripPace? pace,
    TripTransportStyle? transportStyle,
    TripStayStyle? stayStyle,
    List<String>? interests,
    String? notes,
  }) {
    return TripPlanningProfile(
      people: people ?? this.people,
      budget: budget ?? this.budget,
      days: days ?? this.days,
      pace: pace ?? this.pace,
      transportStyle: transportStyle ?? this.transportStyle,
      stayStyle: stayStyle ?? this.stayStyle,
      interests: interests ?? this.interests,
      notes: notes ?? this.notes,
    );
  }
}

class TripDayPlan {
  final int dayNumber;
  final String title;
  final String province;
  final String summary;
  final List<TripItem> stops;
  final String stayNote;
  final double estimatedCost;

  const TripDayPlan({
    required this.dayNumber,
    required this.title,
    required this.province,
    required this.summary,
    required this.stops,
    required this.stayNote,
    required this.estimatedCost,
  });
}

class TripPlanOption {
  final TripPlanType type;
  final String name;
  final String description;
  final String fitNote;
  final String transportNote;
  final String stayNote;
  final double estimatedCost;
  final bool withinBudget;
  final List<TripDayPlan> days;

  const TripPlanOption({
    required this.type,
    required this.name,
    required this.description,
    required this.fitNote,
    required this.transportNote,
    required this.stayNote,
    required this.estimatedCost,
    required this.withinBudget,
    required this.days,
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
  final bool airportPickup;
  final bool tourGuideRequested;
  final PaymentMethod paymentMethod;

  const BookedTrip({
    required this.id,
    required this.name,
    required this.location,
    required this.image,
    required this.price,
    required this.bookingDate,
    required this.travelDate,
    required this.status,
    this.airportPickup = false,
    this.tourGuideRequested = false,
    this.paymentMethod = PaymentMethod.payNow,
  });
}

class TripGroup {
  final String id;
  final String name;
  final int memberCount;

  const TripGroup({
    required this.id,
    required this.name,
    required this.memberCount,
  });
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
enum PaymentMethod { payNow, payOnArrival }

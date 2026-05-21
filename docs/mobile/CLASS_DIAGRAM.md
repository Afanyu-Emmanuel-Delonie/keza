# Mobile — Class & Domain Diagrams

All diagrams use [Mermaid](https://mermaid.js.org/) syntax.  
Render in GitHub, VS Code (Mermaid extension), or https://mermaid.live

---

## 1. Core Domain Entity Diagram

```mermaid
classDiagram

    class TripItem {
        +String id
        +String name
        +String location
        +String province
        +String image
        +String price
        +String rating
        +bool isAccommodation
    }

    class TripPlanningProfile {
        +int people
        +double budget
        +int days
        +TripPace pace
        +TripTransportStyle transportStyle
        +TripStayStyle stayStyle
        +List~String~ interests
        +String notes
        +copyWith() TripPlanningProfile
    }

    class TripDayPlan {
        +int dayNumber
        +String title
        +String province
        +String summary
        +List~TripItem~ stops
        +String stayNote
        +double estimatedCost
    }

    class TripPlanOption {
        +TripPlanType type
        +String name
        +String description
        +String fitNote
        +String transportNote
        +String stayNote
        +double estimatedCost
        +bool withinBudget
        +List~TripDayPlan~ days
    }

    class BookedTrip {
        +String id
        +String name
        +String location
        +String image
        +String price
        +String bookingDate
        +String travelDate
        +BookingStatus status
    }

    class AccommodationBooking {
        +TripItem item
        +DateTime checkIn
        +DateTime checkOut
        +int guests
        +String roomType
        +String? notes
        +int nights
        +double totalCost
    }

    class TourGuide {
        +String id
        +String name
        +String specialty
        +String province
        +String image
        +String pricePerDay
        +String rating
        +List~String~ languages
        +bool needsManualConfirmation
        +double dailyRate
    }

    class GuideBooking {
        +TourGuide guide
        +DateTime date
        +int days
        +GuideBookingStatus status
        +double totalCost
        +copyWith() GuideBooking
    }

    class TripGroup {
        +String id
        +String name
        +int memberCount
    }

    TripPlanOption "1" --> "many" TripDayPlan : contains
    TripDayPlan "1" --> "many" TripItem : stops
    AccommodationBooking "1" --> "1" TripItem : item
    GuideBooking "1" --> "1" TourGuide : guide
```

---

## 2. AI Trip Builder Domain

```mermaid
classDiagram

    class TripPrefs {
        +DateTime startDate
        +DateTime endDate
        +double budget
        +int people
        +List~String~ interests
        +int days
        +double budgetPerPerson
    }

    class ProposedPlace {
        +String id
        +String name
        +String location
        +String province
        +String image
        +String category
        +double entryFee
        +String duration
        +String description
    }

    class TripStop {
        +String id
        +String name
        +String location
        +String image
        +String duration
        +String type
        +String? note
        +double? costPerPerson
        +String priceLabel
    }

    class ItineraryDay {
        +int day
        +DateTime date
        +String title
        +String province
        +List~TripStop~ stops
        +copyWith() ItineraryDay
    }

    class TripPlan {
        +String id
        +TripPrefs prefs
        +List~ItineraryDay~ days
        +double estimatedCost
        +List~String~ highlights
        +String? accommodationNote
        +bool isOverBudget
        +double overBy
        +copyWith() TripPlan
    }

    TripPlan "1" --> "1" TripPrefs : prefs
    TripPlan "1" --> "many" ItineraryDay : days
    ItineraryDay "1" --> "many" TripStop : stops
```

---

## 3. Repository Pattern

```mermaid
classDiagram

    class TripsRepository {
        <<interface>>
        +isAccommodationLiked(id) bool
        +allBookings Map
        +allGuideBookings Map
        +favourites List
        +addedTrips List
        +bookedTrips List
        +planOptions List
        +grandTotal double
        +tripReadiness TripReadiness
        +toggleFavourite(item)
        +confirmAccommodationBooking(booking)
        +confirmGuideBooking(booking)
        +updateTripProfile(profile)
    }

    class InMemoryTripsRepository {
        -Set _likedAccommodationIds
        -Map _bookings
        -Map _guideBookings
        -List _favourites
        -List _addedTrips
        -List _bookedTrips
        -TripPlanningProfile _tripProfile
        +_buildPlanOptions() List
        +_buildDayPlans() List
    }

    class RemoteTripsRepository {
        -Dio _dio
        +fetchFavourites() Future
        +syncBooking(booking) Future
        +fetchPlanOptions() Future
    }

    class TripsProvider {
        -TripsRepository _repository
        +notifyListeners()
        +toggleFavourite(item)
        +confirmAccommodationBooking(booking)
        +grandTotal double
    }

    TripsRepository <|.. InMemoryTripsRepository : implements
    TripsRepository <|.. RemoteTripsRepository : implements
    TripsProvider --> TripsRepository : uses
```

---

## 4. Auth Flow

```mermaid
classDiagram

    class AuthRepository {
        <<interface>>
        +isAuthenticated bool
        +hasSeenOnboarding bool
        +loginWithEmail(email, password) Future
        +registerWithEmail(name, email, password) Future
        +loginWithGoogle() Future
        +loginWithFacebook() Future
        +loginWithApple() Future
        +forgotPassword(email) Future
        +logout() Future
        +markOnboardingSeen() Future
    }

    class InMemoryAuthRepository {
        -bool _isAuthenticated
        -bool _hasSeenOnboarding
    }

    class RemoteAuthRepository {
        -Dio _dio
        -SharedPreferences _prefs
        +_saveToken(token) Future
        +_clearToken() Future
    }

    class AuthProvider {
        -AuthRepository _repository
        +AuthStatus status
        +String? error
        +bool isLoading
        +loginWithEmail() Future~bool~
        +registerWithEmail() Future~bool~
        +logout() Future
    }

    AuthRepository <|.. InMemoryAuthRepository : implements
    AuthRepository <|.. RemoteAuthRepository : implements
    AuthProvider --> AuthRepository : uses
```

---

## 5. Enumerations

```mermaid
classDiagram

    class TripPace {
        <<enumeration>>
        relaxed
        balanced
        adventurous
    }

    class TripPlanType {
        <<enumeration>>
        value
        balanced
        premium
    }

    class TripTransportStyle {
        <<enumeration>>
        sharedVehicle
        selfDrive
        airportPickup
    }

    class TripStayStyle {
        <<enumeration>>
        recommended
        ownStay
        premium
    }

    class BookingStatus {
        <<enumeration>>
        pending
        confirmed
        completed
    }

    class GuideBookingStatus {
        <<enumeration>>
        pending
        confirmed
    }

    class TripReadiness {
        <<enumeration>>
        incomplete
        awaitingConfirmation
        ready
    }

    class AuthStatus {
        <<enumeration>>
        idle
        loading
        success
        error
    }
```

---

## 6. Navigation & Screen Hierarchy

```mermaid
graph TD
    A[SplashScreen] --> B{hasSeenOnboarding?}
    B -- No --> C[OnboardingScreen]
    B -- Yes --> D{isAuthenticated?}
    C --> D
    D -- No --> E[LoginScreen]
    E --> F[RegisterScreen]
    E --> G[ForgotPasswordScreen]
    D -- Yes --> H[NavigationPage]
    H --> H0[HomeScreen]
    H --> H1[ExploreScreen]
    H --> H2[TripsScreen]
    H --> H3[AiScreen]
    H --> H4[ProfileScreen]
    H0 --> I[DestinationDetails]
    H0 --> J[AccommodationDetails]
    H0 --> K[AiTripBuilderScreen]
    H1 --> L[ProvincePlacesScreen]
    H2 --> M[TripPlannerPage]
    M --> N[CheckoutPage]
    H3 --> O[ExploreBookAiScreen]
    H3 --> K
    H3 --> P[GeneralChatScreen]
```

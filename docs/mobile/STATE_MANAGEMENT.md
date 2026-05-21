# Mobile — State Management

## Overview

State is managed with Flutter's `Provider` package (`ChangeNotifier`).  
Two top-level providers cover the entire app:

| Provider | Scope | Backed by |
|---|---|---|
| `AuthProvider` | Global | `AuthRepository` |
| `TripsProvider` | Global | `TripsRepository` |

---

## AuthProvider

**File:** `features/auth/providers/auth_provider.dart`

### State fields

| Field | Type | Description |
|---|---|---|
| `isAuthenticated` | `bool` | Whether a user session exists |
| `hasSeenOnboarding` | `bool` | Controls onboarding gate |
| `status` | `AuthStatus` | `idle / loading / success / error` |
| `error` | `String?` | Last error message |

### Actions

| Method | Description |
|---|---|
| `loginWithEmail(email, password)` | Email/password login |
| `registerWithEmail(name, email, password)` | New account |
| `loginWithGoogle()` | OAuth via Google |
| `loginWithFacebook()` | OAuth via Facebook |
| `loginWithApple()` | OAuth via Apple |
| `forgotPassword(email)` | Send reset email |
| `logout()` | Clear session |
| `markOnboardingSeen()` | Persist onboarding flag |

### Current implementation
`InMemoryAuthRepository` — stores state in memory only.  
**Replace with** `RemoteAuthRepository` backed by the real API.

---

## TripsProvider

**File:** `features/trips/providers/trips_provider.dart`

### State fields

| Field | Type | Description |
|---|---|---|
| `favourites` | `List<TripItem>` | Liked destinations & stays |
| `addedTrips` | `List<TripItem>` | Items added to the trip planner |
| `selectedIds` | `Set<String>` | IDs selected for active planning |
| `selectedTrips` | `List<TripItem>` | Filtered from addedTrips by selectedIds |
| `allBookings` | `Map<String, AccommodationBooking>` | Keyed by province |
| `allGuideBookings` | `Map<String, GuideBooking>` | Keyed by province |
| `bookedTrips` | `List<BookedTrip>` | Confirmed trip bookings |
| `myGroups` | `List<TripGroup>` | User's trip groups |
| `activeGroup` | `TripGroup?` | Currently selected group |
| `tourGuidesByProvince` | `Map<String, List<TourGuide>>` | Guide catalogue |
| `tripProfile` | `TripPlanningProfile` | User's planning preferences |
| `selectedPlanType` | `TripPlanType` | value / balanced / premium |
| `planOptions` | `List<TripPlanOption>` | Computed plan options |
| `selectedPlan` | `TripPlanOption?` | Active plan option |

### Computed cost fields

| Field | Description |
|---|---|
| `selectedTripCost` | Sum of selected destination prices |
| `totalAccommodationCost` | Sum of all accommodation bookings |
| `totalGuideCost` | Sum of all guide bookings |
| `serviceFee` | 5% of (accommodation + trip + guide) |
| `grandTotal` | All costs combined |
| `tripReadiness` | `incomplete / awaitingConfirmation / ready` |

### Key actions

| Method | Description |
|---|---|
| `toggleFavourite(item)` | Add/remove from favourites |
| `toggleAddTrip(item)` | Add/remove from trip planner |
| `toggleSelected(id)` | Select/deselect for active planning |
| `confirmAccommodationBooking(booking)` | Save accommodation booking |
| `cancelAccommodationBooking(province)` | Remove booking |
| `confirmGuideBooking(booking)` | Save guide booking |
| `markGuideConfirmed(province)` | Update guide status to confirmed |
| `addBookedTrip(trip)` | Add to booked trips list |
| `updateTripProfile(profile)` | Update planning preferences |
| `selectPlanType(type)` | Switch between value/balanced/premium |
| `createGroup(name)` | Create a new trip group |

---

## Data Flow Pattern

```
Widget
  │
  ├── context.read<TripsProvider>().someAction()   ← write
  │
  └── Consumer<TripsProvider>(                     ← read (reactive)
        builder: (context, provider, _) { ... }
      )
```

---

## What needs to change when connecting to the backend

1. Replace `InMemoryAuthRepository` with `RemoteAuthRepository` (Dio-based).
2. Replace `InMemoryTripsRepository` with `RemoteTripsRepository`.
3. Add a `UserProvider` for profile data (name, avatar, preferences).
4. Add a `NotificationsProvider` for push notification state.
5. Persist `favourites` and `addedTrips` to the API instead of memory.

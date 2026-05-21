# Mobile — Screens & Navigation Flows

## Bottom Navigation Tabs

| Index | Tab | Screen |
|---|---|---|
| 0 | Home | HomeScreen |
| 1 | Explore | ExploreScreen |
| 2 | Trips | TripsScreen |
| 3 | Keza AI | AiScreen |
| 4 | Profile | ProfileScreen |

---

## Auth Flow

```
App Launch
  └── SplashScreen (2 s)
        ├── !hasSeenOnboarding  → OnboardingScreen
        │     └── "Get Started" → LoginScreen
        ├── !isAuthenticated    → LoginScreen
        │     ├── "Register"    → RegisterScreen
        │     └── "Forgot"      → ForgotPasswordScreen
        └── isAuthenticated     → NavigationPage (Home tab)
```

---

## Home Tab

```
HomeScreen
  ├── Search bar (tappable) → opens search popup dialog
  ├── AI CTA card           → AiTripBuilderScreen
  ├── Category chips        → filters Recommended & Featured Stay lists
  ├── Recommended card      → DestinationDetails
  │     └── "Add to Trip"   → adds to TripsProvider
  ├── Featured Stay card    → AccommodationDetails
  │     └── "+ Book"        → BookingFormSheet (bottom sheet)
  │           └── confirm   → AccommodationBooking saved to provider
  └── "Explore More" / "See all" → AllDestinationsScreen / AllStaysScreen
```

---

## Explore Tab

```
ExploreScreen
  ├── Search button         → _SearchPopup dialog (live filter)
  ├── AI Discovery banner   → GeneralChatScreen
  ├── Province grid card    → ProvincePlacesScreen
  │     └── Destination row → DestinationDetails
  ├── Category chips        → filters Top Destinations list
  └── Top Destinations list → DestinationDetails
```

---

## Trips Tab

```
TripsScreen  (3 tabs)
  ├── My Trip tab
  │     ├── TripPlannerPage  (/plan)
  │     │     ├── Destination section  — add/remove destinations
  │     │     ├── Accommodation section — book per province
  │     │     ├── Transport section    — select transport style
  │     │     └── Pricing section      — cost breakdown
  │     └── Checkout bar → CheckoutPage (/checkout)
  │           ├── Plan options (Value / Balanced / Premium)
  │           └── Payment sheet → booking confirmed
  ├── Favourites tab
  │     └── Liked destinations & accommodations
  └── Booked tab
        └── BookedTrip list with status badges
```

---

## AI Tab

```
AiScreen
  ├── "Explore & Book with AI" → ExploreBookAiScreen
  │     ├── Idle state  — prompt input bar
  │     └── Results state — AI result cards with book actions
  ├── "AI Trip Builder"        → AiTripBuilderScreen  (5-step wizard)
  │     ├── Step 1: TripBuilderPrefsStep   — dates, budget, people, interests
  │     ├── Step 2: Loading (1.8 s)        — "Finding matching places..."
  │     ├── Step 3: TripBuilderPlacesStep  — select proposed destinations
  │     ├── Step 4: Loading (2.2 s)        — "Building your itinerary..."
  │     ├── Step 5: TripBuilderItineraryStep — day-by-day plan, customise stops
  │     └── Step 6: TripBuilderCheckoutStep — cost summary, confirm & book
  │           └── "Confirm & Book" → pops to NavigationPage, jumps to AI tab
  │                                   shows "We'll notify you" snackbar
  └── "General Chat"           → GeneralChatScreen
        └── Free-form Q&A about Rwanda travel
```

---

## Profile Tab

```
ProfileScreen
  ├── Edit Profile       → EditProfilePage
  ├── Interests          → InterestsPage
  ├── Travel Style       → TravelStylePage
  ├── Budget Range       → BudgetRangePage
  ├── Notifications      → NotificationsPage (profile)
  ├── Language           → LanguagePage
  ├── Change Password    → ChangePasswordPage
  ├── Privacy Policy     → PrivacyPolicyPage
  ├── Help & FAQ         → HelpFaqPage
  └── About              → AboutPage
```

---

## Key Shared Sheets & Dialogs

| Component | Trigger | Purpose |
|---|---|---|
| `BookingFormSheet` | "+ Book" on any accommodation | Collect check-in/out, guests, room type |
| `PaymentSheet` | Checkout confirm | Payment method selection & final confirm |
| `ItinerarySummarySheet` | Trip planner summary | Full itinerary overview before checkout |
| `_SearchPopup` | Search button on Explore | Live search across destinations |

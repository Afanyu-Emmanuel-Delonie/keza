# Mobile — Architecture

## Stack

| Concern | Choice |
|---|---|
| Framework | Flutter (Dart) |
| Min SDK | Android 21 / iOS 13 |
| State management | Provider (`ChangeNotifier`) |
| Routing | go_router |
| HTTP client | Dio |
| Local storage | SharedPreferences |
| Image caching | cached_network_image |
| Auth | Google Sign-In, Apple Sign-In, Facebook Auth |
| UI scaling | flutter_screenutil |

---

## Folder Structure

```
lib/
├── app/
│   ├── dependency_injection/   — Provider wiring (initialised in main.dart)
│   ├── router/                 — GoRouter config & route constants
│   └── app.dart                — MaterialApp root
│
├── core/
│   ├── constants/              — AppConstants (categories, provinces, destinations)
│   ├── theme/                  — AppColors, AppTheme
│   ├── utils/                  — Shared utilities (trip_snackbar)
│   └── widgets/                — Reusable core widgets (Skeleton, AnimatedCardItem)
│
├── features/
│   ├── auth/                   — Login, Register, Onboarding, Forgot Password
│   ├── home_screen/            — Home feed, Accommodation & Destination details
│   ├── explore/                — Province browser, destination search
│   ├── trips/                  — Trip planner, bookings, favourites, checkout
│   ├── ai/                     — AI chat, Explore & Book AI, AI Trip Builder
│   ├── profile/                — User profile, preferences, settings
│   ├── notifications/          — Notifications page
│   └── navigation/             — Bottom navigation shell
│
└── shared/
    └── widgets/                — App bar, search bar, category chips, AI card
```

---

## Layered Architecture (per feature)

Each feature follows a clean-architecture-inspired layering:

```
feature/
├── domain/
│   ├── entities/       — Pure Dart data classes (no Flutter deps)
│   └── repositories/   — Abstract repository interfaces
├── data/
│   ├── datasources/    — Local or remote data sources
│   └── repositories/   — Concrete implementations of domain interfaces
├── presentation/
│   ├── screens/        — Full-page widgets
│   └── widgets/        — Feature-scoped reusable widgets
└── providers/          — ChangeNotifier providers (bridge domain ↔ UI)
```

> Currently the `auth` and `trips` features are fully layered.  
> `home_screen`, `explore`, `ai`, and `profile` are presentation-only (data is hardcoded in `AppConstants` or local models — to be replaced by API calls).

---

## Dependency Injection

Providers are initialised in `main.dart` using `MultiProvider`:

```
AuthProvider  ←  InMemoryAuthRepository  (→ replace with RemoteAuthRepository)
TripsProvider ←  InMemoryTripsRepository (→ replace with RemoteTripsRepository)
```

---

## Routing

Routes are defined in `AppRouter` using `go_router`:

| Route | Screen | Guard |
|---|---|---|
| `/splash` | SplashScreen | none |
| `/onboarding` | OnboardingScreen | !hasSeenOnboarding |
| `/login` | LoginScreen | !isAuthenticated |
| `/register` | RegisterScreen | !isAuthenticated |
| `/forgot-password` | ForgotPasswordScreen | !isAuthenticated |
| `/` | NavigationPage (shell) | isAuthenticated |
| `/plan` | TripPlannerPage | isAuthenticated |
| `/checkout` | CheckoutPage | isAuthenticated |

---

## Key Patterns

- **Repository pattern** — UI never touches data sources directly; always goes through a repository interface.
- **Provider + ChangeNotifier** — Each domain area has one provider. Widgets call `context.read<>()` for actions and `context.watch<>()` / `Consumer<>` for reactive rebuilds.
- **Skeleton loading** — `HomeSkeletonScreen` overlays the real content with a 1.6 s shimmer; a 5 s hard timeout shows a "No Internet" fallback.
- **Smooth page transitions** — `SmoothPageRoute` (defined in `animated_card_item.dart`) provides a consistent slide+fade transition across the app.

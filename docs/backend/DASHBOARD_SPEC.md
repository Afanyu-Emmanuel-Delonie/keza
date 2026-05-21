# Backend — Admin Dashboard Specification

This document defines what the admin dashboard must show and manage to support the Keza Tour platform.

---

## Dashboard Sections

### 1. Overview (Home)

Key metrics visible at a glance:

| Metric | Description |
|---|---|
| Total users | All registered accounts |
| New users today / this week | Growth tracking |
| Active trips | Trips currently in `pending` or `confirmed` status |
| Total bookings | Accommodation + guide bookings combined |
| Pending guide confirmations | Guides with `needs_manual_confirmation = true` and status `pending` |
| Revenue this month | Sum of all `totalCost` from confirmed bookings |
| Top destination this week | Most-added destination across all trip planners |
| AI plans generated | Count of `ai_trip_plans` created |

---

### 2. Users

| Feature | Details |
|---|---|
| User list | Paginated table: name, email, joined date, status |
| Search | By name or email |
| User detail | Profile, preferences, bookings, favourites, trip history |
| Suspend / reactivate | Toggle user account status |
| Export | CSV export of user list |

---

### 3. Destinations

| Feature | Details |
|---|---|
| Destination list | Table: name, province, category, rating, price |
| Add destination | Form: name, location, province, images, price, category, description, highlights, coordinates |
| Edit destination | Same form, pre-filled |
| Delete destination | Soft delete (hide from app) |
| Filter | By province, category |
| Image upload | Upload to S3/R2, store URL |

---

### 4. Accommodations

| Feature | Details |
|---|---|
| Accommodation list | Table: name, province, tier, price/night, rating |
| Add / Edit / Delete | Full CRUD with image upload |
| Filter | By province, tier |
| Availability toggle | Mark as available / unavailable |

---

### 5. Tour Guides

| Feature | Details |
|---|---|
| Guide list | Table: name, province, specialty, price/day, rating |
| Add / Edit / Delete | Full CRUD |
| Manual confirmation queue | List of pending guide bookings where `needs_manual_confirmation = true` |
| Confirm booking | PATCH status to `confirmed` → triggers push notification to user |
| Filter | By province, language |

---

### 6. Bookings

#### Accommodation Bookings
| Column | Description |
|---|---|
| User | Name + email |
| Accommodation | Name + province |
| Check-in / Check-out | Dates |
| Guests | Count |
| Total cost | Calculated |
| Status | pending / confirmed / completed / cancelled |
| Actions | Confirm, Cancel, View detail |

#### Guide Bookings
| Column | Description |
|---|---|
| User | Name + email |
| Guide | Name + province |
| Start date | Date |
| Days | Count |
| Total cost | Calculated |
| Status | pending / confirmed |
| Actions | Confirm (manual), Cancel |

#### Booked Trips
| Column | Description |
|---|---|
| User | Name + email |
| Trip name | String |
| Travel date | Date |
| Price | String |
| Status | pending / confirmed / completed |
| Actions | Update status |

---

### 7. AI Trip Plans

| Feature | Details |
|---|---|
| Plan list | Table: user, created date, estimated cost, days count |
| Plan detail | Full JSON view of the generated itinerary |
| Stats | Total plans generated, average cost, most common interests |

---

### 8. Notifications

| Feature | Details |
|---|---|
| Send push notification | Select users (all / by province / individual), write title + body, select type |
| Notification history | List of all sent notifications with read rates |
| Promo campaigns | Schedule and send marketing notifications |

---

### 9. Analytics

| Chart | Description |
|---|---|
| User growth | Line chart: new users per day/week/month |
| Bookings over time | Bar chart: accommodation + guide bookings per week |
| Top destinations | Bar chart: most-added destinations across all trip planners |
| Revenue | Line chart: total booking revenue per month |
| Province popularity | Pie chart: which provinces appear most in trip plans |
| AI usage | Line chart: AI chat messages + plan generations per day |
| Plan type distribution | Pie chart: value vs balanced vs premium selections |

---

### 10. Settings

| Setting | Description |
|---|---|
| Service fee % | Currently 5% — configurable |
| Plan type multipliers | value / balanced / premium cost multipliers |
| Accommodation tier rates | Base rates per tier used in plan options engine |
| Transport rates | Base rates per transport style |
| Guide rates | Base rates per plan type |
| App version management | Force update flags per platform |
| Maintenance mode | Toggle to show maintenance screen in app |

---

## Key Dashboard Priorities for Backend Dev

These are the most critical things to build first to unblock the mobile app:

1. **Guide confirmation queue** — The mobile app shows `TripReadiness.awaitingConfirmation` when a guide booking is pending manual confirmation. The dashboard must let admins confirm these.

2. **Booking status webhooks** — When an admin confirms a booking, the backend must send a push notification (FCM) to the user. This is what the "We'll notify you when booking is confirmed" message in the app refers to.

3. **Destination & accommodation CRUD** — The mobile app currently uses hardcoded data from `AppConstants`. Once the API is live, this data must come from the database.

4. **Plan options engine** — The cost calculation logic in `InMemoryTripsRepository` must be replicated server-side so plan options are consistent and configurable without app updates.

5. **AI endpoints** — `/ai/proposed-places` and `/ai/generate-plan` are the core of the AI Trip Builder feature. These must be backed by OpenAI with structured output parsing.

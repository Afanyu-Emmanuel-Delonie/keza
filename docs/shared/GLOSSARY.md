# Shared — Glossary

Common terms used across mobile, backend, web, and dashboard.

| Term | Definition |
|---|---|
| **TripItem** | A single destination or accommodation that a user can add to their trip planner. Has `id`, `name`, `location`, `province`, `image`, `price`, `rating`, `isAccommodation`. |
| **Trip Planner** | The feature where users build a custom trip by adding destinations and accommodations, then generating a plan. |
| **Plan Option** | One of three generated trip plans (Value Explorer, Balanced Journey, Signature Escape) with cost breakdown and day-by-day itinerary. |
| **TripPlanType** | Enum: `value`, `balanced`, `premium`. Controls cost multipliers and accommodation/transport tier. |
| **TripPace** | Enum: `relaxed`, `balanced`, `adventurous`. Affects guide cost and day pacing. |
| **TripTransportStyle** | Enum: `sharedVehicle`, `selfDrive`, `airportPickup`. Affects transport cost. |
| **TripStayStyle** | Enum: `recommended`, `ownStay`, `premium`. Affects accommodation cost. |
| **AccommodationBooking** | A confirmed booking for a specific accommodation with check-in/out dates, guests, and room type. Keyed by province. |
| **GuideBooking** | A booking for a tour guide for a specific date and number of days. |
| **TourGuide** | A licensed guide with a province, specialty, daily rate, and languages. Some require manual confirmation. |
| **Manual Confirmation** | When `TourGuide.needsManualConfirmation = true`, the guide booking stays in `pending` status until an admin confirms it in the dashboard. |
| **TripReadiness** | Enum: `incomplete` (no bookings), `awaitingConfirmation` (pending guide), `ready` (all confirmed). |
| **BookedTrip** | A finalised trip record created after checkout. Has a `status` of `pending`, `confirmed`, or `completed`. |
| **TripGroup** | A named group of users planning a trip together. |
| **AI Trip Builder** | A 5-step wizard where the user inputs preferences, selects proposed places, and receives a full AI-generated day-by-day itinerary. |
| **ProposedPlace** | A destination suggested by the AI based on the user's interests. Has `category`, `entryFee`, `duration`. |
| **TripStop** | A single stop within an itinerary day. Type is `destination`, `stay`, or `transport`. |
| **ItineraryDay** | One day in an AI-generated trip plan. Contains a list of `TripStop` objects. |
| **TripPlan** | The full AI-generated itinerary. Contains `TripPrefs`, a list of `ItineraryDay`, estimated cost, and highlights. |
| **TripPrefs** | User inputs for the AI Trip Builder: start/end dates, budget, people count, interests. |
| **Service Fee** | 5% of (accommodation cost + trip cost + guide cost). Applied at checkout. |
| **Grand Total** | accommodation + trip + guide + service fee. |
| **Province** | One of Rwanda's 5 administrative regions: Kigali City, Northern, Southern, Eastern, Western Province. |
| **Tier** | Accommodation quality level: `budget`, `mid`, `luxury`. |
| **Skeleton** | A shimmer loading placeholder shown while the home screen content loads. Times out after 5 seconds and shows a "No Internet" state. |
| **Partner** | A hospitality provider (hotel, lodge, tour operator) who lists their services on the platform. |
| **Dashboard** | The admin web interface for managing the platform: users, listings, bookings, guide confirmations, analytics. |

# Backend — Data Models & Database Schema

Derived from the mobile domain entities in `trip_entities.dart` and `trip_builder_model.dart`.

---

## Entity Relationship Diagram

```mermaid
erDiagram

    USERS {
        uuid id PK
        string name
        string email
        string password_hash
        string avatar_url
        string language
        bool notifications_enabled
        timestamp created_at
        timestamp updated_at
    }

    USER_PREFERENCES {
        uuid id PK
        uuid user_id FK
        string[] interests
        string travel_style
        float budget_min
        float budget_max
        string pace
        string transport_style
        string stay_style
    }

    DESTINATIONS {
        uuid id PK
        string name
        string location
        string province
        string[] images
        string price
        float rating
        int review_count
        string category
        string description
        string[] highlights
        string opening_hours
        float lat
        float lng
        timestamp created_at
    }

    ACCOMMODATIONS {
        uuid id PK
        string name
        string location
        string province
        string[] images
        float price_per_night
        float rating
        int review_count
        string tier
        string[] room_types
        string[] amenities
        float lat
        float lng
        timestamp created_at
    }

    TOUR_GUIDES {
        uuid id PK
        string name
        string specialty
        string province
        string image
        float price_per_day
        float rating
        string[] languages
        bool needs_manual_confirmation
        timestamp created_at
    }

    FAVOURITES {
        uuid id PK
        uuid user_id FK
        string item_id
        string item_type
        timestamp created_at
    }

    TRIP_ITEMS {
        uuid id PK
        uuid user_id FK
        string item_id
        string name
        string location
        string province
        string image
        string price
        string rating
        bool is_accommodation
        bool is_selected
        timestamp added_at
    }

    ACCOMMODATION_BOOKINGS {
        uuid id PK
        uuid user_id FK
        uuid accommodation_id FK
        date check_in
        date check_out
        int guests
        string room_type
        string notes
        float total_cost
        string status
        timestamp created_at
    }

    GUIDE_BOOKINGS {
        uuid id PK
        uuid user_id FK
        uuid guide_id FK
        date start_date
        int days
        float total_cost
        string status
        timestamp created_at
    }

    BOOKED_TRIPS {
        uuid id PK
        uuid user_id FK
        string name
        string location
        string image
        string price
        date booking_date
        date travel_date
        string status
        timestamp created_at
    }

    TRIP_GROUPS {
        uuid id PK
        uuid owner_id FK
        string name
        int member_count
        timestamp created_at
    }

    TRIP_GROUP_MEMBERS {
        uuid id PK
        uuid group_id FK
        uuid user_id FK
        timestamp joined_at
    }

    NOTIFICATIONS {
        uuid id PK
        uuid user_id FK
        string title
        string body
        string type
        bool read
        timestamp created_at
    }

    AI_TRIP_PLANS {
        uuid id PK
        uuid user_id FK
        json prefs
        json days
        float estimated_cost
        string[] highlights
        string accommodation_note
        timestamp created_at
    }

    USERS ||--o{ USER_PREFERENCES : has
    USERS ||--o{ FAVOURITES : saves
    USERS ||--o{ TRIP_ITEMS : plans
    USERS ||--o{ ACCOMMODATION_BOOKINGS : makes
    USERS ||--o{ GUIDE_BOOKINGS : makes
    USERS ||--o{ BOOKED_TRIPS : has
    USERS ||--o{ TRIP_GROUPS : owns
    USERS ||--o{ NOTIFICATIONS : receives
    USERS ||--o{ AI_TRIP_PLANS : generates
    TRIP_GROUPS ||--o{ TRIP_GROUP_MEMBERS : has
    ACCOMMODATION_BOOKINGS }o--|| ACCOMMODATIONS : references
    GUIDE_BOOKINGS }o--|| TOUR_GUIDES : references
```

---

## Table Descriptions

### `users`
Core user account. Password is hashed (bcrypt). OAuth users have `password_hash = null`.

### `user_preferences`
One-to-one with users. Stores trip planning preferences that drive the plan options engine.

| Field | Maps to mobile |
|---|---|
| `interests` | `TripPlanningProfile.interests` |
| `travel_style` | `TripPlanningProfile.pace` |
| `transport_style` | `TripPlanningProfile.transportStyle` |
| `stay_style` | `TripPlanningProfile.stayStyle` |

### `destinations`
All tourist destinations across Rwanda's provinces.  
`category` values: `nature`, `wildlife`, `volcano`, `culture`, `adventure`.

### `accommodations`
Hotels, lodges, eco-lodges.  
`tier` values: `budget`, `mid`, `luxury`.

### `tour_guides`
Licensed guides per province.  
`needs_manual_confirmation = true` means the booking goes to `awaitingConfirmation` state on mobile.

### `favourites`
Polymorphic — `item_type` is `destination` or `accommodation`.

### `trip_items`
The user's trip planner list. `is_selected` tracks which items are in the active planning session.

### `accommodation_bookings`
`status` values: `pending`, `confirmed`, `completed`, `cancelled`.

### `guide_bookings`
`status` values: `pending`, `confirmed`.  
When a guide has `needs_manual_confirmation`, an admin must PATCH the status to `confirmed`.

### `booked_trips`
Final confirmed trips. Created when the user completes checkout.  
`status` values: `pending`, `confirmed`, `completed`.

### `ai_trip_plans`
Stores AI-generated plans as JSON blobs for history and re-use.

### `notifications`
`type` values: `booking_confirmed`, `trip_ready`, `guide_confirmed`, `promo`, `system`.

---

## Indexes (recommended)

```sql
-- Fast user lookups
CREATE INDEX idx_users_email ON users(email);

-- Destination filtering
CREATE INDEX idx_destinations_province ON destinations(province);
CREATE INDEX idx_destinations_category ON destinations(category);

-- Accommodation filtering
CREATE INDEX idx_accommodations_province ON accommodations(province);
CREATE INDEX idx_accommodations_tier ON accommodations(tier);

-- User-scoped queries
CREATE INDEX idx_favourites_user ON favourites(user_id);
CREATE INDEX idx_trip_items_user ON trip_items(user_id);
CREATE INDEX idx_bookings_user ON accommodation_bookings(user_id);
CREATE INDEX idx_guide_bookings_user ON guide_bookings(user_id);
CREATE INDEX idx_notifications_user_unread ON notifications(user_id, read);
```

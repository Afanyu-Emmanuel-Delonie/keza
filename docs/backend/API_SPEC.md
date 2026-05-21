# Backend — API Specification

Derived directly from the mobile app's domain layer and provider actions.  
All endpoints are prefixed with `/api/v1`.

## Auth header (all protected routes)
```
Authorization: Bearer <jwt_token>
```

---

## 1. Authentication

### POST `/auth/register`
```json
Request:
{
  "name": "string",
  "email": "string",
  "password": "string"
}

Response 201:
{
  "token": "string",
  "user": { "id": "string", "name": "string", "email": "string", "avatar": "string|null" }
}
```

### POST `/auth/login`
```json
Request:
{ "email": "string", "password": "string" }

Response 200:
{ "token": "string", "user": { ... } }
```

### POST `/auth/oauth`
```json
Request:
{ "provider": "google|facebook|apple", "token": "string" }

Response 200:
{ "token": "string", "user": { ... } }
```

### POST `/auth/forgot-password`
```json
Request: { "email": "string" }
Response 200: { "message": "Reset email sent" }
```

### POST `/auth/logout`  *(protected)*
```json
Response 200: { "message": "Logged out" }
```

---

## 2. User Profile

### GET `/users/me`  *(protected)*
```json
Response 200:
{
  "id": "string",
  "name": "string",
  "email": "string",
  "avatar": "string|null",
  "interests": ["string"],
  "travelStyle": "relaxed|balanced|adventurous",
  "budgetRange": { "min": 0, "max": 0 },
  "language": "string",
  "notificationsEnabled": true
}
```

### PATCH `/users/me`  *(protected)*
```json
Request: (any subset of the fields above)
Response 200: { updated user object }
```

---

## 3. Destinations

### GET `/destinations`
```
Query params:
  province   string   filter by province name
  category   string   nature|wildlife|volcano|culture|adventure
  search     string   full-text search
  page       int      default 1
  limit      int      default 20
```
```json
Response 200:
{
  "data": [
    {
      "id": "string",
      "name": "string",
      "location": "string",
      "province": "string",
      "image": "string",
      "price": "string",
      "rating": "string",
      "category": "string",
      "description": "string"
    }
  ],
  "total": 0,
  "page": 1,
  "limit": 20
}
```

### GET `/destinations/:id`
```json
Response 200:
{
  "id": "string",
  "name": "string",
  "location": "string",
  "province": "string",
  "images": ["string"],
  "price": "string",
  "rating": "string",
  "category": "string",
  "description": "string",
  "highlights": ["string"],
  "openingHours": "string",
  "coordinates": { "lat": 0.0, "lng": 0.0 }
}
```

### GET `/provinces`
```json
Response 200:
[
  {
    "name": "string",
    "image": "string",
    "placesCount": 0,
    "destinations": [ { destination summary } ]
  }
]
```

---

## 4. Accommodations

### GET `/accommodations`
```
Query params: province, search, tier (budget|mid|luxury), page, limit
```
```json
Response 200:
{
  "data": [
    {
      "id": "string",
      "name": "string",
      "location": "string",
      "province": "string",
      "image": "string",
      "pricePerNight": 0.0,
      "rating": "string",
      "reviews": 0,
      "tier": "budget|mid|luxury",
      "roomTypes": ["string"]
    }
  ],
  "total": 0
}
```

### GET `/accommodations/:id`
```json
Response 200:
{
  "id": "string",
  "name": "string",
  "images": ["string"],
  "pricePerNight": 0.0,
  "rating": "string",
  "reviews": 0,
  "tier": "string",
  "amenities": ["string"],
  "roomTypes": ["string"],
  "coordinates": { "lat": 0.0, "lng": 0.0 }
}
```

---

## 5. Tour Guides

### GET `/guides`
```
Query params: province, language, page, limit
```
```json
Response 200:
{
  "data": [
    {
      "id": "string",
      "name": "string",
      "specialty": "string",
      "province": "string",
      "image": "string",
      "pricePerDay": "string",
      "rating": "string",
      "languages": ["string"],
      "needsManualConfirmation": false
    }
  ]
}
```

---

## 6. Favourites  *(protected)*

### GET `/users/me/favourites`
```json
Response 200: { "data": [ { TripItem } ] }
```

### POST `/users/me/favourites`
```json
Request: { "itemId": "string", "type": "destination|accommodation" }
Response 201: { "message": "Added to favourites" }
```

### DELETE `/users/me/favourites/:itemId`
```json
Response 200: { "message": "Removed from favourites" }
```

---

## 7. Trip Planner  *(protected)*

### GET `/trips/my-trip`
```json
Response 200:
{
  "addedItems": [ { TripItem } ],
  "selectedIds": ["string"],
  "profile": { TripPlanningProfile }
}
```

### PATCH `/trips/my-trip`
```json
Request:
{
  "addedItems": [ { TripItem } ],
  "selectedIds": ["string"],
  "profile": { TripPlanningProfile }
}
Response 200: { updated trip state }
```

### GET `/trips/plan-options`
```
Query params: (uses server-side profile stored for user)
```
```json
Response 200:
[
  {
    "type": "value|balanced|premium",
    "name": "string",
    "description": "string",
    "fitNote": "string",
    "transportNote": "string",
    "stayNote": "string",
    "estimatedCost": 0.0,
    "withinBudget": true,
    "days": [
      {
        "dayNumber": 1,
        "title": "string",
        "province": "string",
        "summary": "string",
        "stops": [ { TripItem } ],
        "stayNote": "string",
        "estimatedCost": 0.0
      }
    ]
  }
]
```

---

## 8. Accommodation Bookings  *(protected)*

### GET `/bookings/accommodations`
```json
Response 200:
{
  "data": [
    {
      "id": "string",
      "item": { TripItem },
      "checkIn": "ISO8601",
      "checkOut": "ISO8601",
      "guests": 0,
      "roomType": "string",
      "notes": "string|null",
      "nights": 0,
      "totalCost": 0.0,
      "status": "pending|confirmed|completed"
    }
  ]
}
```

### POST `/bookings/accommodations`
```json
Request:
{
  "itemId": "string",
  "checkIn": "ISO8601",
  "checkOut": "ISO8601",
  "guests": 0,
  "roomType": "string",
  "notes": "string|null"
}
Response 201: { booking object }
```

### DELETE `/bookings/accommodations/:province`
```json
Response 200: { "message": "Booking cancelled" }
```

---

## 9. Guide Bookings  *(protected)*

### POST `/bookings/guides`
```json
Request:
{
  "guideId": "string",
  "date": "ISO8601",
  "days": 0
}
Response 201:
{
  "id": "string",
  "guide": { TourGuide },
  "date": "ISO8601",
  "days": 0,
  "status": "pending|confirmed",
  "totalCost": 0.0
}
```

### PATCH `/bookings/guides/:province/confirm`  *(admin or webhook)*
```json
Response 200: { "status": "confirmed" }
```

### DELETE `/bookings/guides/:province`
```json
Response 200: { "message": "Guide booking cancelled" }
```

---

## 10. Booked Trips  *(protected)*

### GET `/bookings/trips`
```json
Response 200:
{
  "data": [
    {
      "id": "string",
      "name": "string",
      "location": "string",
      "image": "string",
      "price": "string",
      "bookingDate": "ISO8601",
      "travelDate": "ISO8601",
      "status": "pending|confirmed|completed"
    }
  ]
}
```

### POST `/bookings/trips`
```json
Request:
{
  "name": "string",
  "location": "string",
  "image": "string",
  "price": "string",
  "travelDate": "ISO8601"
}
Response 201: { BookedTrip }
```

---

## 11. Trip Groups  *(protected)*

### GET `/groups`
```json
Response 200: { "data": [ { "id": "string", "name": "string", "memberCount": 0 } ] }
```

### POST `/groups`
```json
Request: { "name": "string" }
Response 201: { TripGroup }
```

---

## 12. AI Trip Builder  *(protected)*

### POST `/ai/proposed-places`
```json
Request:
{
  "interests": ["string"],
  "startDate": "ISO8601",
  "endDate": "ISO8601",
  "budget": 0.0,
  "people": 0
}
Response 200:
{
  "places": [
    {
      "id": "string",
      "name": "string",
      "location": "string",
      "province": "string",
      "image": "string",
      "category": "string",
      "entryFee": 0.0,
      "duration": "string",
      "description": "string"
    }
  ]
}
```

### POST `/ai/generate-plan`
```json
Request:
{
  "prefs": {
    "startDate": "ISO8601",
    "endDate": "ISO8601",
    "budget": 0.0,
    "people": 0,
    "interests": ["string"]
  },
  "selectedPlaceIds": ["string"]
}
Response 200:
{
  "plan": {
    "id": "string",
    "estimatedCost": 0.0,
    "highlights": ["string"],
    "accommodationNote": "string",
    "days": [
      {
        "day": 1,
        "date": "ISO8601",
        "title": "string",
        "province": "string",
        "stops": [
          {
            "id": "string",
            "name": "string",
            "location": "string",
            "image": "string",
            "duration": "string",
            "type": "destination|stay|transport",
            "note": "string|null",
            "costPerPerson": 0.0
          }
        ]
      }
    ]
  }
}
```

### POST `/ai/chat`
```json
Request:
{
  "message": "string",
  "history": [ { "role": "user|assistant", "content": "string" } ]
}
Response 200:
{
  "reply": "string"
}
```

---

## 13. Notifications  *(protected)*

### GET `/notifications`
```json
Response 200:
{
  "data": [
    {
      "id": "string",
      "title": "string",
      "body": "string",
      "type": "booking_confirmed|trip_ready|guide_confirmed|promo",
      "read": false,
      "createdAt": "ISO8601"
    }
  ]
}
```

### PATCH `/notifications/:id/read`
```json
Response 200: { "read": true }
```

---

## Error Format

All errors follow:
```json
{
  "error": {
    "code": "VALIDATION_ERROR|UNAUTHORIZED|NOT_FOUND|SERVER_ERROR",
    "message": "Human readable message"
  }
}
```

| HTTP Status | Meaning |
|---|---|
| 200 | OK |
| 201 | Created |
| 400 | Validation error |
| 401 | Unauthenticated |
| 403 | Forbidden |
| 404 | Not found |
| 500 | Server error |

# Backend — Architecture

## Recommended Stack

| Concern | Recommendation | Reason |
|---|---|---|
| Runtime | Node.js (TypeScript) or Python (FastAPI) | Fast iteration, strong ecosystem |
| Framework | Express / Fastify (Node) or FastAPI (Python) | REST-first, easy to document |
| Database | PostgreSQL | Relational, strong JSON support for AI plan blobs |
| ORM | Prisma (Node) or SQLAlchemy (Python) | Type-safe, migration support |
| Auth | JWT (access + refresh tokens) | Stateless, mobile-friendly |
| File storage | AWS S3 or Cloudflare R2 | Images, avatars |
| Push notifications | Firebase Cloud Messaging (FCM) | Cross-platform mobile push |
| AI integration | OpenAI API (GPT-4o) | Powers chat, plan generation, place suggestions |
| Cache | Redis | Session cache, rate limiting, AI response cache |
| Hosting | Railway / Render / AWS ECS | Easy deploy, scalable |

---

## Service Breakdown

```
backend/
├── src/
│   ├── modules/
│   │   ├── auth/           — register, login, OAuth, JWT, refresh
│   │   ├── users/          — profile CRUD, preferences
│   │   ├── destinations/   — CRUD, search, province filter
│   │   ├── accommodations/ — CRUD, search, tier filter
│   │   ├── guides/         — CRUD, province filter
│   │   ├── favourites/     — add/remove/list
│   │   ├── trips/          — trip planner state, plan options engine
│   │   ├── bookings/       — accommodation & guide bookings
│   │   ├── ai/             — proposed places, plan generation, chat
│   │   └── notifications/  — list, mark read, FCM dispatch
│   ├── middleware/
│   │   ├── auth.middleware.ts    — JWT verification
│   │   ├── error.middleware.ts   — Global error handler
│   │   └── rate-limit.middleware.ts
│   ├── shared/
│   │   ├── prisma.ts        — DB client singleton
│   │   ├── redis.ts         — Cache client
│   │   └── fcm.ts           — Push notification helper
│   └── main.ts
```

---

## Auth Flow

```
Mobile                          Backend
  │                                │
  │── POST /auth/login ──────────► │
  │                                │── verify credentials
  │                                │── generate access_token (15 min)
  │                                │── generate refresh_token (30 days)
  │◄── { access_token, refresh } ──│
  │                                │
  │── GET /users/me ──────────────►│
  │   Authorization: Bearer <at>   │── verify JWT
  │◄── { user } ───────────────────│
  │                                │
  │── POST /auth/refresh ─────────►│
  │   { refresh_token }            │── verify refresh, issue new access_token
  │◄── { access_token } ───────────│
```

---

## AI Plan Generation Flow

```
Mobile                          Backend                      OpenAI
  │                                │                            │
  │── POST /ai/proposed-places ───►│                            │
  │   { interests, dates, budget } │── build prompt ───────────►│
  │                                │◄── place suggestions ──────│
  │◄── { places[] } ───────────────│                            │
  │                                │                            │
  │── POST /ai/generate-plan ─────►│                            │
  │   { prefs, selectedPlaceIds }  │── build itinerary prompt ─►│
  │                                │◄── structured plan JSON ───│
  │                                │── validate & enrich        │
  │◄── { plan } ───────────────────│                            │
```

---

## Plan Options Engine (server-side)

The `GET /trips/plan-options` endpoint replicates the logic currently in `InMemoryTripsRepository._buildPlanOptions()`:

1. Load user's `trip_items` (selected) and `user_preferences`.
2. Calculate base costs: destination entry fees + accommodation rate + transport rate + guide rate.
3. Apply multipliers per plan type (value: ×0.92, balanced: ×1.0, premium: ×1.22).
4. Split items across days using the same round-robin algorithm.
5. Return 3 `TripPlanOption` objects.

---

## Notification Triggers

| Event | Trigger | Notification type |
|---|---|---|
| Accommodation booking created | POST /bookings/accommodations | `booking_confirmed` |
| Guide booking manually confirmed | PATCH /bookings/guides/:id/confirm | `guide_confirmed` |
| AI trip plan saved | POST /ai/generate-plan + user confirms | `trip_ready` |
| Promo / marketing | Admin dashboard | `promo` |

---

## Rate Limiting

| Endpoint group | Limit |
|---|---|
| `/auth/*` | 10 req / min per IP |
| `/ai/*` | 20 req / min per user |
| All others | 100 req / min per user |

# Web — Platform Specification

## Status
The web platform is currently a placeholder (`web/.gitkeep`).  
This document defines the planned scope.

---

## Purpose

The Keza Tour web platform serves two audiences:

1. **Travellers** — A browser-based version of the mobile experience for users who prefer desktop.
2. **Hospitality Partners** — A portal for hotels, lodges, and tour operators to manage their listings.

---

## Traveller Web App

### Pages

| Page | Description |
|---|---|
| `/` | Landing page — hero, featured destinations, AI CTA |
| `/explore` | Browse destinations by province and category |
| `/destinations/:id` | Destination detail page |
| `/accommodations` | Browse stays with filters |
| `/accommodations/:id` | Accommodation detail page |
| `/ai` | AI Trip Builder (web version) |
| `/trips` | User's trip planner and bookings |
| `/profile` | User profile and preferences |
| `/login` | Auth page |
| `/register` | Registration page |

### Tech recommendation
- **Next.js** (React) — SSR for SEO on destination pages
- **Tailwind CSS** — consistent with mobile design tokens
- **Same API** as mobile — no separate backend needed

---

## Partner Portal

### Pages

| Page | Description |
|---|---|
| `/partner/login` | Partner login |
| `/partner/dashboard` | Overview: bookings, reviews, revenue |
| `/partner/listings` | Manage accommodation or tour listings |
| `/partner/bookings` | View and manage incoming bookings |
| `/partner/profile` | Business profile |

### Key features
- Partners can add/edit their accommodation or tour listings
- Partners receive booking notifications
- Partners can respond to reviews
- Partners see basic analytics (views, bookings, revenue)

---

## Shared with Mobile

- Same REST API (`/api/v1/*`)
- Same auth (JWT)
- Same data models
- Design tokens (colours, typography) should be extracted to a shared design system

---

## SEO Considerations

Destination and accommodation pages should be server-side rendered for Google indexing.  
Key meta tags per page:
- `title` — destination name + "Rwanda | Keza Tour"
- `description` — destination description (first 160 chars)
- `og:image` — first destination image
- `og:type` — `place` for destinations

# Keza Tour — Documentation Index

This folder contains all technical and product documentation for the Keza Tour platform.

## Structure

```
docs/
├── mobile/
│   ├── ARCHITECTURE.md          — Flutter app architecture, layers, patterns
│   ├── SCREENS_AND_FLOWS.md     — All screens, navigation flows, user journeys
│   ├── STATE_MANAGEMENT.md      — Provider setup, state flow per feature
│   └── CLASS_DIAGRAM.md         — Domain entities & class relationships (Mermaid)
│
├── backend/
│   ├── API_SPEC.md              — All REST endpoints the mobile app needs
│   ├── DATA_MODELS.md           — Database schema derived from mobile domain entities
│   ├── BACKEND_ARCHITECTURE.md  — Recommended backend stack & service breakdown
│   └── DASHBOARD_SPEC.md        — Admin dashboard requirements & key metrics
│
├── web/
│   └── WEB_SPEC.md              — Web platform scope & requirements
│
└── shared/
    └── GLOSSARY.md              — Shared terminology across all platforms
```

## Quick Links

| Document | Purpose |
|---|---|
| [Mobile Architecture](mobile/ARCHITECTURE.md) | How the Flutter app is structured |
| [Screens & Flows](mobile/SCREENS_AND_FLOWS.md) | Every screen and how users navigate |
| [Class Diagram](mobile/CLASS_DIAGRAM.md) | Domain model visualised |
| [API Spec](backend/API_SPEC.md) | Every endpoint the app calls |
| [Data Models](backend/DATA_MODELS.md) | Database tables & relationships |
| [Dashboard Spec](backend/DASHBOARD_SPEC.md) | Admin dashboard requirements |
| [Glossary](shared/GLOSSARY.md) | Shared terms |

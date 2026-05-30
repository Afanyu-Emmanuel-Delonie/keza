# Keza Tour

Keza Mobile is a smart hospitality and tourism platform focused on transforming how people discover, experience, and explore Rwanda digitally.

The platform is designed to provide travelers with a seamless ecosystem for accommodation discovery, AI-powered travel assistance, and guided tourism experiences. Users can explore destinations across Rwanda, find and book places to stay, discover local attractions, and access personalized travel recommendations through an intelligent trip planning system.

## Current Focus

The current focus of the platform is centered around three core areas:

### 1. Accommodation
Users can browse and discover hotels, lodges, apartments, resorts, and other hospitality services across Rwanda through a modern and user-friendly mobile experience.

### 2. AI Travel Assistance
The platform integrates AI-driven features to help users plan trips, receive personalized recommendations, generate travel itineraries, and discover experiences tailored to their interests and budget.

### 3. Tourism & Experiences
Users can explore tourist attractions, book tours, discover cultural experiences, and navigate destinations within Rwanda using integrated tourism features and digital guidance tools.

## Vision

Keza Mobile aims to become a scalable digital ecosystem for Rwanda's hospitality and tourism industry by connecting travelers, hospitality providers, tour operators, and local experiences within one unified platform.

## Documentation

This README will be updated as the project evolves, so we can keep the product direction, features, and implementation notes in one place.

## Recent Development Notes

- Fixed the Android Gradle Kotlin DSL syntax in `mobile/android/app/build.gradle.kts` by changing the `minSdk` configuration from Groovy-style syntax to Kotlin-style assignment.
- Identified the app ID as `com.example.keza_mobile` for the Flutter project.
- Removed the old emulator-installed package `com.example.wao_mobile` to free up storage and allow APK installation on `sdk gphone64 x86 64`.
- Confirmed the emulator was running low on internal storage during installation, so cleanup was needed before the app could run again.

## Project Structure

- `backend/` - backend services and APIs
- `mobile/` - Flutter mobile application
- `web/` - web experience and related assets

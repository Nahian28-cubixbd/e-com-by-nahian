## Architecture Overview

This project follows Clean Architecture, separating responsibilities
into three main layers per feature:

-   Data -- API calls, models, and repository implementations
-   Domain -- Business logic, entities, repository contracts, and use
    cases
-   Presentation -- UI, BLoC/Cubit, and widgets

## Tech Stack

-   Flutter
-   flutter_bloc (BLoC / Cubit)
-   Dio (HTTP client)
-   Hive (Local storage)
-   GetIt (Dependency injection)
-   Firebase Messaging (Optional push notifications)

------------------------------------------------------------------------

## Firebase Setup (Optional -- Push Notifications)

The app works without Firebase. Push notifications are optional.

To enable:

1.  Create a project at https://console.firebase.google.com
2.  Add Android app (default package: com.example.flutter_shop)
3.  Download google-services.json → place inside android/app/
4.  Add iOS app → place GoogleService-Info.plist inside ios/Runner/
5.  Run:

dart pub global activate flutterfire_cli flutterfire configure

------------------------------------------------------------------------

## API Endpoints

Base URL: https://dummyjson.com

-   GET /products?limit=10&skip=0
-   GET /products/categories
-   GET /products/category/{slug}?limit=10&skip=0

------------------------------------------------------------------------

## State Management Flow

UI Event → BLoC/Cubit → UseCase → Repository → DataSource → API/Local
Storage UI ← State ← BLoC/Cubit ← Either\<Failure, Result\>

------------------------------------------------------------------------

## Note about Push Notifications

Push notifications were almost fully integrated, however due to a version 
conflict between the Android Gradle Plugin on my local machine and the 
flutter_local_notifications package, errors were thrown during the build 
process. As a result, the push notification feature had to be skipped for 
now. That said, the codebase is already structured to support it, and it 
can be enabled easily by resolving the dependency versions.

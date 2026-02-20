## Architecture Overview

This project follows Clean Architecture, separating responsibilities
into three main layers per feature:

-   Data -- API calls, models, and repository implementations
-   Domain -- Business logic, entities, repository contracts, and use
    cases
-   Presentation -- UI, BLoC/Cubit, and widgets

Project Structure:

lib/
├── core/
│   ├── constants/         # AppConstants (baseUrl, page size, keys)
│   ├── errors/            # Failures & Exceptions
│   ├── network/           # Dio client, NetworkInfo
│   ├── theme/             # AppTheme, AppColors
│   └── utils/             # UseCase base class, PushNotificationService
│
├── features/
│   ├── products/
│   │   ├── data/
│   │   │   ├── datasources/   # ProductRemoteDataSource (Dio)
│   │   │   ├── models/        # ProductModel (JSON ↔ Entity)
│   │   │   └── repositories/  # ProductRepositoryImpl
│   │   ├── domain/
│   │   │   ├── entities/      # Product, ProductsResponse
│   │   │   ├── repositories/  # ProductRepository (abstract)
│   │   │   └── usecases/      # GetProducts, GetProductsByCategory
│   │   └── presentation/
│   │       ├── bloc/          # ProductsBloc (events, states)
│   │       ├── pages/         # HomePage, AllProductsPage, ProductDetailPage
│   │       └── widgets/       # ProductGridCard, ProductListCard, shimmer, error
│   │
│   ├── categories/
│   │   ├── data/              # CategoryRemoteDataSource, CategoryModel, Repo
│   │   ├── domain/            # Category entity, GetCategories use case
│   │   └── presentation/
│   │       ├── cubit/         # CategoriesCubit
│   │       ├── pages/         # CategoriesPage, CategoryProductsPage
│   │       └── widgets/       # CategoryGrid, CategoryCard
│   │
│   └── cart/
│       ├── data/              # CartLocalDataSource (Hive)
│       ├── domain/            # CartItem entity
│       └── presentation/
│           ├── cubit/         # CartCubit + CartState
│           └── pages/         # CartPage
│
├── injection/
│   └── injection_container.dart   # GetIt dependency injection
│
└── main.dart                      # App entry point

------------------------------------------------------------------------

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

## Push Notification Topic

The app subscribes to:

all_users

You can broadcast notifications to all users or create additional topics
for targeting.

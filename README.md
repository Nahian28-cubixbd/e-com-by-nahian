# ShopEase Flutter App

A production-ready Flutter e-commerce application built with **Clean Architecture**, **BLoC state management**, and a polished UI.

---

## ✨ Features

| Feature | Details |
|---|---|
| 🏠 Home Page | Two navigation cards: All Products & Categories |
| 📦 All Products | Paginated grid/list view with infinite scroll |
| 🗂 Categories | 24 categories with colorful icon cards |
| 📋 Category Products | Filter products by any category |
| 🛒 Cart | Add/remove/adjust quantity, persisted to Hive |
| 🔔 Cart Badge | Live count badge on AppBar cart icon |
| ⏳ Loading States | Shimmer skeleton screens |
| ❌ Error States | Friendly error UI with retry |
| 🔄 Pull-to-Refresh | Refresh any product list |
| 🔔 Push Notifications | Firebase Cloud Messaging (FCM) |

---

## 🏗 Architecture

```
Clean Architecture (3 layers per feature)

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
```

---

## 🚀 Getting Started

### 1. Clone and install dependencies

```bash
git clone <repo>
cd flutter_shop
flutter pub get
```

### 2. Firebase Setup (Push Notifications)

> The app runs fine **without Firebase** — push notifications are optional.

To enable push notifications:

1. Create a Firebase project at [console.firebase.google.com](https://console.firebase.google.com)
2. Add an Android app with your package name (default: `com.example.flutter_shop`)
3. Download `google-services.json` → place in `android/app/`
4. Add an iOS app → download `GoogleService-Info.plist` → place in `ios/Runner/`
5. Follow the FlutterFire CLI setup:
   ```bash
   dart pub global activate flutterfire_cli
   flutterfire configure
   ```

Without Firebase, the app will print a warning but continue normally.

### 3. Run

```bash
flutter run
```

---

## 📦 Key Packages

| Package | Purpose |
|---|---|
| `flutter_bloc` | State management (BLoC + Cubit) |
| `get_it` | Dependency injection |
| `dio` | HTTP client |
| `hive_flutter` | Local cart persistence |
| `cached_network_image` | Image caching |
| `badges` | Cart count badge |
| `shimmer` | Loading skeleton UI |
| `firebase_messaging` | Push notifications |
| `flutter_local_notifications` | Show notifications in foreground |
| `connectivity_plus` | Network status check |
| `dartz` | Functional error handling (Either) |

---

## 🔌 APIs Used

| Endpoint | Description |
|---|---|
| `GET /products?limit=10&skip=0` | Paginated product list |
| `GET /products/categories` | List of all categories |
| `GET /products/category/{slug}?limit=10&skip=0` | Products by category |

Base URL: `https://dummyjson.com`

---

## 🛠 State Management Pattern

```
UI Event → BLoC/Cubit → UseCase → Repository → DataSource → API/Local Storage
                                                           ↓
UI ← State ← BLoC/Cubit ← Either<Failure, Result> ←────────
```

- **ProductsBloc** handles all product listing (fetch, paginate, toggle view)
- **CategoriesCubit** handles category list fetching
- **CartCubit** manages cart state and persists to Hive automatically

---

## 📲 Push Notification Topics

The app subscribes to `all_users` topic on launch. You can send targeted notifications from Firebase Console or via API to:
- `all_users` — broadcast to all app users
- Add more topics as needed (e.g., per-category)

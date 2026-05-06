# Register Offline

Aplikasi Flutter untuk pendaftaran member secara offline dengan fitur sinkronisasi ke server.

---

## Cara Menjalankan

**Requirement:**

- Flutter SDK >= 3.0.0 (Stable Channel)
- Android device / emulator (API 21+)

**Steps:**

```bash
# 1. Clone repo
git clone https://github.com/IhtiarAlfath/register_offline
cd register_offline

# 2. Install packages
flutter pub get

# 3. Run
flutter run
```

Build APK:

```bash
flutter build apk --release
```

---

## Struktur Proyek

```
lib/
├── main.dart
├── core/
│   ├── dependency_injection/   # injection_container.dart (GetIt)
│   ├── error/                  # failures.dart
│   ├── router/                 # app_router.dart (GoRouter)
│   ├── services/               # network_services.dart
│   ├── success/                # success.dart
│   └── utils/                  # constants, theme, either, logger
│
└── features/
    ├── authentication/
    │   ├── data/
    │   │   ├── datasource/     # local (Hive + SecureStorage), remote (HTTP)
    │   │   ├── models/         # DataLoginModel
    │   │   └── repositories/   # AuthenticationRepositoriesImpl
    │   ├── domain/
    │   │   ├── entities/       # DataLogin, DataLoginParameter
    │   │   ├── repositories/   # abstract AuthenticationRepositories
    │   │   └── usecases/       # Login, Logout, GetCachedDataLogin
    │   └── presentation/
    │       ├── bloc/           # AuthenticationBloc + Event + State
    │       └── pages/          # SplashPage, LoginPage
    │
    ├── member/
    │   ├── data/
    │   │   ├── datasource/     # local (Hive), remote (multipart HTTP)
    │   │   ├── models/         # MemberLocalModel, MemberRemoteModel
    │   │   └── repositories/   # MemberRepositoriesImpl
    │   ├── domain/
    │   │   ├── entities/       # MemberLocal, MemberRemote, SyncStatus
    │   │   ├── repositories/   # abstract MemberRepositories
    │   │   └── usecases/       # SaveLocal, Update, GetDrafts, Upload, SyncAll
    │   └── presentation/
    │       ├── bloc/           # MemberBloc + Event + State
    │       ├── pages/          # HomePage, AddMemberPage
    │       └── widgets/        # DraftMemberCard, UploadedMemberCard
    │
    └── profile/
        ├── data/
        │   ├── datasource/     # ProfileDatasourceRemote (HTTP GET /profile)
        │   └── repositories/   # ProfileRepositoriesImpl
        ├── domain/
        │   ├── entities/       # UserProfile
        │   ├── repositories/   # abstract ProfileRepositories
        │   └── usecases/       # GetProfile
        └── presentation/
            ├── bloc/           # ProfileBloc + Event + State
            └── pages/          # ProfilePage
```

---

## Tech Stack

| Kebutuhan        | Library                |
| ---------------- | ---------------------- |
| State management | flutter_bloc           |
| Local DB         | hive + hive_flutter    |
| HTTP             | http                   |
| Koneksi          | connectivity_plus      |
| DI               | get_it                 |
| Router           | go_router              |
| Kamera / galeri  | image_picker           |
| Kompresi gambar  | flutter_image_compress |
| Secure storage   | flutter_secure_storage |

---

## Alur Penggunaan

1. Buka app → Splash cek token → redirect ke Login atau Home
2. Login dengan email & password
3. Di tab **Draft** → tambah data member → simpan sebagai Draft (tersimpan lokal, tidak perlu internet)
4. Jika sudah online → Upload per item atau klik **Upload Semua**
5. Data yang berhasil diupload muncul di tab **Sudah Di-Upload**
6. Logout lewat halaman Profile

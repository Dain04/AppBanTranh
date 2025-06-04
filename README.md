# app_ban_tranh

A new Flutter project.
------------------------bố cục-----------------
Cấu trúc thư mục Flutter project
my_flutter_app/
├── android/                 # Code native Android
├── ios/                     # Code native iOS  
├── lib/                     # Code Dart chính
│   ├── main.dart           # File khởi chạy ứng dụng
│   ├── screens/            # Các màn hình
│   ├── widgets/            # Widget tái sử dụng
│   ├── models/             # Data models
│   ├── services/           # API services, database
│   └── utils/              # Utility functions
├── test/                   # Unit tests
├── assets/                 # Hình ảnh, fonts, files
│   ├── images/
│   ├── fonts/
│   └── data/
├── build/                  # File build tự động tạo
├── pubspec.yaml           # Dependencies và cấu hình
├── pubspec.lock           # Lock file dependencies
└── README.md              # Tài liệu project
Tổ chức file trong thư mục lib/
lib/
├── main.dart              # Entry point
├── app.dart               # App wrapper
├── screens/               # Các màn hình
│   ├── home_screen.dart
│   ├── profile_screen.dart
│   └── settings_screen.dart
├── widgets/               # Widget components
│   ├── common/
│   │   ├── custom_button.dart
│   │   └── loading_widget.dart
│   └── specific/
├── models/                # Data structures
│   ├── user.dart
│   └── product.dart
├── services/              # Business logic
│   ├── api_service.dart
│   ├── auth_service.dart
│   └── database_service.dart
├── utils/                 # Helper functions
│   ├── constants.dart
│   ├── helpers.dart
│   └── validators.dart
└── themes/                # UI themes
    ├── app_colors.dart
    ├── app_text_styles.dart
    └── app_theme.dart
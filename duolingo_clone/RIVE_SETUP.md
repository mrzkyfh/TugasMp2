# Setup Rive Animation

Rive sudah terintegrasi di project! Ikuti langkah-langkah di bawah untuk setup character animation:

## Langkah 1: Download atau Buat Rive File
1. Buka [rive.app](https://rive.app)
2. Login atau buat akun gratis
3. Buat atau download template character (cari "translator", "avatar", atau "character" di community)
4. Export file sebagai **`.riv`** format
5. Simpan dengan nama: `fluenta_character.riv`

## Langkah 2: Letakkan di Project
Tempatkan file `.riv` di folder:
```
assets/
└── animations/
    └── fluenta_character.riv
```

## Langkah 3: Pastikan pubspec.yaml Sudah Updated
Cek bahwa pubspec.yaml memiliki:
```yaml
dependencies:
  rive: ^0.13.0

flutter:
  assets:
    - assets/animations/
```

## Langkah 4: Run Project
```bash
flutter pub get
flutter run
```

## Tips Rive File
- Pastikan Rive file memiliki animasi bernama **"idle"** (default animation)
- Bisa tambah lebih banyak animasi (misal: "speak", "happy", "confused")
- Ukuran file sebaiknya < 500KB untuk performa optimal

## Kustomisasi (Optional)

### Ganti nama animasi
```dart
RiveCharacter(
  riveAssetPath: 'assets/animations/fluenta_character.riv',
  animationName: 'speak', // ganti ke animasi lain
)
```

### Ganti ukuran
```dart
RiveCharacter(
  riveAssetPath: 'assets/animations/fluenta_character.riv',
  width: 250,
  height: 250,
)
```

### Trigger animasi saat AI berbicara
Di `chat_screen.dart`, bisa tambahkan logic untuk switch animasi:
```dart
// Saat AI mengirim response
_controller?.animationName = 'speak';
```

## Resource Rive Community
- Character templates: [rive.app/community](https://rive.app/community)
- Tutorial: [rive.app/learn](https://rive.app/learn)

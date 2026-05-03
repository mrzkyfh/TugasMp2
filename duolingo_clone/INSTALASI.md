# 📦 Lokasi File Instalasi - Fluenta App

## 🌐 Web Build (Sudah Tersedia)

File web build sudah berhasil dibuat dan siap untuk di-deploy!

**Lokasi:**
```
/Users/muhammadrizky/Documents/mobile/duolingo_clone/build/web/
```

**Cara Deploy:**
1. Upload semua file di folder `build/web/` ke hosting web (Netlify, Vercel, Firebase Hosting, dll)
2. Atau jalankan lokal dengan: `flutter run -d chrome`

**File Utama:**
- `index.html` - File HTML utama
- `main.dart.js` - Aplikasi Flutter yang sudah dikompilasi
- `flutter_service_worker.js` - Service worker untuk PWA
- `assets/` - Folder berisi semua asset (font, gambar, dll)
- `icons/` - Icon aplikasi
- `manifest.json` - Manifest untuk PWA

---

## 📱 Android Build (APK)

Untuk membuat file APK Android, Anda perlu menginstall Java terlebih dahulu.

### Cara Install Java:

**Menggunakan Homebrew (Recommended):**
```bash
brew install openjdk@17
```

Setelah install, tambahkan ke PATH:
```bash
sudo ln -sfn /opt/homebrew/opt/openjdk@17/libexec/openjdk.jdk /Library/Java/JavaVirtualMachines/openjdk-17.jdk
```

### Setelah Java Terinstall:

**1. Build APK Debug (untuk testing):**
```bash
flutter build apk --debug
```
Lokasi: `build/app/outputs/flutter-apk/app-debug.apk`

**2. Build APK Release (untuk distribusi):**
```bash
flutter build apk --release
```
Lokasi: `build/app/outputs/flutter-apk/app-release.apk`

**3. Build App Bundle (untuk Google Play Store):**
```bash
flutter build appbundle --release
```
Lokasi: `build/app/outputs/bundle/release/app-release.aab`

---

## 🍎 iOS Build (IPA)

Untuk membuat file IPA iOS, Anda perlu:

1. **Install Xcode** dari App Store
2. **Install CocoaPods:**
   ```bash
   sudo gem install cocoapods
   ```

### Setelah Xcode Terinstall:

**Build iOS:**
```bash
flutter build ios --release
```

**Untuk membuat IPA:**
1. Buka Xcode: `open ios/Runner.xcworkspace`
2. Product → Archive
3. Distribute App → Ad Hoc atau App Store

Lokasi: `build/ios/iphoneos/Runner.app`

---

## 🖥️ Desktop Build

### macOS:
```bash
flutter build macos --release
```
Lokasi: `build/macos/Build/Products/Release/fluenta.app`

### Windows:
```bash
flutter build windows --release
```
Lokasi: `build/windows/runner/Release/`

### Linux:
```bash
flutter build linux --release
```
Lokasi: `build/linux/x64/release/bundle/`

---

## 📊 Status Build Saat Ini

| Platform | Status | Lokasi File |
|----------|--------|-------------|
| **Web** | ✅ Tersedia | `build/web/` |
| **Android** | ⚠️ Perlu Java | `build/app/outputs/flutter-apk/` |
| **iOS** | ⚠️ Perlu Xcode | `build/ios/iphoneos/` |
| **macOS** | ⚠️ Perlu Xcode | `build/macos/Build/Products/Release/` |
| **Windows** | ❌ Tidak tersedia di macOS | - |
| **Linux** | ❌ Tidak tersedia di macOS | - |

---

## 🚀 Quick Start

### Untuk Testing Cepat:

**Web (Sudah Bisa Digunakan):**
```bash
cd /Users/muhammadrizky/Documents/mobile/duolingo_clone
flutter run -d chrome
```

**Android (Setelah Install Java):**
```bash
flutter run -d <device-id>
```

**iOS (Setelah Install Xcode):**
```bash
flutter run -d <device-id>
```

---

## 📝 Catatan

- File web build sudah siap dan bisa langsung di-deploy
- Untuk Android, install Java terlebih dahulu
- Untuk iOS, install Xcode dan CocoaPods
- Semua file build akan berada di folder `build/` di root project

---

## 🔗 Link Berguna

- [Flutter Build Documentation](https://docs.flutter.dev/deployment)
- [Install Java](https://www.java.com/en/download/)
- [Install Xcode](https://developer.apple.com/xcode/)
- [Install CocoaPods](https://guides.cocoapods.org/using/getting-started.html)

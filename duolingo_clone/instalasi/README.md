# 📦 Fluenta App - File Instalasi

## 📂 Struktur Folder

```
instalasi/
├── web/              ✅ Web Build (36 MB) - SIAP DEPLOY!
│   ├── index.html
│   ├── main.dart.js
│   ├── assets/
│   └── ...
│
└── android/          ✅ Android APK (48 MB) - SIAP INSTALL!
    └── fluenta-app.apk
```

---

## 🌐 Web Build (TERSEDIA)

**Lokasi:** `instalasi/web/`  
**Ukuran:** 36 MB  
**Status:** ✅ Siap Deploy

### Cara Deploy:

#### 1. **Netlify (Gratis & Mudah)**
```bash
# Install Netlify CLI
npm install -g netlify-cli

# Deploy
cd instalasi/web
netlify deploy --prod
```

#### 2. **Vercel (Gratis)**
```bash
# Install Vercel CLI
npm install -g vercel

# Deploy
cd instalasi/web
vercel --prod
```

#### 3. **Firebase Hosting (Gratis)**
```bash
# Install Firebase CLI
npm install -g firebase-tools

# Login & Init
firebase login
firebase init hosting

# Deploy
firebase deploy
```

#### 4. **GitHub Pages (Gratis)**
1. Upload folder `web/` ke repository GitHub
2. Settings → Pages → Source: main branch
3. Aplikasi akan tersedia di: `https://username.github.io/repo-name/`

#### 5. **Jalankan Lokal**
```bash
# Menggunakan Python
cd instalasi/web
python3 -m http.server 8000

# Atau menggunakan PHP
php -S localhost:8000

# Buka browser: http://localhost:8000
```

---

## 📱 Android Build (TERSEDIA!)

**Status:** ✅ Siap Install  
**Lokasi:** `instalasi/android/fluenta-app.apk`  
**Ukuran:** 48 MB

### Cara Install di HP Android:

**📖 Baca panduan lengkap:** `CARA-INSTALL-MOBILE.md`

**Cara Tercepat (via USB):**

1. **Hubungkan HP ke Mac dengan kabel USB**

2. **Copy file APK:**
   - Buka Finder → Go to Folder (Cmd+Shift+G)
   - Paste: `/Users/muhammadrizky/Documents/mobile/duolingo_clone/instalasi/android/`
   - Drag `fluenta-app.apk` ke folder Download di HP

3. **Di HP Android:**
   - Buka Files → Downloads
   - Tap `fluenta-app.apk`
   - Enable "Install from Unknown Sources" jika diminta
   - Tap Install
   - Selesai! 🎉

**Cara Alternatif:**
- Upload ke Google Drive → Download di HP → Install
- Kirim via WhatsApp → Download → Install
- Kirim via Email → Download → Install

**Persyaratan:**
- Android 5.0 atau lebih baru
- Minimal 100 MB storage free
- Enable "Install from Unknown Sources"

---

## 🍎 iOS Build (BELUM TERSEDIA)

**Status:** ⚠️ Perlu Xcode

### Cara Membuat IPA:

1. **Install Xcode** dari App Store

2. **Install CocoaPods:**
   ```bash
   sudo gem install cocoapods
   ```

3. **Build iOS:**
   ```bash
   cd /Users/muhammadrizky/Documents/mobile/duolingo_clone
   flutter build ios --release
   ```

4. **Buat IPA:**
   - Buka: `open ios/Runner.xcworkspace`
   - Product → Archive
   - Distribute App → Ad Hoc
   - Export IPA

---

## 🚀 Testing Aplikasi

### Web (Sudah Bisa):
```bash
cd /Users/muhammadrizky/Documents/mobile/duolingo_clone
flutter run -d chrome
```

### Android (Setelah Install Java):
```bash
flutter run -d <device-id>
```

### iOS (Setelah Install Xcode):
```bash
flutter run -d <device-id>
```

---

## 📊 Informasi Build

| Item | Detail |
|------|--------|
| **Nama Aplikasi** | Fluenta |
| **Package Name** | com.example.fluenta |
| **Version** | 1.0.0 |
| **Build Number** | 1 |
| **Flutter Version** | 3.41.8 |
| **Dart Version** | 3.x |

---

## 🔗 Link Penting

- **Project Path:** `/Users/muhammadrizky/Documents/mobile/duolingo_clone`
- **Web Build:** `instalasi/web/`
- **Dokumentasi:** `INSTALASI.md` (di root project)

---

## 💡 Tips

1. **Web Build** sudah siap dan bisa langsung di-deploy ke hosting manapun
2. Untuk **Android**, install Java terlebih dahulu
3. Untuk **iOS**, install Xcode dan CocoaPods
4. File APK/IPA akan muncul di folder ini setelah di-build

---

## 📞 Support

Jika ada masalah:
1. Cek `INSTALASI.md` di root project untuk panduan lengkap
2. Jalankan `flutter doctor` untuk cek environment
3. Jalankan `flutter clean` jika ada error build

---

**Last Updated:** May 2, 2026  
**Status:** Web Build Ready ✅

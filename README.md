# 🌦️ Flutter Weather App

A simple, clean Flutter weather app that fetches live weather data using the **OpenWeatherMap API**.  
Built with Flutter and Dart, it demonstrates clean architecture with separation of screens, services, and models.

---

## 🚀 Features

- Search weather by city name 🌍  
- Real-time weather data from OpenWeatherMap API ☀️  
- Displays temperature, humidity, and conditions 🌡️  
- Clear and modular project structure 📁  
- Works on Android, iOS, and Web (Flutter 3.24+)

---

## 🧩 Project Structure

```
lib/
├── main.dart                # App entry point
├── screens/
│   └── weather_home.dart    # Main weather UI screen
├── services/
│   └── weather_api.dart     # Handles API calls
├── models/
│   └── weather_model.dart   # Weather data model
├── utils/
│   └── constants.dart       # API key and constants
└── widgets/
    └── weather_card.dart    # Optional reusable widget
```

---

## 🛠️ Setup Instructions

### 1️⃣ Install Flutter

If you haven’t installed Flutter yet, follow the official guide:  
👉 [https://docs.flutter.dev/get-started/install](https://docs.flutter.dev/get-started/install)

Verify your setup:

```bash
flutter doctor
```

---

### 2️⃣ Create a new Flutter project

If you haven’t already:

```bash
flutter create weather_app
cd weather_app
```

---

### 3️⃣ Add dependencies

In your `pubspec.yaml`, add the following under `dependencies`:

```yaml
dependencies:
  flutter:
    sdk: flutter
  http: ^1.1.0
```

Then install them:

```bash
flutter pub get
```

### 4️⃣ Add your OpenWeatherMap API key

- Sign up at [https://openweathermap.org/api](https://openweathermap.org/api)
- Copy your API key.
- In `lib/utils/constants.dart`, replace:

```dart
const String apiKey = "YOUR_API_KEY_HERE";
```

---

### 5️⃣ Run the app

Start your emulator or connect a physical device, then run:

```bash
flutter run
```

To specify a device:

```bash
flutter devices
flutter run -d <device_id>
```

---

### 6️⃣ Build for release

**Android (APK):**

```bash
flutter build apk --release
```

**iOS:**

```bash
flutter build ios --release
```

---

## 💻 Example API Call Flow

The app follows the same logic as your `api.js`:

1. Get coordinates for the entered city (using `/data/2.5/weather`)
2. Fetch detailed forecast (using `/data/3.0/onecall`)
3. Display temperature, humidity, and description in the UI.

---

## ⚙️ Development Commands Summary

| Command | Description |
|----------|-------------|
| `flutter doctor` | Verify Flutter setup |
| `flutter pub get` | Install dependencies |
| `flutter run` | Run the app |
| `flutter clean` | Clean build cache |
| `flutter build apk` | Create release APK |
| `flutter format .` | Auto-format all Dart files |

---

## 🧱 Example Output

```
Weather in Adelaide, AU:
Temp: 26°C
Humidity: 62%
Weather: clear sky
```

---

## 🧰 Tech Stack

- **Flutter 3.24+**
- **Dart 3.5+**
- **HTTP package** for API calls
- **OpenWeatherMap API** for weather data

---

## 📄 License

This project is open-source and available under the [MIT License](LICENSE).

---

## 👤 Author

**Freelance Frameworks**  
GitHub: [https://github.com/FreelanceFrameworks](https://github.com/FreelanceFrameworks)

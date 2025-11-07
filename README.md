🌤 Weather App
A Flutter application to view current weather, hourly forecasts, and historical data for the past 7 days.
👩‍💻 Author: Flutter Developer Altybaeva Nazira
✨ Features
🌡 Current Weather – Displays temperature, conditions, and weather icon for the selected city
🕒 Hourly Forecast – Scrollable list of today’s weather in hourly intervals
📅 7-Day Forecast – Detailed forecast for the next week
📈 Past 7 Days History – Weather data from the previous week
🌎 City Search – Check weather in any city worldwide
📱 Responsive Design – Adaptive layout for mobile, tablet, and web screens
🛠 Technologies
Purpose	Package
Cross-platform Framework	Flutter
State Management	BLoC (flutter_bloc)
Object Comparison	Equatable
Dependency Injection	GetIt
Network Requests	HTTP / Dio
Date & Time Formatting	Intl
🏗 Architecture
The app follows Clean Architecture with the BLoC (Business Logic Component) pattern for state management:
WeatherEvent ➜ WeatherBloc ➜ WeatherState ➜ UI
Key Components:
🧩 WeatherBloc – Handles events and manages weather state
🌐 WeatherApiService – Manages communication with WeatherAPI.com
⚡ WeatherEvent – Events (e.g., FetchWeather)
📊 WeatherState – Represents app states: loading, success, or error
⚡ Installation
Make sure Flutter SDK is installed
Clone the repository:
git clone <your-repo-url>
Navigate to the project directory:
cd weather_app
Install dependencies:
flutter pub get
Run the app:
flutter run
🌐 API
This app uses:
☁️ WeatherAPI.com for fetching real-time weather data.
📸 Screenshots
## 🖼 Screenshots

## 🌙 Dark Mode
![Weather Light](assets/screenshots/weather1.jpg)

---

## 🌙 Dark Mode
![Weather Dark](assets/screenshots/weather2.jpg)

---

## 📅 7-Day Forecast
![7-Day Forecast](assets/screenshots/weather3.jpg)

---

## 🎥 Demo Video
[▶️ Watch Demo](assets/demo/weather.demo.mp4)


🧑‍💻 About the Developer
Nazira Altybaeva
Flutter Developer passionate about creating clean, scalable, and beautiful apps.
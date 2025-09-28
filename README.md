🌤 Weather App
A Flutter app to view current weather, hourly forecast, and data for the past 7 days.
👩‍💻 Author: Flutter Developer Altybaeva Nazira
✨ Features
Current Weather – Displays temperature, conditions, and weather icon for the selected city
Hourly Forecast – Scrollable list of today’s weather in hourly intervals
7-Day Forecast – Detailed forecast for the next week
Past 7 Days History – Weather data for the previous week
City Search – Check weather in any city worldwide 🌎
🛠 Technologies
Flutter – Cross-platform framework
BLoC – State management
Equatable – For object comparison
GetIt – Dependency injection
HTTP – API requests
Intl – Date and time formatting

🏗 Architecture
The app uses the BLoC (Business Logic Component) pattern for state management:
WeatherEvent -> WeatherBloc -> WeatherState -> UI
Key Components:
WeatherBloc – Handles events and manages weather state
WeatherApiService – Service for working with WeatherAPI.com
WeatherEvent – Events (e.g., FetchWeather)
WeatherState – App state (loading, data, error)

⚡ Installation
Make sure Flutter SDK is installed
Clone the repository:
git clone <your-repo-url>
Navigate to the project directory:
cd weather_app
Install dependencies:
flutter pub get
▶ Running the App
Run the app on a connected device or emulator:
flutter run
🌐 API
The app uses:
WeatherAPI.com – For weather data
🖼 Screenshots
Current Weather
Hourly Forecast
7-Day Forecast

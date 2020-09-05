# weather_app

This app uses the dio package to get weather data from a pair of coordinates from openweathermap api. 
These coordinates are retrieved from the Geolocator package, either from getting a user's current location 
or getting coordinates from a specified location.
The service called Location utilizes the Geolocator package and has methods that assign the coordinates and the name of the location to its properties.

The weather data from the api is an hourly forecast for the next 48 hours and a daily forecast for the next 7 days.
The service called Weather is constructed with two booleans, isFahrenheit and isFullMoon, to specify the user's preferences.
The service then uses many algorithms to assign values from the api into various lists which are given the Weather Screen.
Once in the weather screen, the Shared Preferences package is used to store the user's current and specified locations on the disk, with their temporary data values.

This app also makes use of the Flutter SpinKit package and the Smooth Page Indicators package to display spinning rings when the data comes in, and
a dot indicator indicating what page the user is in the PageView().builder, which displays the next seven days worth of weather data.


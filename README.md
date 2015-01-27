# CodeChallenge3
Divvy Station Finder

The purpose of this app is to provide the user with a list of divvy bike locations along with the number of bikes currently at each station. A user can pick a bike
location and a map will be displayed showing its location.

To get this information use api call for the city of your cohort. *Note that these apis do not require any setup or authentication keys.
CHICAGO: http://www.divvybikes.com/stations/json/ SAN FRANCISCO: http://www.bayareabikeshare.com/stations/json

Before you begin:

Unzip the Challenge folder downloaded from learn.mobilemakers.co. A project (named CodeChallenge3) has already been created for you. All of the viewcontrollers
and views you need in storyboard have already been created and hooked up appropriately. Complete the challenge using this project.
Your application should do the following:

1. When the app first launches it should show the list of divvy bike locations in the order it is received from the divvy api. At a minimum, each station listed should
include its name (stAddress1) and number of available bikes (availableBikes).

2. When the user taps on a divvy station, a map view should be presented showing the divvy bike location in the center of the map. Scale the map to a span of
around .05 x .05 for lat and long. (Note: An image for this, named “bikeImage”, has already been added to the project’s Images.xcassets folder)

3. When the app launches, it should also determine the user’s current location and show this on the map as well. (Note: The NSLocationAlwaysUsageDescription
key and value have already been added to the plist.)

4. When the user taps on the divvy location, the location name should show along with an information button to the right. When this button is tapped, an alert
view should display giving the textual directions to the divvy station from your current location.

5. Allow the user to search for a specific station name by entering text in the UISearchBar. As each character is typed the list of items shown in the tableview
should be reduced to only show the stations that contain the string entered in the search bar.

6. Sort the divvy stations from closest to farthest from their current location. (Hint: if you have two CLLocations, you can use the method distanceFromLocation to
find this in meters.)

ios7-white-label-app
====================

Voting Information Project

Building the App
----------------

1. Install cocoapods:
```
sudo gem install cocoapods
```

2. cd to directory with podfile

3. Run:
```
pod install
```

4. Open xcode with the VotingInformationProject.xcworkspace file, rather
    than the xcodeproj file

5. In settings.plist, configure the following keys:
  * ElectionListURL
    * URL to json file that matches the form of: https://developers.google.com/civic-information/docs/us_v1/elections/electionQuery
    * Sample elections.json in xcode project

Updating the Google Maps API Key
--------------------------------

1. Login/create a google account
2. Go to: https://developers.google.com/maps/documentation/ios/start#getting_the_google_maps_sdk_for_ios
3. Follow the instructions under the section "Obtaining an API Key"
4. Open settings.plist in this xcodeproject and paste the key into the field "GoogleMapsAPIKey"

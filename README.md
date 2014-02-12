ios7-white-label-app
====================

Voting Information Project

Build Status
------------
Develop: [![Build Status](https://travis-ci.org/votinginfoproject/ios7-white-label-app.png?branch=develop)](https://travis-ci.org/votinginfoproject/ios7-white-label-app)

Building the App
----------------

1. Before opening xcode, paste your Google Civic API browser key into: CivicAPIKey.plist
between the string tag

2. Install cocoapods:
```
sudo gem install cocoapods
```

3. cd to directory with podfile

4. Run:
```
pod install
```

5. Open xcode with the VotingInformationProject.xcworkspace file, rather
    than the xcodeproj file

6. In settings.plist, configure the following keys:
  * ElectionListURL
    * URL to json file that matches the form of: https://developers.google.com/civic-information/docs/us_v1/elections/electionQuery
    * Sample elections.json in xcode project

Updating the Google Maps API Key
--------------------------------

1. Login/create a google account
2. Go to: https://developers.google.com/maps/documentation/ios/start#getting_the_google_maps_sdk_for_ios
3. Follow the instructions under the section "Obtaining an API Key"
4. Open settings.plist in this xcodeproject and paste the key into the field "GoogleMapsAPIKey"

Licenses
--------

The VIP App uses:
  * MagicalRecord: MIT License
  * AFNetworking: MIT License

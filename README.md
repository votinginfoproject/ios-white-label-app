ios7-white-label-app
====================

Voter Information Project

To build/develop:

1. Install cocoapods:
```
sudo gem install cocoapods
```

2. cd to directory with podfile

3. Run:
```
pod install
```

4. Open xcode with the VoterInformationProject.xcworkspace file, rather
    than the xcodeproj file

5. In settings.plist, configure the following keys:
  * ElectionListURL
    * URL to json file that matches the form of: https://developers.google.com/civic-information/docs/us_v1/elections/electionQuery
    * Sample elections.json in xcode project

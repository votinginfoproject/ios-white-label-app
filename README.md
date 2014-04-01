# ios7-white-label-app

Develop: [![Build Status](https://travis-ci.org/votinginfoproject/ios7-white-label-app.png?branch=develop)](https://travis-ci.org/votinginfoproject/ios7-white-label-app)


## Building/Running the App


### Project Dependencies

First you must install the package manager CocoaPods on your Mac:  
http://cocoapods.org/

```
sudo gem install cocoapods
```


### Setting up the project

First, clone the repository and cd to the project root directory (the directory with this README)

Then, install the project's third party libraries via CocoaPods:

```
cd objc/VotingInformationProject && pod install
```

The project uses two plist files for configuration and they need to be copied from their template
files for use. From the objc/VotingInformationProject directory, do:

```
cd VotingInformationProject
// Your relative path should now be: 
// objc/VotingInformationProject/VotingInformationProject
cp CivicInfoAPIKey.plist.template CivicInfoAPIKey.plist
cp settings.plist.template settings.plist
```

The defaults for the settings.plist file should work, but can be configured.  
See SETTINGS.md file for details.

In order to access the Google Voting Information API, you will need an API browser key.  
Follow the instructions below in the section 'Updating the Civic Info API Key',  
then paste the key into your CivicInfoAPIKey.plist file where indicated.


### Running the project

In the objc/VotingInformationProject, open the project in Xcode by opening the file:

```
VotingInformationProject.xcworkspace
```

WARNING: Because the project uses CocoaPods, you must always open the project with this
.xcworkspace file. The project will not build correctly if you open the project using
the standard .xcproject file.

Once open in xcode, run the project and it will open in the simulator.


### Troubleshooting

If the project does not build or run:
  - Ensure you opened the project using the .xcworkspace file
  - Ensure you copied both the settings.plist and CivicInfoAPIKey.plist files from their templates

If no data loads:
  - Ensure you correctly copied your browser Civic Info API key to the proper location (between the <string> tags) in the CivicInfoAPIKey.plist file.


## Adding Tracking via Google Analytics

Generate a tracking ID for your app here:
https://www.google.com/analytics/web/?hl=en

Select new mobile application and follow the prompts.
Once you have a Tracking ID (UA-XXXXXXXX-X) paste it into settings.plist as value for key GoogleAnalyticsTrackingID.


## Regenerating Localized Strings File

Used: http://www.delitestudio.com/app/localizable-strings-merge/  
The default genstrings tool does not recursively search .m files or handle merges well.


## Updating the Civic Info API Key

Follow the instructions in the section 'Acquiring and using an API Key' here:  
https://developers.google.com/civic-information/docs/using_api

Ensure you select and generate a 'browser key'.


## Updating the Google Maps API Key

Login or create a google account, then go to:  
https://developers.google.com/maps/documentation/ios/start#getting_the_google_maps_sdk_for_ios

Follow the instructions under the section "Obtaining an API Key"  
Copy the newly generated API key and paste between the string tags for the key GoogleMapsAPIKey in settings.plist


## Licenses

The VIP App uses:
  - MagicalRecord: MIT License
  - AFNetworking: MIT License

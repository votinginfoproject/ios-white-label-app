### settings.plist configuration options

**Key:** ElectionID  
**Value:** *(String)* The election id to display as default in the app. If not set, the app defaults to the future election closest to the current date.

**Key:** ElectionListURL  
**Value:** *(String)* The url to get the election list from. The election list must be in the format of the election query from the Google Civic Info API.

**Key:** GoogleMapsAPIKey  
**Value:** *(String)* The key to use to initialize the Google Maps API for the polling list map view.

**Key:** GoogleAnalyticsTrackingID  
**Value:** *(String)* The key to use to initialize the Google Analytics SDK for app tracking.

**Key:** GoogleDirectionsAPIKey  
**Value:** *(String)* The key to use for calls to the Google Directions API.

**Key:** BrandNameText  
**Value:** *(String)* The brand name to display on the app homepage.

**Key:** VotingInfoCacheDays  
**Value:** *(Int)* The number of days to cache votingInfo queries. If not set, no caching is done.

**Key:** OfficialOnly  
**Value:** *(Bool)* Sets the API query param officialOnly. If false, unoffiical sources will be returned and displayed via the API.


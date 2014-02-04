Last.fm
========

Last.fm is a music recommendation service. You use Last.fm by signing up and downloading The Scrobbler, which helps you discover more music based on the songs you play.

#API

__You need to make a free API account to use any of the following__

Base URL
```
  http://ws.audioscrobbler.com/
```

##Chart

* [Top Tracks](http://www.last.fm/api/show/chart.getTopTracks)
  
    
  * Parameters 
    ```
    page (Optional) : The page number to fetch. Defaults to first page.

    limit (Optional) : The number of results to fetch per page. Defaults to 50.
    
    api_key (Required) : A Last.fm API key.
    ```
    
  * URL
    * Method: chart.gettoptracks
  
    Example
    ```
      /2.0/?method=chart.gettoptracks&api_key=XXXXXXXXXXXXXXXXXXXX&format=json
    ```
    
  * Errors
    ```
    2 : Invalid service - This service does not exist
    3 : Invalid Method - No method with that name in this package
    4 : Authentication Failed - You do not have permissions to access the service
    5 : Invalid format - This service doesn't exist in that format
    6 : Invalid parameters - Your request is missing a required parameter
    7 : Invalid resource specified
    8 : Operation failed - Something else went wrong
    9 : Invalid session key - Please re-authenticate
    10 : Invalid API key - You must be granted a valid key by last.fm
    11 : Service Offline - This service is temporarily offline. Try again later.
    13 : Invalid method signature supplied
    16 : There was a temporary error processing your request. Please try again
    26 : Suspended API key - Access for your account has been suspended, please contact Last.fm
    29 : Rate limit exceeded - Your IP has made too many requests in a short period
    ``` 

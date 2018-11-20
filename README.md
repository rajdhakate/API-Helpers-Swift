# API-Helpers-Swift
API Helpers for Networking in iOS App. Swift version

## REQUISITE : [AFNetworking 3.1.0+](https://github.com/AFNetworking/AFNetworking/)

## HOW TO ADD: 

Drag drop API Helpers into your Project.

## HOW TO USE:

1. ```import MyWebserviceManager```

2. Set your ```LOCAL AND HOSTING SERVER``` links.

3. Create ```MyWebserviceManager``` instance. Set ```delegate``` to your view controller.

4. Set your ```parameters``` as ```Dictionary```.

5. Set what type of log you want by ```logType``` = ```.None, .Default, .URLOnly, .URLWithResponse```

6. Call instance method ```callMyWebServiceManager``` .

- 

7. Implement two required delegate methods. ```processCompleted``` & ```processFailed```.

8. [Optional] ```processOnGoing```

# Support

Suggestions/Queries/Feedbacks are welcome.

Feel free to contribute in anyway.


CHEERS!

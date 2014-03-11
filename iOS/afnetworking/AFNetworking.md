AFNetworking
===========

A delightful iOS and OS X networking framework.


Pod information 
```
pod 'AFNetworking', '~> 2.1.0'
```

Import library 
```objective-c
#import <AFNetworking/AFNetworking.h>
```

#Simple Request

	This is an example of how to make an HTTP request with AFNetworking.

```objective-c
NSMutableURLRequest* req = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@/example/path",SERVER_URL]]];
[req setHTTPMethod:@"GET"];
    
AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:req];
[operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {

}failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        	NSLog(@"Error: %@",error);
}];	

```

//
//  WebServiceHelper.m
//  SmartCard
//
//  Created by Sohrab Hussain on 11/13/13.
//

#import "WebServiceHelper.h"
@interface WebServiceHelper ()

@end

@implementation WebServiceHelper
@synthesize delegate;

-(void)postMethodWithURL:(NSString *)URLString :(NSData *)dataToUpload
{
    
//    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
//    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
//    if (networkStatus == NotReachable)
//    {
//        // Password Required
//        if (isArabicMode) {
//            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"خطأ" message:@"لا اتصال إنترنت موجود" delegate:self cancelButtonTitle:@"حسنا" otherButtonTitles:nil, nil];
//            [alert show];
//
//        }
//        else
//        {
//            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"No Internet Connectivity Found." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
//            [alert show];
//
//        }
//    }
//    else
//    {
//        
//    }
    

    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setHTTPMethod:@"POST"];
    [request setURL:[NSURL URLWithString:URLString]];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:dataToUpload];
    
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               NSString* newStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                               SBJsonParser *json = [SBJsonParser new];
                               NSError *jsonError;
                               NSDictionary *new=[json objectWithString:newStr error:&jsonError];
                               // NSLog(@"COUNT %@ = %lu",viewName, [new count]);
                               [delegate finished:new];
                           }];

}

-(void)getMethodWithURL:(NSString *)URLString
{
    NSLog(@"URL SENT = %@",URLString);
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setHTTPMethod:@"GET"];
    [request setURL:[NSURL URLWithString:URLString]];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               NSString* newStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                               SBJsonParser *json = [SBJsonParser new];
                               NSError *jsonError;
                               NSDictionary *new=[json objectWithString:newStr error:&jsonError];
                               // NSLog(@"COUNT %@ = %lu",viewName, [new count]);
                               [delegate finished:new];
                           }];

}
@end

//
//  WebServiceHelper.h
//  SmartCard
//
//  Created by Sohrab Hussain on 11/13/13.

//

#import <UIKit/UIKit.h>
#import "SBJson.h"

@protocol WsCompleteDelegate
-(void) finished:(NSDictionary*)data;
@end

@interface WebServiceHelper : UINavigationController
{
    NSMutableData *receivedData;
    NSDictionary *parsedJSON;
    
    id <WsCompleteDelegate> delegate;
}

@property (retain, nonatomic) id <WsCompleteDelegate> delegate;

-(void)postMethodWithURL:(NSString *)URLString :(NSData *)dataToUpload;
-(void)getMethodWithURL:(NSString *)URLString;


@end

//
//  InfoWindowView.h
//  ERES-MAP
//
//  Created by Sohrab Hussain on 20/12/14.
//  Copyright (c) 2014 DLD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InfoWindowView : UIView

@property (nonatomic, retain) IBOutlet UILabel *lblName;
@property (nonatomic, retain) IBOutlet UILabel *lblEmail , *lblPhone , *lblMobile, *lblFax;
@property (nonatomic, retain) IBOutlet UITextView *tvAddress;


@end

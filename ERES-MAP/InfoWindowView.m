//
//  InfoWindowView.m
//  ERES-MAP
//
//  Created by Sohrab Hussain on 20/12/14.
//  Copyright (c) 2014 DLD. All rights reserved.
//

#import "InfoWindowView.h"

@implementation InfoWindowView

- (id)init
{
    // NOTE: If you don't know the size, you can work this out after you load the nib.
    //self = [super initWithFrame:CGRectMake(0, 0, 300, 83)];
    
    if (self)
    {
        // Load the nib using the instance as the owner.
        NSArray *xib = [[NSBundle mainBundle] loadNibNamed:@"InfoWindowView" owner:self options:nil];
        return [xib objectAtIndex:0];
    }
    return self;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

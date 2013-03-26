//
//  interval.h
//  circleOfFifths
//
//  Created by Gwendolyn Weston on 11/1/12.
//  Copyright (c) 2012 GLW. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface interval : NSObject
@property int frequency;
@property int cents;
@property NSString *intervalType;
@property NSString *noteName;

@end

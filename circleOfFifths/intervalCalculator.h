//
//  intervalCalculator.h
//  circleOfFifths
//
//  Created by Gwendolyn Weston on 11/1/12.
//  Copyright (c) 2012 GLW. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "scaleCalculator.h"
#import "interval.h"

@interface intervalCalculator : NSObject
-(NSMutableArray *)intervalArray: (NSArray*)givenScale;
-(void)calculateDifferenceBetweenPythag:(NSMutableArray *)scaleOne andEven:(NSMutableArray*)scaleTwo andHarmonic: (NSMutableArray*)scaleThree;
+(void)determineTypeAndName: (int)index forInterval: (interval*)interval;

@end

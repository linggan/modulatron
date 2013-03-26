//
//  evenCalculator.h
//  circleOfFifths
//
//  Created by Gwendolyn Weston on 10/21/12.
//  Copyright (c) 2012 GLW. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "scaleCalculator.h"

@interface evenCalculator : NSObject{}

+(double *) generateChromaticScaleWithoutOctave: (int)fundamental;
+(double) getFreq:(int) step: (double*)scale;
+(int)getMajScale: (int)step;


@end

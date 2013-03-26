//
//  intervalCalculator.m
//  circleOfFifths
//
//  Created by Gwendolyn Weston on 11/1/12.
//  Copyright (c) 2012 GLW. All rights reserved.
//

#import "intervalCalculator.h"
#import "interval.h"
#include <math.h>

@implementation intervalCalculator

// MAIN FUNCTIONS
-(NSMutableArray *)intervalArray: (NSArray *)givenScale{
    NSMutableArray* intervalArr = [[NSMutableArray alloc]init];
    int fund = [(NSNumber *)[givenScale objectAtIndex:0] intValue];

    int i;
    
    for (i = 0; i<=12; i++){
        interval* newInterval = [[interval alloc]init];
        int freq = [(NSNumber *)[givenScale objectAtIndex:i] intValue];
        [newInterval setFrequency:freq];
        [newInterval setCents:round(1200*(log2((double)freq/fund)))];
        [intervalCalculator determineTypeAndName:i forInterval:newInterval];
        [intervalArr addObject:newInterval];
    }
    
    return intervalArr;
    
}
-(void)calculateDifferenceBetweenPythag:(NSMutableArray *)scaleOne andEven:(NSMutableArray*)scaleTwo andHarmonic:(NSMutableArray*)scaleThree{
    int i;
    
    for (i = 0; i<=12; i++){
        interval* fromOne = [scaleOne objectAtIndex:i];
        interval* fromTwo = [scaleTwo objectAtIndex:i];
        interval* fromThree = [scaleThree objectAtIndex:i];


        NSLog(@"for %@ , pythag is %i, even is %i, difference is %i\n",[fromOne intervalType], fromOne.cents, fromTwo.cents, abs(fromOne.cents-fromTwo.cents));
        NSLog(@"for %@ , pythag is %i, harmonic is %i, difference is %i\n",[fromOne intervalType], fromOne.cents, fromTwo.cents, abs(fromOne.cents-fromThree.cents));
        NSLog(@"for %@ , harmonic is %i, even is %i, difference is %i\n\n",[fromThree intervalType], fromOne.cents, fromTwo.cents, abs(fromThree.cents-fromTwo.cents));
    }

}


//HELPER FUNCTIONS
+(void *)determineTypeAndName: (int)index forInterval: (interval*)interval{
    if (index == 0){
        [interval setIntervalType:[NSString stringWithFormat:@"root"]];
        [interval setNoteName:[NSString stringWithFormat:@"C"]];
    }
    if (index == 1){
        [interval setIntervalType:[NSString stringWithFormat:@"m2"]];
        [interval setNoteName:[NSString stringWithFormat:@"C"]];
    }
    if (index == 2){
        [interval setIntervalType:[NSString stringWithFormat:@"M2"]];
        [interval setNoteName:[NSString stringWithFormat:@"C"]];
    }
    if (index == 3){
        [interval setIntervalType:[NSString stringWithFormat:@"m3"]];
        [interval setNoteName:[NSString stringWithFormat:@"C"]];
    }
    if (index == 4){
        [interval setIntervalType:[NSString stringWithFormat:@"M3"]];
        [interval setNoteName:[NSString stringWithFormat:@"C"]];
    }
    if (index == 5){
        [interval setIntervalType:[NSString stringWithFormat:@"P4"]];
        [interval setNoteName:[NSString stringWithFormat:@"C"]];
    }
    if (index == 6){
        [interval setIntervalType:[NSString stringWithFormat:@"TT"]];
        [interval setNoteName:[NSString stringWithFormat:@"C"]];
    }
    if (index == 7){
        [interval setIntervalType:[NSString stringWithFormat:@"P5"]];
        [interval setNoteName:[NSString stringWithFormat:@"C"]];
    }
    if (index == 8){
        [interval setIntervalType:[NSString stringWithFormat:@"m6"]];
        [interval setNoteName:[NSString stringWithFormat:@"C"]];
    }
    if (index == 9){
        [interval setIntervalType:[NSString stringWithFormat:@"M6"]];
        [interval setNoteName:[NSString stringWithFormat:@"C"]];
    }
    if (index == 10){
        [interval setIntervalType:[NSString stringWithFormat:@"m7"]];
        [interval setNoteName:[NSString stringWithFormat:@"C"]];
    }
    if (index == 11){
        [interval setIntervalType:[NSString stringWithFormat:@"M7"]];
        [interval setNoteName:[NSString stringWithFormat:@"C"]];
    }
    if (index == 12){
        [interval setIntervalType:[NSString stringWithFormat:@"octave"]];
        [interval setNoteName:[NSString stringWithFormat:@"C"]];
    }
}


@end

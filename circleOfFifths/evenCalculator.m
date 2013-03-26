//
//  evenCalculator.m
//  circleOfFifths
//
//  Created by Gwendolyn Weston on 10/21/12.
//  Copyright (c) 2012 GLW. All rights reserved.
//

#import "evenCalculator.h"
#import "chord.h"

@implementation evenCalculator

//MAIN FUNCTIONS


+(double *) generateChromaticScaleWithoutOctave: (int)fundamental{
    double *scale = malloc(12*sizeof(double));
    
    double factor = 1.0594630943592953;
    double fund = (double)fundamental;
    
    int i;
    // 1 octave
    for (i = 0; i <=11 ; i ++){
        scale[i] = fund*factor;
        fund = fund*factor;
    }
    
    return scale;
}

+(double) getFreq:(int) step: (double*)scale{
    int octave;
    double freq;
    if (step < 0) {
        octave = step / 12 - 1;
        step = 12 - (abs(step) % 12);
        if ((step%12)==0) {
            octave++;
            step = 0;
        }
    }
    else {
        octave = step / 12;
        step = step % 12;
    }
    freq = scale[step];
    return freq * pow((float)2,(int)octave);
}



//HELPER FUNCTIONS
+(int)getMajScale: (int)step {
    int  majorMap[7] = { 0, 2, 4, 5, 7, 9, 11};
    int octave;
    
    
    if (step < 0) {
        octave = step / 7 - 1;
        step = 7 - (abs(step) % 7);
        if ((step%7)==0) {
            octave++;
            step = 0;
        }
    }
    else {
        octave = step / 7;
        step = step % 7;
    }
    
    return majorMap[step] + octave * 12;
}
@end

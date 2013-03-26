//
//  chord.m
//  circleOfFifths
//
//  Created by Gwendolyn Weston on 10/21/12.
//  Copyright (c) 2012 GLW. All rights reserved.
//

#import "chord.h"
#import "evenCalculator.h"



@implementation getChord



+(int)determinModDirection:(int)root:(int)newRoot {
    
    int circleFifth[12] = {0, 7, 2, 9, 4, 11, 6, 1, 8, 3, 10, 5};
    int key1 = circleFifth[root%12];
    int key2 = circleFifth[newRoot%12];
    int a, b;
    
    a = (key1 - key2);
    a = [self mod:a:12];
    b = (key2 - key1);
    b = [self mod:b:12];
    
    
    if(a > b) {
        printf("dir: %d- up\n", b);
        return b;
        

    }
    
    else {
         printf("dir: %d- down\n", -a);
        return -a;
    }
}

+(int)modulate:(int) root:(bool)direction {
    //next key in circle of 5ths
    if (direction == UP) {
        return (root + P5TH)%12;
    }
    else {
        return [self mod:(root - P5TH):12];
    }
}

- (int) mod:(int) a: (int) b {
    int ret = a % b;
    if(ret < 0)
        ret+=b;
    return ret;
}


+(int)progress:(int)prev {
    
    int r = arc4random()%23;
    
    
    // I
    if (prev == 0){
        r = r % 3;
        if (r == 0) {
            return 0;
        }
        else {
            return 2;
        }
    }
    // ii
    else if (prev == 1){
        r = r % 2;
        if (r == 0) {
            return 4;
        }
        else {
            return 6;
        }
    }
    // iii
    else if (prev == 2){
        return 5;
    }
    
    // IV
    else if (prev == 3){
        r = r % 2;
        if (r == 0) {
            return 4;
        }
        else {
            return 6;
        }
    }
    // V
    else if (prev == 4){
        r = r % 2;
        if (r == 0) {
            return 0;
        }
        else {
            return 5;
        }
        
    }
    // vi
    else if (prev == 5){
        r = r % 2;
        if (r == 0) {
            return 1;
        }
        else {
            return 3;
        }
        
    }
    // vii
    else if (prev == 6){
        r = r % 2;
        if (r == 0) {
            return 0;
        }
        else {
            return 5;
        }
        
    }
    return 0;
    
    
}

+(void)getNextChordMajorKey:(int)step:(chord*)curChord {
    
    int chromStep = [evenCalculator getMajScale:step];
    
    step = step % 7;
    // return major chord
    if (step == 0||step == 3||
        step == 4) {
        
        [self genMajorChord:chromStep :curChord];
    }
    //return minor chord
    else if (step == 1||step == 5||
             step == 2) {
        
        [self genMinorChord:chromStep :curChord];
    }
    else if (step == 6) {
        [self genMinorChord:chromStep :curChord];
    }
    
    return;
}

int bassOffset = 24;

-(void)genMajorChord: (int)chromStep:(chord*)curChord {
    
    curChord->bass = chromStep - bassOffset;
    curChord->root = (chromStep);
    curChord->third = (chromStep + MAJ3RD);
    curChord->fifth = (chromStep + P5TH);
    
    return;
}


-(void)genMinorChord: (int)chromStep:(chord*)curChord {
    
    curChord->bass = chromStep - bassOffset;
    curChord->root = (chromStep);
    curChord->third = (chromStep + MIN3RD);
    curChord->fifth = (chromStep + P5TH);
    
    return;
}


-(void)genDimChord: (int)chromStep:(chord*)curChord {
    curChord->bass = chromStep - bassOffset;
    curChord->root = (chromStep);
    curChord->third = (chromStep + MIN3RD);
    curChord->fifth = (chromStep + TRI);
    
    return;
}

+(void)foldChord: (chord*)curChord {
    
   
    curChord->root = [self foldNote:curChord->root];
    curChord->third = [self foldNote:curChord->third];
    curChord->fifth = [self foldNote:curChord->fifth];
    
    return;
}

-(int)foldNote: (int)note {
    
    if (note >= 12 ) {
        note = note % 12;
    }
    
    return note;
}

@end

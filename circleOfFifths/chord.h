//
//  chord.h
//  circleOfFifths
//
//  Created by Gwendolyn Weston on 10/21/12.
//  Copyright (c) 2012 GLW. All rights reserved.
//

#import <Foundation/Foundation.h>
#define MAJ3RD 4
#define MIN3RD 3
#define P5TH 7
#define P4TH 5
#define TRI 6
#define UP true
#define DOWN false

typedef struct _chord {
    int bass;
    int root;
    int third;
    int fifth;
}chord;


@interface getChord

@property int distance;

+(int)determinModDirection:(int)root:(int)newRoot;
+(int)modulate:(int) root:(bool)direction;
+(void)getNextChordMajorKey:(int)step:(chord*)curChord;
+ (int) progress:(int)prev;
+(void)foldChord: (chord*)curChord;

-(void)genMajorChord: (int)step:(chord*)curChord;
-(void)genMinorChord: (int)step:(chord*)curChord;
-(void)genDimChord: (int)step:(chord*)curChord;

-(int)foldNote: (int)note;



@end

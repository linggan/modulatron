//
//  GLWViewController.h
//  circleOfFifths
//
//  Created by Gwendolyn Weston on 10/21/12.
//  Copyright (c) 2012 GLW. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "toneGenerator.h"
#import "chord.h"


@interface GLWViewController : UIViewController{
    BOOL stopPlayer;
    int origin;
    int destination;
    bool prog_on;
    toneGenerator *player;
    BOOL startMod;
}

@property (weak, nonatomic) IBOutlet UITextField *frequencyField;
@property (weak, nonatomic) IBOutlet UITextField *scaleField;
@property (weak, nonatomic) IBOutlet UITextField *directionField;


@property int fundamental;
@property int scale;
@property int direction;


- (void) startEventManager;

- (IBAction)playScale:(id)sender;
- (IBAction)playTriads:(id)sender;
- (IBAction)startProgression:(id)sender;
- (IBAction)StartAutoModulation:(id)sender;
- (void)setFreqs:(chord*)curChord:(double*)scale;
- (IBAction)stopAudio:(id)sender;



- (IBAction)StartKey:(id)sender;

- (IBAction)DestinationKey:(id)sender;

/*
- (IBAction)startProgression:(id)sender;
- (IBAction)playCircle:(id)sender;
- (IBAction)playTriads:(id)sender;

- (IBAction)playDode:(id)sender;
- (IBAction)playPtol:(id)sender;
*/
@end

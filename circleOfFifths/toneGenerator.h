//
//  toneGenerator.h
//  Part of code taken from sample code on CocoaWithLove
//

#import <UIKit/UIKit.h>
#import <AudioUnit/AudioUnit.h>
#define SAMPLE_RATE 44100
#define FRAMES_PER_BUFFER 512 

@interface toneGenerator : NSObject
{
    AudioComponentInstance outputUnit;
    
@public
    
    double startingFrameCount;
    double sineFrequencyOne;
    double sineFrequencyTwo;
    double sineFrequencyThree;
    double sineFrequencyFour;
    float amplitude;

}
- (void)playButtonPressed;
- (void)cleanUpAudio;
+ (void)EnvelopeGen:(int)framesPerBuffer:(float)play_time:(toneGenerator*)player;



@end

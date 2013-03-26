//
//  GLWViewController.m
//  circleOfFifths
//
//  Created by Gwendolyn Weston on 10/21/12.
//  Copyright (c) 2012 GLW. All rights reserved.
//

#import "GLWViewController.h"

#import "evenCalculator.h"



#import "toneGenerator.h"
#import "intervalCalculator.h"
#import "interval.h"
#import "chord.h"

@implementation GLWViewController

@synthesize frequencyField;
@synthesize scaleField;
@synthesize directionField;
float playT = 1;


- (void)viewDidLoad
{
    self->player = [[toneGenerator alloc]init];
    self->stopPlayer = false;
    self->destination = 0;
    self->prog_on = true;
    self->startMod = false;
    self->origin = 0;
    [super viewDidLoad];
    // start a new thread:
    [NSThread detachNewThreadSelector:@selector(startEventManager) toTarget:self withObject:nil];

}

- (void) startEventManager {
    while (self->prog_on) {
        while ( self->startMod) {
            [self StartAutoModulation];
            self->startMod = false;
        }
        
        
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


- (IBAction)StartAutoModulation:(id)sender {
    
    self->startMod = true;
    
    
}

- (IBAction)stopAudio:(id)sender {
    
    self->startMod = false;
    
    
}

//gets input and checks validity
-(BOOL)getInputs{
    self.fundamental = [frequencyField.text intValue];
    self.scale = [scaleField.text intValue];
    self.direction = [directionField.text intValue];
    
    if (self.fundamental <= 0 || (self.scale > 1 || self.scale < 0) || (self.direction > 1 || self.scale<0)){
        
        //calls alert that input is invalid
        NSString *msg = [NSString stringWithFormat:@"Invalid input. Please check all fields."];
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Error"
                              message:msg
                              delegate:self
                              cancelButtonTitle:@"Okay"
                              otherButtonTitles:nil, nil];
        [alert show];
        return false;
    }
    
    return true;
    
}



- (IBAction)playScale:(id)sender {
    double *scale = [evenCalculator generateChromaticScaleWithoutOctave:(float)528];
    
    //To Play the scale, uncomment this section
    
    int i;
    int deg;
    double freq;
    for(i=-13; i<=12; i++){
        deg = [evenCalculator getMajScale:i];
        freq = [evenCalculator getFreq:deg:scale];
        player->sineFrequencyOne = freq;
        player->sineFrequencyTwo = freq;
        player->sineFrequencyThree = freq;
        [player playButtonPressed];
        sleep(1);
        [player cleanUpAudio];
    }
    
}

- (IBAction)playTriads:(id)sender {
    double *scale = [evenCalculator generateChromaticScaleWithoutOctave:(float)528];
    chord curChord;
    int key = 0;
    int i = 0;
    int j = 0;
    
    
    
    [getChord getNextChordMajorKey:i :&curChord];
    [self setFreqs:&curChord : scale:key];
    [player playButtonPressed];
    
    sleep(playT);
    
    while(j < 24) {
        i++;
        [getChord getNextChordMajorKey:i :&curChord];
        [getChord foldChord:&curChord];
        [self setFreqs:&curChord : scale:key];
        sleep(playT);
        j++;
        
    }
    [player cleanUpAudio];
    //To Play the scale, uncomment this section
    
    
}

- (IBAction)startProgression:(id)sender {
    double *scale = [evenCalculator generateChromaticScaleWithoutOctave:(float)528];
    chord curChord;
    int key = 0;
    int i = 0;
    int j = 0;
    
    
    
    [getChord getNextChordMajorKey:i :&curChord];
    [self setFreqs:&curChord : scale:key];
    [player playButtonPressed];
    
    sleep(playT);
    
    while(j < 100) {
        
        i = [getChord progress:i];
        [getChord getNextChordMajorKey:i :&curChord];
        [getChord foldChord:&curChord];
        [self setFreqs:&curChord : scale:key];
        sleep(playT);
        j++;
        
    }
    [player cleanUpAudio];
    //To Play the scale, uncomment this section
    
    
}

- (void)StartAutoModulation {
    self->stopPlayer = true;
    double *scale = [evenCalculator generateChromaticScaleWithoutOctave:(float)528];
    chord curChord;
    int i = 0;
    int j = 0;
    int key = self->origin-1;
    int destinationChord =self->destination;
    static int root = 0;
    BOOL direction;
    
    
    bool  modulate = true;

    int steps;

    
    // get modulation steps to destination
    steps = [getChord determinModDirection:root:destinationChord];
    if (steps < 0) {
        direction = DOWN;
        printf("DOWN\n");
    }
    else {
        printf("UP\n");
        direction = UP;
    }
    steps = abs(steps);
    printf("steps: %d\n", steps);
    root = destinationChord;
    
    
    
    [getChord getNextChordMajorKey:i :&curChord];
    [self setFreqs:&curChord : scale:key];
    [player playButtonPressed];
    
    sleep(playT );
    
    
    while(self->startMod) {
        
        i = [getChord progress:i];
        printf("i: %d\n",i);
        [getChord getNextChordMajorKey:i :&curChord];
        [getChord foldChord:&curChord];
        [self setFreqs:&curChord : scale:key];
        sleep(playT );
        
        
        
        
        if(steps) {
            if (modulate && i==6){
                printf("modulate\n");
                if (direction == UP){
                    i = 7;
                }
                else {
                    i = 4;
                }
                printf("i: %d\n",i);
                [getChord getNextChordMajorKey:i :&curChord];
                [getChord foldChord:&curChord];
                [self setFreqs:&curChord:scale:key];
                sleep(playT);
                
                key =[getChord modulate:key:direction]%12;
                i = P5TH;
                
                steps--;
            }
        }
        j++;
        
    }
    [player cleanUpAudio];
    //To Play the scale, uncomment this section
    
    
}


- (void)setFreqs:(chord*)curChord:(double*)scale:(int)key {
    player->sineFrequencyOne = [evenCalculator getFreq:(curChord->root+key):scale];
    player->sineFrequencyTwo = [evenCalculator getFreq:(curChord->third+key):scale];
    player->sineFrequencyThree = [evenCalculator getFreq:(curChord->fifth+key):scale];
    player->sineFrequencyFour = [evenCalculator getFreq:(curChord->bass+key):scale];
    
    printf("%s\n",[self get_noteName:player->sineFrequencyOne]);
    
}


- (const char*)get_noteName:(double)freq {
    
	int octave = 0;
	int i = 0;
	float base = 13.75;
	int factor = 1;
	float testFreq;
	const char *names[12] = {"A", "A#/Bb", "B", "C", "C#/Db",
        "D", "D#/Eb", "E", "F", "F#/Gb", "G", "G#/Ab"};
    
    double *c_scale = [evenCalculator generateChromaticScaleWithoutOctave:(float)base];
    
    
    
	// find octave
	while (base * factor <= freq) {
		factor = factor * 2;
		octave++;
	}
	octave-=1;
	factor = factor / 2.;
    
	testFreq = base * factor;
	//cout << testFreq << " - " << freq << endl;
    
	i = 0;
	// find frequency below
	while (testFreq < freq) {
		//cout << i<< " - " << testFreq << " - " << freq << endl;
		testFreq = [evenCalculator getFreq:i+1:c_scale] * factor;
		i++;
        
	}
	i -= 1;
	int num;
    
   	// test if freq is closest to lower or upper bound.
   
	if (abs(freq -  [evenCalculator getFreq:i:c_scale] * factor) <
        abs(freq - [evenCalculator getFreq:i+1:c_scale] * factor)) {
		num = i % 12;
    

		//cout << "lower "<< num << endl;
        
	}
    
	else {
		num = (i + 1) % 12;
		//cout << "upper " << num << endl;
	}
    
	return names[num];
}




- (IBAction)DestinationKey:(id)sender {

    NSString *key = [sender currentTitle];

    if ([key isEqualToString:@"C"]){
        self->destination = 0;
    }
    else if ([key isEqualToString:@"C#"]){
        self->destination = 1;
    }
    else if ([key isEqualToString:@"D"]){
        self->destination = 2;
    }
    else if ([key isEqualToString:@"D#"]){
        self->destination = 3;
    }
    else if ([key isEqualToString:@"E"]){
        self->destination = 4;
    }
    else if ([key isEqualToString:@"F"]){
        self->destination = 5;
    }
    else if ([key isEqualToString:@"F#"]){
        self->destination = 6;
    }
    else if ([key isEqualToString:@"G"]){
        self->destination = 7;
    }
    else if ([key isEqualToString:@"G#"]){
        self->destination = 8;
    }
    else if ([key isEqualToString:@"A"]){
        self->destination = 9;
    }
    else if ([key isEqualToString:@"A#"]){
        self->destination = 10;
    }
    else if ([key isEqualToString:@"B"]){
        self->destination = 11;
    }
}

- (IBAction)StartKey:(id)sender {
    NSString *key = [sender currentTitle];
    
    if ([key isEqualToString:@"C"]){
        self->origin = 0;
    }
    else if ([key isEqualToString:@"C#"]){
        self->origin = 1;
    }
    else if ([key isEqualToString:@"D"]){
        self->origin = 2;
    }
    else if ([key isEqualToString:@"D#"]){
        self->origin = 3;
    }
    else if ([key isEqualToString:@"E"]){
        self->origin = 4;
    }
    else if ([key isEqualToString:@"F"]){
        self->origin = 5;
    }
    else if ([key isEqualToString:@"F#"]){
        self->origin = 6;
    }
    else if ([key isEqualToString:@"G"]){
        self->origin = 7;
    }
    else if ([key isEqualToString:@"G#"]){
        self->origin = 8;
    }
    else if ([key isEqualToString:@"A"]){
        self->origin = 9;
    }
    else if ([key isEqualToString:@"A#"]){
        self->origin = 10;
    }
    else if ([key isEqualToString:@"B"]){
        self->origin = 11;
    }
}
@end

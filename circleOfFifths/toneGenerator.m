//
//  toneGenerator.m
//  Part of code taken from sample code on CocoaWithLove
//
//

#import "toneGenerator.h"
#import <AudioToolbox/AudioToolbox.h>

//Struct that renders all the samples
OSStatus SineWaveRenderProc(void *inRefCon,
                            AudioUnitRenderActionFlags *ioActionFlags,
                            const AudioTimeStamp *inTimeStamp,
                            UInt32 inBusNumber,
                            UInt32 inNumberFrames,
                            AudioBufferList *ioData)
{
	toneGenerator *player =
    (__bridge toneGenerator *)inRefCon;
	double amplitude;// = player->amplitude;
    amplitude = 0.1;
    
    static double delta = 2.0 * M_PI  / (double)44100;
    
	double thetaOne = delta * player->sineFrequencyOne ;
    double thetaTwo = delta * player->sineFrequencyTwo;
    double thetaThree = delta * player->sineFrequencyThree;
    double thetaFour = delta * player->sineFrequencyFour;
    static int phase1 = 0;
    static int phase2 = 0;
    static int phase3 = 0;
    static int phase4 = 0;
    static int lfoPhase = 0;
    float sample1;
    float sample2;
    float sample3;
    float sample4;
    float P = 1/4.;
    
    float play_time = 1.;
    float sampleSum;
    static float delayBuffer[44100];
    static int offset =0;
    float delayedSample;
    static float lfo = 0;
    
    
    
	const int channel = 0;
	Float32 *buffer = (Float32 *)ioData->mBuffers[channel].mData;
	
	// Generate the samples
	for (UInt32 frame = 0; frame < inNumberFrames; frame++)
	{
        [toneGenerator EnvelopeGen:inNumberFrames:play_time:player];
		sample1 = sin(thetaOne*phase1);
        sample2 = sin(thetaTwo*phase2);
        sample3 = sin(thetaThree*phase3);
        sample4 = sin(thetaFour*phase4);
        
        
        sampleSum = (sample1*P+sample2*P+sample3*P + sample4*P) *player->amplitude;
        delayBuffer[(frame+offset) %44100] = sampleSum;
        //lfo = sin(lfoPhase * 15 * delta) * 7*44;
        
        delayedSample = sampleSum;//delayBuffer[(44100 +(frame - (int)lfo))%44100]*0.8 + ;
        
        
        buffer[frame] = delayedSample * 0.5;
        
        
		phase1++;
        phase2++;
        phase3++;
        phase4++;
        lfoPhase ++;
        
        
        if (sample1 == 0 && cos(sample1) == 1 && phase1 > 1){
            phase1 = 0;
        }
        
        if (sample2 == 0 && cos(sample2) == 1 && phase2 > 1){
            phase2 = 0;
        }
        if (sample3 == 0 && cos(sample3) == 1 && phase3 > 1){
            phase3 = 0;
        }
        if (sample4 == 0 && cos(sample4) == 1 && phase4 > 1){
            phase4 = 0;
        }
        if (lfo == 0 && cos(lfo) == 1 && lfoPhase > 1){
            lfoPhase = 0;
        }
    }
	offset += 512;

    
	return noErr;
}

//Error-Printing function
static void CheckError(OSStatus error, const char *operation)
{
    if (error == noErr) return;
    
    char errorString[20];
    *(UInt32 *) (errorString +1) = CFSwapInt32HostToBig(error);
    if(isprint(errorString[1]) &&isprint(errorString[2]) &&
       isprint(errorString[3]) && isprint(errorString[4])){
        errorString[0] = errorString[5] = '\'';
        errorString[6] = '\0';}
    sprintf(errorString, "%d", (int)error);
    
    fprintf(stderr, "Error: %s (%s)\n", operation, errorString);
    
    exit(1);
    
}

@implementation toneGenerator

-(void) CreateAndConnectOutputUnit {
    
    // Configure the search parameters to find the default playback output unit
	AudioComponentDescription defaultOutputDescription;
	defaultOutputDescription.componentType = kAudioUnitType_Output;
	defaultOutputDescription.componentSubType = kAudioUnitSubType_RemoteIO;
	defaultOutputDescription.componentManufacturer = kAudioUnitManufacturer_Apple;
	defaultOutputDescription.componentFlags = 0;
	defaultOutputDescription.componentFlagsMask = 0;
	
	// Get the default playback output unit
	AudioComponent defaultOutput = AudioComponentFindNext(NULL, &defaultOutputDescription);
	//NSAssert(defaultOutput, @"Can't find default output");
	
	// Create a new unit based on this that we'll use for output
	OSErr err = AudioComponentInstanceNew(defaultOutput, &outputUnit);
	
	// Set our tone rendering function on the unit
	AURenderCallbackStruct input;
	input.inputProc = SineWaveRenderProc;
	input.inputProcRefCon = (__bridge void *)(self);
	err = AudioUnitSetProperty(outputUnit,
                               kAudioUnitProperty_SetRenderCallback,
                               kAudioUnitScope_Input,
                               0,
                               &input,
                               sizeof(input));
	//NSAssert1(err == noErr, @"Error setting callback: %ld", err);
	
	// Set the format to 32 bit, single channel, floating point, linear PCM
	const int four_bytes_per_float = 4;
	const int eight_bits_per_byte = 8;
	AudioStreamBasicDescription streamFormat;
	streamFormat.mSampleRate = SAMPLE_RATE;
	streamFormat.mFormatID = kAudioFormatLinearPCM;
	streamFormat.mFormatFlags =
    kAudioFormatFlagsNativeFloatPacked | kAudioFormatFlagIsNonInterleaved;
	streamFormat.mBytesPerPacket = four_bytes_per_float;
	streamFormat.mFramesPerPacket = 1;
	streamFormat.mBytesPerFrame = four_bytes_per_float;
	streamFormat.mChannelsPerFrame = 1;
	streamFormat.mBitsPerChannel = four_bytes_per_float * eight_bits_per_byte;
	err = AudioUnitSetProperty (outputUnit,
                                kAudioUnitProperty_StreamFormat,
                                kAudioUnitScope_Input,
                                0,
                                &streamFormat,
                                sizeof(AudioStreamBasicDescription));
	//NSAssert1(err == noErr, @"Error setting stream format: %ld", err);
}


- (void)playButtonPressed{
    [self CreateAndConnectOutputUnit];
    
    CheckError(AudioOutputUnitStart(self->outputUnit), "Couldn't start output unit");
    
    AudioOutputUnitStart(outputUnit);    

}



- (void)cleanUpAudio{
cleanup:
    AudioOutputUnitStop(outputUnit);
    AudioUnitUninitialize(outputUnit);
    AudioComponentInstanceDispose(outputUnit);
}

+ (void)EnvelopeGen:(int)framesPerBuffer:(float)play_time:(toneGenerator*)player  {

    static int count = 0;
    
    // play for specified time.
	if (count <= SAMPLE_RATE * play_time) {
        
		// volume envelope to avoid clicks
		if (count < (framesPerBuffer * 20.)) {
			player->amplitude = (count /  (float)(framesPerBuffer * 20-1)) * 0.5;
		}
		else if (count > (SAMPLE_RATE * play_time - (framesPerBuffer*10 ))) {
			player->amplitude = (1 - (count - (SAMPLE_RATE * play_time - (framesPerBuffer*10 )))
                                    / (float)(framesPerBuffer*10 )) * 0.5;
		}
		else {
			player->amplitude = 0.5;
		}
	}
    count++;
    if (count == SAMPLE_RATE*play_time){
        count = 0;
    }
return;

}

@end

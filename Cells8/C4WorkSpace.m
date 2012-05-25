//
//  C4WorkSpace.m
//  cells7
//
//  Created by Gregory Debicki on 12-05-21.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "C4WorkSpace.h"
#import "SampleRecorder.h"
#import "MySample.h"

@interface C4WorkSpace ()
@property (readwrite, strong) C4Sample *audioSample;
@property (readwrite, strong) SampleRecorder *sampleRecorder;

-(void)moveWithCell: (C4Shape *)c;
-(void)oracleCircle;
-(void)oracleRecord;
-(void)resumeNormal;
-(void)printMeters;
-(void)deathWithCell: (C4Shape *)c;
-(void)removeThisCell: (C4Shape *)c;
-(void)birthFromCell: (C4Shape *)c;
-(void)addThisCell: (C4Shape *)c;
-(void)goChosenOne;


@end

@implementation C4WorkSpace{
    
    NSInteger numberOfCells;
    C4Shape *newShape;
    BOOL oracleTime;
    NSInteger chooser;
    //NSArray *cArray;
    NSMutableArray *cArray;
    UIColor *col;
    
    C4Shape *chosenOne;
    
    NSTimer *t;
}
@synthesize audioSample, sampleRecorder;

-(void)setup {
    
    col = C4GREY;
    numberOfCells = 200;
    
    //    C4Shape *c[numberOfCells];
    cArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    
    for (int i = 0; i < numberOfCells; i ++){
        NSInteger r = [C4Math randomIntBetweenA:120 andB:150];
        CGFloat theta = DegreesToRadians([C4Math randomInt:360]);
        NSInteger s = [C4Math randomIntBetweenA:5 andB:30];
        
        C4Shape *tempObject = [C4Shape ellipse:CGRectMake(r*[C4Math cos:theta] + 384, r*[C4Math sin:theta] + 512, s, s)];
        
        tempObject.fillColor = [UIColor colorWithWhite:0 alpha:0.2];
        tempObject.strokeColor = [UIColor colorWithWhite:1 alpha:0.8];
        tempObject.lineWidth = 1.5f;
        
        //[self.canvas addShape:tempObject];
        [cArray addObject:tempObject];
        [self.canvas addShape:[cArray objectAtIndex:i]];
        CGFloat delay = ((CGFloat)[C4Math randomIntBetweenA:80 andB:150])/100;
        //c[i].animationDuration = delay;
        [self performSelector:@selector(moveWithCell:) withObject:tempObject afterDelay:delay];
    }
    
    
    
    //[self performSelector:@selector(moveWithId:) withObject:[NSNumber numberWithInt:1] afterDelay:1.0f];
    
    
    newShape = [C4Shape ellipse:CGRectMake(384 - 175, 512 - 175, 350, 350)];
    [self.canvas addShape:newShape];
    newShape.fillColor = [UIColor colorWithWhite:0.5 alpha:0.2];
    newShape.strokeColor = [UIColor colorWithWhite:0 alpha:1];
    newShape.lineWidth = 10.0f;
    
    oracleTime = NO;
    [self oracleCircle];
    
}

-(void)oracleCircle {
    
    CGFloat oracle = [C4Math randomInt:100];
    if (oracle <= 15){
        oracleTime = YES;
        //C4Log(@"ORACLE TIME!!");
        [self performSelector:@selector(goChosenOne) withObject:nil afterDelay:5.0f];
    }
    else {
        oracleTime = NO;
        CGFloat delay = ((CGFloat)[C4Math randomIntBetweenA:250 andB:450])/100;
        [self performSelector:@selector(oracleCircle) withObject:nil afterDelay:delay];
    }
    
}

-(void)moveWithCell: (C4Shape *)c {
    
    if (oracleTime == NO){
        CGFloat delay = ((CGFloat)[C4Math randomIntBetweenA:250 andB:450])/100;
        c.animationDuration = delay;
        
        NSInteger stopInTheMiddle = [C4Math randomInt:50];
        if (stopInTheMiddle <= 4){
            NSInteger r = [C4Math randomInt:150];
            CGFloat theta = DegreesToRadians([C4Math randomInt:360]);
            c.center = CGPointMake(r*[C4Math cos:theta] + 384, r*[C4Math sin:theta] + 512);
        }
        else {
            NSInteger r = [C4Math randomIntBetweenA:120 andB:150];
            CGFloat theta = DegreesToRadians([C4Math randomInt:360]);
            c.center = CGPointMake(r*[C4Math cos:theta] + 384, r*[C4Math sin:theta] + 512);
        }
        
        NSInteger chance = [C4Math randomInt:100];
        if (chance == 1){
            [self performSelector:@selector(deathWithCell:) withObject:c afterDelay:delay];
        }
        if (chance == 2){
            [self performSelector:@selector(birthFromCell:) withObject:c];
            [self performSelector:@selector(moveWithCell:) withObject:c afterDelay:delay];
        }
        else {
            [self performSelector:@selector(moveWithCell:) withObject:c afterDelay:delay];
        }
        
    }
    else {
        NSInteger r = [C4Math randomIntBetweenA:130 andB:150];
        CGFloat theta = DegreesToRadians([C4Math randomInt:360]);
        CGFloat delay = ((CGFloat)[C4Math randomIntBetweenA:150 andB:200])/100;
        c.animationDuration = delay;
        c.center = CGPointMake(r*[C4Math cos:theta] + 384, r*[C4Math sin:theta] + 512);
    }
    
}

-(void)goChosenOne {
    C4Log(@"go");
    numberOfCells = [cArray count];
    chooser = [C4Math randomInt:numberOfCells];
    chosenOne = ((C4Shape*)[cArray objectAtIndex:chooser]);
    CGFloat delay = ((CGFloat)[C4Math randomIntBetweenA:250 andB:450])/100;
    chosenOne.animationDuration = delay;
    chosenOne.center = CGPointMake(384, 512);
    [self oracleRecord];
}

-(void)deathWithCell: (C4Shape *)c {
    
    CGFloat delay = ((CGFloat)[C4Math randomIntBetweenA:250 andB:450])/100;
    c.animationDuration = delay;
    c.strokeEnd = 0.0f;
    c.strokeColor = [UIColor colorWithWhite:1.0 alpha:0.0];
    //c.fillColor = C4BLUE;
    c.fillColor = [UIColor colorWithWhite:1.0 alpha:0.0];
    [self performSelector:@selector(removeThisCell:) withObject:c afterDelay:delay + 0.5f];
}

-(void)removeThisCell: (C4Shape *)c {
    [cArray removeObject:c];
    [c removeFromSuperview];
    numberOfCells = [cArray count];
    C4Log(@" - %i", numberOfCells);
    
}

-(void)birthFromCell: (C4Shape *)c {

    CGFloat x = c.center.x - (c.frame.size.width/2);
    CGFloat y = c.center.y - (c.frame.size.height/2);
    
    NSInteger s = [C4Math randomIntBetweenA:5 andB:30];
    C4Shape *tempObject = [C4Shape ellipse:CGRectMake(x, y, s, s)];
    tempObject.animationDuration = 0.0f;
    tempObject.fillColor = [UIColor colorWithWhite:0 alpha:0.2];
    tempObject.strokeColor = [UIColor colorWithWhite:1 alpha:0.8];
    tempObject.lineWidth = 1.5f;

    CGFloat delay = ((CGFloat)[C4Math randomIntBetweenA:80 andB:150])/100;
    [self performSelector:@selector(addThisCell:) withObject:tempObject afterDelay:delay];
}

-(void)addThisCell: (C4Shape *)c {
    
    [cArray addObject:c];
    [self.canvas addShape:c];
    [self performSelector:@selector(moveWithCell:) withObject:c];
    numberOfCells = [cArray count];
    C4Log(@" + %i", numberOfCells);
}


-(void) oracleRecord {
    
    [self record];
    //CGFloat oraDelay = (CGFloat)[C4Math randomIntBetweenA:200 andB:500]/100;
    CGFloat oraDelay = 5.0f;
    [self performSelector:@selector(stopRecord) withObject:nil afterDelay:oraDelay];
    [self performSelector:@selector(play) withObject:nil afterDelay:oraDelay];
    [self performSelector:@selector(resumeNormal) withObject:nil afterDelay:oraDelay*4];
    
}

-(void) printMeters {
    
    [audioSample.player updateMeters];
    //chosenOne = nil;
    //chosenOne = ((C4Shape*)[cArray objectAtIndex:chooser]);
    
    CGFloat alpha = pow (10, (0.05 *[audioSample.player averagePowerForChannel:0]));
    @try {
        newShape.animationDuration = 0.0f;
        newShape.lineWidth = (alpha * 100) + 10.0f;
        
        if (oracleTime == YES){
            chosenOne.animationDuration = 0.0f;
            chosenOne.strokeColor = C4GREY;
            chosenOne.lineWidth = (alpha * 100);
        }
        else {
            chosenOne.animationDuration = 0.5f;
            chosenOne.lineWidth = 0.5f;
            chosenOne.fillColor = [UIColor colorWithWhite:1 alpha:0.7];
            chosenOne = nil;   ///not sure if this is right***
        }
        
    } @catch (NSException *e) {
    }
    
}


-(void) resumeNormal {
    oracleTime = NO;
    for (int i = 0; i < numberOfCells; i++){
        C4Shape *every = ((C4Shape*)[cArray objectAtIndex:i]);
        [self performSelector:@selector(moveWithCell:) withObject:every];
    }
    [self oracleCircle];
}


-(void) record {
    sampleRecorder = nil;
    sampleRecorder = [SampleRecorder new];
    if (sampleRecorder != nil){
        [sampleRecorder recordSample];
    }
    else {
        C4Log(@"fail");
    }
}

-(void) stopRecord {
    [sampleRecorder stopRecording];
}

-(void) play {
    
    if (self.audioSample.isPlaying == YES)
        [self.audioSample stop];
    self.audioSample = nil;
    self.audioSample = sampleRecorder.sample;
    if(self.audioSample != nil) {
        [self.audioSample play];
        self.audioSample.loops = YES;
        self.audioSample.meteringEnabled = YES;
        if (t != nil){
            [t invalidate];
        }
        t = [NSTimer timerWithTimeInterval:0.05f target:self selector:@selector(printMeters) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:t forMode:NSDefaultRunLoopMode];
    }
    else
        C4Log(@"something went wrong with setting the new sample");
}

-(void) stop {
    self.audioSample.loops = NO;
    [self.audioSample stop];
}



//record sample
//make array of sampleRecorders/audioPlayers/whateverthefuck.

//play sample (with metering)  while everyone else records a random bit
//everyone else records random fragments
//everyone gets back to moving around just looping their samples with random volume
//when oracletime happens again, everyone slowly fades out while the chosenone records again
//rinse, repeat.


@end

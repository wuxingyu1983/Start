//
//  MultitouchLayer.m
//  start
//
//  Created by 吴星煜 on 16/6/9.
//  Copyright © 2016年 imixun. All rights reserved.
//

#import "MultitouchLayer.h"

@interface MultitouchLayer()
{
    CFMutableDictionaryRef  touchBeginPoints;
    NSUInteger              iTouchPoints;
    BOOL                    bFiveTouched;
}

@end

@implementation MultitouchLayer

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        self.multipleTouchEnabled = YES;
        bFiveTouched = NO;
        
        touchBeginPoints = CFDictionaryCreateMutable(NULL, 0, &kCFTypeDictionaryKeyCallBacks, NULL);
        iTouchPoints = 0;
    }
    return self;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    //    NSLog(@"touchesBegan : the touch count is %lu", (unsigned long)[touches count]);
    if ([touches count] > 0) {
        for (UITouch *touch in touches) {
            CGPoint *point = (CGPoint *)CFDictionaryGetValue(touchBeginPoints, (__bridge const void *)(touch));
            if (point == NULL) {
                point = (CGPoint *)malloc(sizeof(CGPoint));
                CFDictionarySetValue(touchBeginPoints, (__bridge const void *)(touch), point);
                iTouchPoints ++;
                NSLog(@"the iTouchPoints is %lu", (unsigned long)iTouchPoints);
            }
            *point = [touch locationInView:nil];
        }
        if (5 <= iTouchPoints) {
            static dispatch_once_t onceToken;
            dispatch_once(&onceToken, ^{
                bFiveTouched = YES;
                if (self.delegate) {
                    [self.delegate fiveTouchHappened];
                }
            });
        }
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
//    NSLog(@"touchesEnded : the touch count is %lu", (unsigned long)[touches count]);
    if ([touches count] > 0) {
        for (UITouch *touch in touches) {
            CGPoint *point = (CGPoint *)CFDictionaryGetValue(touchBeginPoints, (__bridge const void *)(touch));
            if (point) {
                CFDictionaryRemoveValue(touchBeginPoints, (__bridge const void *)(touch));
                iTouchPoints --;
                NSLog(@"the iTouchPoints is %lu", (unsigned long)iTouchPoints);
                if (2 > iTouchPoints && bFiveTouched) {
                    if (self.delegate) {
                        [self.delegate fiveTouchReleased];
                    }
                    bFiveTouched = NO;
                }
            }
        }
    }
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
//    NSLog(@"touchesCancelled : the touch count is %lu", (unsigned long)[touches count]);
    if ([touches count] > 0) {
        for (UITouch *touch in touches) {
            CGPoint *point = (CGPoint *)CFDictionaryGetValue(touchBeginPoints, (__bridge const void *)(touch));
            if (point) {
                CFDictionaryRemoveValue(touchBeginPoints, (__bridge const void *)(touch));
                iTouchPoints --;
                NSLog(@"the iTouchPoints is %lu", (unsigned long)iTouchPoints);
            }
        }
    }
}

@end

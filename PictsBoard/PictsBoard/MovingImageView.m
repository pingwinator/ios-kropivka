//
//  MovingImageView.m
//  PictsBoard
//
//  Created by Michail Kropivka on 27.08.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MovingImageView.h"

@interface MovingImageView ()<UIGestureRecognizerDelegate>

@property (nonatomic,assign) NSMutableSet* activeRecognizers;
@property (nonatomic,assign) CGAffineTransform referenceTransform;

@end


@implementation MovingImageView

@synthesize distance;
@synthesize angle;
@synthesize position;
@synthesize rotation;
@synthesize pinch;
@synthesize pan;

@synthesize activeRecognizers;
@synthesize referenceTransform;

-(void) dealloc {
    [rotation release];
    [pinch release];
    [pan release];
    
    [super dealloc];
}

- (id)initWithImage:(UIImage *)image
{ 
    self = [super initWithImage:image];
    
    self.angle = 0;
    
    self.userInteractionEnabled = YES;
    self.multipleTouchEnabled = YES;

    self.position = CGPointMake( self.frame.origin.x, self.frame.origin.y );
    
    self.rotation = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)]; 
    self.rotation.delegate = self;
    [self addGestureRecognizer:self.rotation];
    
    self.pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
    self.pinch.delegate = self;
    [self addGestureRecognizer:self.pinch];
    
    self.pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
    self.pan.delegate = self;
    [self addGestureRecognizer:self.pan];
    
    self.activeRecognizers = [[NSMutableSet alloc] init];
    
    return self;
}

#pragma mark - Gestures

- (IBAction)handleGesture:(UIGestureRecognizer *)recognizer
{
    
    switch (recognizer.state) {
        case UIGestureRecognizerStateBegan:
            if ([activeRecognizers count] == 0)
                self.referenceTransform = self.transform;
            [activeRecognizers addObject:recognizer];
            break;
            
        case UIGestureRecognizerStateEnded:
            self.referenceTransform = [self applyRecognizer:recognizer toTransform:self.referenceTransform];
            [activeRecognizers removeObject:recognizer];
            break;
            
        case UIGestureRecognizerStateChanged: {
            CGAffineTransform transform = self.referenceTransform;
            for (UIGestureRecognizer *recognizer in activeRecognizers)
                transform = [self applyRecognizer:recognizer toTransform:transform];
            self.transform = transform;
            break;
        }
            
        default:
            break;
    }
}

- (CGAffineTransform)applyRecognizer:(UIGestureRecognizer *)recognizer toTransform:(CGAffineTransform)transform
{
    if ([recognizer respondsToSelector:@selector(rotation)])
    {
        return CGAffineTransformRotate(transform, [(UIRotationGestureRecognizer *)recognizer rotation]);
    }
    else if ([recognizer respondsToSelector:@selector(scale)]) 
    {
        CGFloat scale = [(UIPinchGestureRecognizer *)recognizer scale];
        return CGAffineTransformScale(transform, scale, scale);
    }
    else if( [recognizer isKindOfClass:[UIPanGestureRecognizer class]])
    {
        CGPoint point = [(UIPanGestureRecognizer*)recognizer translationInView:self];
        return CGAffineTransformTranslate(transform, point.x, point.y);  
    }
    else
        return transform;
}

#pragma mark - UIGestureRecognizerDelegate

// ensure that the pinch and rotate gesture recognizers on a particular view can all recognize simultaneously
// prevent other gesture recognizers from recognizing simultaneously
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
       // if either of the gesture recognizers is the long press, don't allow simultaneous recognition
    if ([gestureRecognizer isKindOfClass:[UILongPressGestureRecognizer class]] || [otherGestureRecognizer isKindOfClass:[UILongPressGestureRecognizer class]])
        return NO;
    
    return YES;
}


@end

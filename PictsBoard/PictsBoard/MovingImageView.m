//
//  MovingImageView.m
//  PictsBoard
//
//  Created by Michail Kropivka on 27.08.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MovingImageView.h"
#import "GalochkaGestureRecognizer.h"

@interface MovingImageView ()<UIGestureRecognizerDelegate>

@property (nonatomic, retain) NSMutableSet* activeRecognizers;
@property (nonatomic, assign) CGAffineTransform referenceTransform;

@end


@implementation MovingImageView

@synthesize rotation;
@synthesize pinch;
@synthesize pan;
@synthesize galochka;
@synthesize tap;

@synthesize activeRecognizers;
@synthesize referenceTransform;

-(void) dealloc {
    self.rotation = nil;
    self.pinch = nil;
    self.pan = nil;
    self.tap = nil;
    self.galochka = nil;
    
    self.activeRecognizers = nil;

    [super dealloc];
}

- (id)initWithImage:(UIImage *)image
{ 
    self = [super initWithImage:image];
    
    if (self) {

        self.userInteractionEnabled = YES;
        self.multipleTouchEnabled = YES;

        self.rotation = [[[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)]autorelease]; 
        self.rotation.delegate = self;
        [self addGestureRecognizer:self.rotation];
        
        self.pinch = [[[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)]autorelease];
        self.pinch.delegate = self;
        [self addGestureRecognizer:self.pinch];
        
        self.pan = [[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)]autorelease];
        self.pan.minimumNumberOfTouches = 2;
        self.pan.maximumNumberOfTouches = 2;
        self.pan.delegate = self;
        [self addGestureRecognizer:self.pan];
        
        
        self.tap = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)]autorelease];
        self.tap.delegate = self;
        [self addGestureRecognizer:self.tap];
        
    if(0){
        self.galochka = [[[GalochkaGestureRecognizer alloc] initWithTarget:self action:@selector(handleGestureGalochka:)]autorelease];
        self.galochka.delegate = self;
        [self addGestureRecognizer:self.galochka];
    }
        self.activeRecognizers = [[NSMutableSet alloc] init];
    }
    
    return self;
}

#pragma mark - Gestures

- (void) handleGestureGalochka:(id)sender
{
        [UIView animateWithDuration:2 animations:^(void){
            self.alpha = self.alpha - 0.2;
        }];
}

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
            for (UIGestureRecognizer *recognizer1 in activeRecognizers)
                transform = [self applyRecognizer:recognizer1 toTransform:transform];
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
    else if( [recognizer isKindOfClass:[UITapGestureRecognizer class]])
    {
        NSLog(@"Tap....");
        
        [self.superview bringSubviewToFront:self];
        
        return transform;  
    }
    else if( [recognizer isKindOfClass:[GalochkaGestureRecognizer class]] )
    {
        NSLog(@"Gal recognized");

        return transform; 
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

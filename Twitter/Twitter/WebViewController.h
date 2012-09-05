//
//  WebViewController.h
//  Twitter
//
//  Created by Michail Kropivka on 04.09.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LoginerDelegate;

@class Loginer;

@interface WebViewController : UIViewController

@property (strong, nonatomic) NSString *token;
@property (weak, nonatomic) id<LoginerDelegate> delegate;

- (id) initWithUrl:(NSString*)urlin;

@end

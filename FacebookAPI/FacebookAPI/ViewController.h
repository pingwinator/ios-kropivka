//
//  ViewController.h
//  FacebookAPI
//
//  Created by Michail Kropivka on 20.08.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RequestSender;

@interface ViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIButton *button;
@property (strong, nonatomic) IBOutlet UITextField *status;
@property (strong, nonatomic) RequestSender* requestSender;
@property (strong, nonatomic) IBOutlet UIButton *sentPhoto;

- (IBAction)buttonPressed:(id)sender;
- (IBAction)showProfilePressed:(id)sender;
- (IBAction)tapIn:(id)sender;
- (IBAction)sentPhoto:(id)sender;


@end

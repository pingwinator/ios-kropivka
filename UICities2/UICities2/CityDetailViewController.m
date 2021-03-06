//
//  CityDetailViewController.m
//  UICities2
//
//  Created by Michail Kropivka on 03.09.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CityDetailViewController.h"

@interface CityDetailViewController ()
@property (strong, nonatomic) IBOutlet UITextView *text;
@end

@implementation CityDetailViewController

@synthesize text;
@synthesize description;
@synthesize name;

#pragma mark - View lifecycle

- (void) viewDidUnload {
    
    self.text = nil;
    self.description = nil;
    self.name = nil;
    
    [super viewDidUnload];
}

- (void) viewDidLoad {
    [super viewDidLoad];
    
    self.text.text = self.description;
    self.navigationItem.title = self.name;
}

@end

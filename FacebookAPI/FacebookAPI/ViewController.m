//
//  ViewController.m
//  FacebookAPI
//
//  Created by Michail Kropivka on 20.08.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"
#import "RequestSender.h"
#import "SBJson.h"


@implementation ViewController

@synthesize button;
@synthesize status;
@synthesize requestSender;

- (IBAction)buttonPressed:(id)sender 
{
    NSString* key = @"AAACEdEose0cBACZAVptZAdpPnCvIadnhlZB29GXTP4TH1Uerrb8Hrz1eCqSEJ9pRaXZCxzjpk4uUtPZAcNT9FVox2IJROgNwtZCUbZCjmX31wJ6GpMHUz6R";
    
    NSURL* url = [[NSURL alloc] initWithString:@"https://graph.facebook.com/me/feed"];
    
    //NSDIct
       
    NSMutableDictionary * params = [[NSMutableDictionary alloc] init];
    [params setObject:status.text   forKey:@"message"];
    [params setObject:key           forKey:@"access_token"];
    
    OnFinishLoading2 block = ^(NSURLResponse *response, NSData *data, NSError *error1) {
        if ([data length] >0 && error1 == nil) 
        {
        
            SBJsonParser *parser = [[SBJsonParser alloc] init];
            
            NSString *json_string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            
            NSLog(@"%@", json_string);
            
            // parse the JSON response into an object      
            NSDictionary *answerID = [parser objectWithString:json_string error:nil];
            
            UIAlertView* alert = [[UIAlertView alloc] 
                                  initWithTitle:@"Title" 
                                  message:[answerID objectForKey:@"id"] 
                                  delegate:self  
                                  cancelButtonTitle:@"Ok" 
                                  otherButtonTitles:nil];
            [alert show];
        } 
        else if ([data length] == 0 && error1 == nil)
        { 
            NSLog(@"Nothing was downloaded.");
        } 
        else if (error1 != nil) 
        {
            NSLog(@"Error happened = %@", error1);
        } 
    };
    
    self.requestSender = [[RequestSender alloc] initWithURL:url 
                                             withHTTPMethod:@"POST" 
                                             withParameters:params 
                                                  withBlock:block];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    

}

- (void)viewDidUnload
{
    self.status = nil;
    self.button = nil;
    self.requestSender = nil;
    
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

@end

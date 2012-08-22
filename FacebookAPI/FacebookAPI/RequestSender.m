//
//  RequestSender.m
//  FacebookAPI
//
//  Created by Michail Kropivka on 21.08.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RequestSender.h"

@implementation RequestSender

@synthesize myConnection;
@synthesize resBuffer;
@synthesize myBlock;
@synthesize error;

-(void)dealloc {
    self.myConnection = nil;
    self.myBlock = nil;
    self.error = nil;
    self.resBuffer = nil;
}

-(id)initWithRequest:(NSURLRequest*)request andWithBlock:(OnFinishLoading)block
{
    self = [self init];
    
    self.myConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    self.resBuffer = [NSMutableData data];
    self.myBlock = block;
    self.error = nil;
    
    return self;
}

-(id)initWithURL:(NSURL *)url 
  withHTTPMethod:(NSString*)method 
  withParameters:(NSDictionary*)params 
       withBlock:(OnFinishLoading2)blockIn
{
    self = [super init];
    
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url]; 
    [urlRequest setHTTPMethod:method];
    
    NSData *postData = [[params asPOSTRequest] 
                        dataUsingEncoding:NSASCIIStringEncoding 
                        allowLossyConversion:YES];
    
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    
    [urlRequest setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [urlRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [urlRequest setHTTPBody:postData];

    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    [NSURLConnection sendAsynchronousRequest:urlRequest 
                                       queue:queue 
                           completionHandler:blockIn];
    
    return self;
}

#pragma mark - NSURLConnectionDataDelegate

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    if(self.myConnection != connection)
        return;
    
    if ( [(NSHTTPURLResponse*)response statusCode] > 400 ) 
    {
        self.error = [[NSError alloc] initWithDomain:@"error" code:123 userInfo:nil];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    if(self.myConnection != connection)
        return;
    
    [self.resBuffer appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    if(self.myConnection != connection)
        return;
    
    if( self.myBlock ) {
        self.myBlock( self.resBuffer, self.error );
    }
        
}

@end
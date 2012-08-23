//
//  RequestSender.h
//  FacebookAPI
//
//  Created by Michail Kropivka on 21.08.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^OnFinishLoading)(NSData*,NSError*);

#define kKey @"AAACEdEose0cBAL34dKnZCyZCx083TcOHy0DVhVtMjXmDWaGc2ZAl21rLmltxgNCbx3G3HadkftWGhciQ2ZA8nhUb88jXEsZC86vNF8WrtTX1NeHMaHJsj"

@interface RequestSender : NSObject


- (id) initWithRequest:(NSURLRequest*)request andWithBlock:(OnFinishLoading)block;

- (id) initWithURL:(NSString *)url andWithBlock:(OnFinishLoading)blockIn;

- (id) initWithURL:(NSString *)url 
  withHTTPMethod:(NSString*)method 
  withParameters:(NSDictionary*)params 
       withBlock:(OnFinishLoading)block;


@end

//
//  LogMeIn.h
//  theImage
//
//  Created by Andrew Buttigieg on 3/9/14.
//  Copyright (c) 2014 PlayerCV. All rights reserved.
//


@interface LogMeIn: NSObject

+ (BOOL)login:(NSString*)login :(NSString*)password;
+ (BOOL)logout;

@end

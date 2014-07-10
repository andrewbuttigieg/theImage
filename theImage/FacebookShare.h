//
//  FacebookShare.h
//  Player CV
//
//  Created by Andrew Buttigieg on 7/10/14.
//  Copyright (c) 2014 PlayerCV. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FacebookShare : NSObject
+ (NSDictionary*)parseURLParams:(NSString *)query;
+ (void)shareLinkWithShareDialog:(NSString *)message;
@end

//
//  ValidURL.m
//  Player CV
//
//  Created by Andrew Buttigieg on 5/25/14.
//  Copyright (c) 2014 PlayerCV. All rights reserved.
//

#import "ValidURL.h"

@implementation ValidURL

+ (BOOL)isValidUrl:(NSString *)urlString{
    if ([urlString isEqual:[NSNull null]])
        return  false;
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    return [NSURLConnection canHandleRequest:request];
}

@end

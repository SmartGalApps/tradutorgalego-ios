//
//  Parser.m
//  DicionarioGalego
//
//  Created by Xurxo Méndez Pérez on 06/01/12.
//  Copyright (c) 2012 ninguna. All rights reserved.
//

#import "Parser.h"
#import "HTMLParser.h"
#import "HTMLNode.h"

@implementation Parser

@synthesize delegate;
@synthesize text;

-(NSString *) stringByStrippingHTML:(NSString *)s {
    NSRange r;
    while ((r = [s rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound)
        s = [s stringByReplacingCharactersInRange:r withString:@""];
    return s; 
}

-(void)parse:(NSString *) theText {
    NSError *error = nil;
    HTMLParser *parser = [[HTMLParser alloc] initWithString:theText error:&error];

    if (error) {
        [self.delegate doOnError];
        return;
    }
    HTMLNode *bodyNode = [parser body];

    HTMLNode *iframe = [[bodyNode findChildTags:@"iframe"] objectAtIndex:0];
    NSString * result = [self stringByStrippingHTML:[iframe rawContents]];
    result = [result stringByReplacingOccurrencesOfString:@"unknown" withString:@"\"unknown\""];
    if ([result length] == 0)
    {
        [self.delegate doOnNotFound];
        return;
    }
    [self.delegate doOnSuccess:result translation:[iframe contents]];
}

@end

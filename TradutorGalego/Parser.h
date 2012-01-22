//
//  Parser.h
//  DicionarioGalego
//
//  Created by Xurxo Méndez Pérez on 06/01/12.
//  Copyright (c) 2012 ninguna. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ParserDelegate <NSObject>

-(void) doOnSuccess:(NSString *)translationHtml translation:(NSString *)translation;
-(void) doOnError;
-(void) doOnNotFound;

@end

@interface Parser : NSObject {
    NSString *text;
}

@property (nonatomic, retain) NSString* text;
@property (nonatomic, retain) id<ParserDelegate> delegate;

-(void)parse:(NSString *) text;

@end

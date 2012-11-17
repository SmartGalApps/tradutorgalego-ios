//
//  Helper.m
//  TradutorGalego
//
//  Created by Xurxo Méndez Pérez on 21/01/12.
//  Copyright (c) 2012 ninguna. All rights reserved.
//

#import "Helper.h"

@implementation Helper

static UIAlertView * loadingAlert;

+(void)showAlert
{
    loadingAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Translating text...", nil) 
                                              message:nil delegate:self cancelButtonTitle:nil otherButtonTitles: nil];
    [loadingAlert show];
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    
    indicator.center = CGPointMake(loadingAlert.bounds.size.width / 2, loadingAlert.bounds.size.height - 50);
    [indicator startAnimating];
    [loadingAlert addSubview:indicator];
}

+(void)dismissAlert
{
    [loadingAlert dismissWithClickedButtonIndex:0 animated:YES];
}

/*
 * Comprueba si el verbo existe en el Volga
 */
+(BOOL)existsVerb:(NSString* ) verb
{
    NSString* path = [[NSBundle mainBundle] pathForResource:@"verbosVolga" 
                                                     ofType:@"txt"];
    NSString* verbosVolga = [NSString stringWithContentsOfFile:path
                                                      encoding:NSUTF8StringEncoding
                                                         error:NULL];
    NSArray* lines = 
    [verbosVolga componentsSeparatedByCharactersInSet:
     [NSCharacterSet newlineCharacterSet]];
    for (NSString* line in lines)
    {
        if ([line caseInsensitiveCompare:verb] == NSOrderedSame)
        {
            return TRUE;
        }
    }
    return FALSE;
}
@end

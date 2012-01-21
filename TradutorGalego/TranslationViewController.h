//
//  TranlsationViewController.h
//  TradutorGalego
//
//  Created by Xurxo Méndez Pérez on 15/01/12.
//  Copyright (c) 2012 ninguna. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TranslationViewController : UIViewController {
    NSString *text;
    NSString *html;
    NSString *originalLanguage;
    NSString *destinationLanguage;
}

@property (nonatomic, retain) NSString* text;
@property (nonatomic, retain) NSString* html;
@property (nonatomic, retain) NSString* originalLanguage;
@property (nonatomic, retain) NSString* destinationLanguage;
@property (weak, nonatomic) IBOutlet UIWebView *webView;

-(void) wrapHtml;

@end

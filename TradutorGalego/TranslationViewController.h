//
//  TranlsationViewController.h
//  TradutorGalego
//
//  Created by Xurxo Méndez Pérez on 15/01/12.
//  Copyright (c) 2012 ninguna. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TranslationViewController : UIViewController {
    NSString *originalText;
    NSString *translatedText;
    NSString *html;
    NSString *originalLanguage;
    NSString *destinationLanguage;
}

@property (nonatomic, retain) NSString* originalText;
@property (nonatomic, retain) NSString* translatedText;
@property (nonatomic, retain) NSString* html;
@property (nonatomic, retain) NSString* originalLanguage;
@property (nonatomic, retain) NSString* destinationLanguage;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *defineButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *conjugateButton;

@property (weak, nonatomic) IBOutlet UIToolbar *bottomToolbar;

-(void) wrapHtml;
- (IBAction)conjugate:(id)sender;
- (IBAction)define:(id)sender;

@end

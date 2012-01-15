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
}

@property (nonatomic, retain) NSString* text;
@property (nonatomic, retain) NSString* html;
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

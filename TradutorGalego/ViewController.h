//
//  ViewController.h
//  TradutorGalego
//
//  Created by Xurxo Méndez Pérez on 15/01/12.
//  Copyright (c) 2012 ninguna. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Parser.h"

@interface ViewController : UIViewController <UITextFieldDelegate, UIActionSheetDelegate, ParserDelegate>

@property (nonatomic, retain) NSString* textFromIntegration;
@property (nonatomic, retain) NSString* translatedRawText;
@property (nonatomic, retain) NSString* translationHtml;
@property (nonatomic, retain) NSArray *languages;

@property (weak, nonatomic) IBOutlet UITextField *textTextField;
@property (weak, nonatomic) IBOutlet UIButton *searchButton;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIButton *buttonLeft;
@property (weak, nonatomic) IBOutlet UIButton *switchButton;
@property (weak, nonatomic) IBOutlet UIButton *buttonRight;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *profileButton;

- (IBAction)switchLanguage:(id)sender;
- (IBAction)selectRightLanguage:(id)sender;
- (IBAction)selectLeftLanguage:(id)sender;
- (IBAction)searchButton:(id)sender;
- (IBAction)showSelectProfile:(id)sender;

- (IBAction)showActionSheet:(id)sender;

- (void)search;

@end

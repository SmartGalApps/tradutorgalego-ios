//
//  ViewController.h
//  TradutorGalego
//
//  Created by Xurxo Méndez Pérez on 15/01/12.
//  Copyright (c) 2012 ninguna. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SelectLanguageViewController.h"

@interface ViewController : UIViewController <UITextFieldDelegate, SelectLanguageViewControllerDelegate> {
    NSString *html;
    NSMutableData* responseData;
    UIAlertView *loadingAlert;
    NSArray *languages;
}

@property (nonatomic, retain) NSString* html;
@property (nonatomic, retain) NSMutableData* responseData;
@property (nonatomic, retain) NSArray *languages;
@property (nonatomic, retain) UIAlertView *loadingAlert;
@property (weak, nonatomic) IBOutlet UITextField *termTextField;
@property (weak, nonatomic) IBOutlet UIButton *searchButton;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIButton *buttonLeft;
@property (weak, nonatomic) IBOutlet UIButton *switchButton;
@property (weak, nonatomic) IBOutlet UIButton *buttonRight;

- (IBAction)searchButton:(id)sender;
- (IBAction)switchLanguage:(id)sender;
- (IBAction)selectRightLanguage:(id)sender;
- (IBAction)selectLeftLanguage:(id)sender;

- (IBAction)grabURLInBackground:(id)sender;

-(void)search;

-(void)showAlert;
-(void)dismissAlert;
- (void)registerForKeyboardNotifications;

@end

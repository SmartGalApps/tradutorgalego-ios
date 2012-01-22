//
//  ViewController.m
//  TradutorGalego
//
//  Created by Xurxo Méndez Pérez on 15/01/12.
//  Copyright (c) 2012 ninguna. All rights reserved.
//

#import "ViewController.h"
#import "TranslationViewController.h"
#import "ASIFormDataRequest.h"
#import "Parser.h"
#import "Helper.h"
#import "CustomView.h"

@implementation ViewController
@synthesize switchButton;
@synthesize buttonRight;
@synthesize searchButton;
@synthesize scrollView;
@synthesize buttonLeft;
@synthesize termTextField;
@synthesize loadingAlert;
@synthesize languages;
@synthesize responseData;
@synthesize html;
@synthesize selected;
@synthesize translatedRawText;
@synthesize termToTranlsate;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self registerForKeyboardNotifications];
    self.languages = [[NSArray alloc] initWithObjects:@"Español", @"Catalán", @"Inglés", @"Francés", nil];
    if (self.termToTranlsate != nil) {
        [self.termTextField setText:self.termToTranlsate];
        [self.searchButton setEnabled:TRUE];
    }
}

- (void)viewDidUnload
{
    [self setTermTextField:nil];
    [self setSearchButton:nil];
    [self setScrollView:nil];
    [self setButtonLeft:nil];
    [self setSwitchButton:nil];
    [self setButtonRight:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    if (theTextField == self.termTextField) {
        [theTextField resignFirstResponder];
    }
    [self search];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    
    [self.searchButton setEnabled:newLength > 0];
    
    return (newLength > 2500) ? NO : YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	if ([segue.identifier isEqualToString:@"Translate"])
	{
        [Helper dismissAlert];
		TranslationViewController *translationViewController = 
        segue.destinationViewController;
        translationViewController.html = self.html;
        translationViewController.originalText = self.termTextField.text;
        translationViewController.translatedText = [self.translatedRawText stringByTrimmingCharactersInSet:
                                                                           [NSCharacterSet whitespaceAndNewlineCharacterSet]];;
        translationViewController.originalLanguage = [self.buttonLeft titleForState:UIControlStateNormal];
        translationViewController.destinationLanguage = [self.buttonRight titleForState:UIControlStateNormal];
	}
}

- (void)search {
    if ([self.termTextField.text length] != 0) {
        [Helper showAlert];
        [self grabURLInBackground:self];
    }
}

- (IBAction)searchButton:(id)sender {
    [self search];
}


- (IBAction)switchLanguage:(id)sender {
    UIImage *imageLeft = [self.buttonLeft imageForState:UIControlStateNormal];
    UIImage *imageRight = [self.buttonRight imageForState:UIControlStateNormal];
    NSString *buttonLeftTitle = [self.buttonLeft titleForState:UIControlStateNormal];
    NSString *buttonRightTitle = [self.buttonRight titleForState:UIControlStateNormal];
    BOOL leftEnabled = [self.buttonLeft isEnabled];
    BOOL rightEnabled = [self.buttonRight isEnabled];
    [self.buttonLeft setTitle:buttonRightTitle forState:UIControlStateNormal];
    [self.buttonLeft setImage:imageRight forState:UIControlStateNormal];
    [self.buttonRight setTitle:buttonLeftTitle forState:UIControlStateNormal];
    [self.buttonRight setImage:imageLeft forState:UIControlStateNormal];
    [self.buttonLeft setEnabled:!leftEnabled];
    [self.buttonRight setEnabled:!rightEnabled];
}

- (IBAction)selectRightLanguage:(id)sender
{
    [self showActionSheet:self];
}

- (IBAction)selectLeftLanguage:(id)sender
{
    [self showActionSheet:self];
}

-(IBAction)showActionSheet:(id)sender {
    UIActionSheet *popupQuery = [[UIActionSheet alloc] initWithTitle:@"Selecciona" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@"Español", @"Catalán", @"Ingés", @"Francés", nil];
    [[[popupQuery valueForKey:@"_buttons"] objectAtIndex:0] setImage:[UIImage imageNamed:@"bandera_small_es.png"] forState:UIControlStateNormal];
    [[[popupQuery valueForKey:@"_buttons"] objectAtIndex:1] setImage:[UIImage imageNamed:@"bandera_small_cat.png"] forState:UIControlStateNormal];
    [[[popupQuery valueForKey:@"_buttons"] objectAtIndex:2] setImage:[UIImage imageNamed:@"bandera_small_en.png"] forState:UIControlStateNormal];
    [[[popupQuery valueForKey:@"_buttons"] objectAtIndex:3] setImage:[UIImage imageNamed:@"bandera_small_fr.png"] forState:UIControlStateNormal];

    popupQuery.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [popupQuery showInView:self.view];

}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    UIButton *theButton = [self.buttonLeft isEnabled] ? self.buttonLeft : self.buttonRight;
    NSString *path;
    if (buttonIndex == 0) {
        path = [[NSString alloc] initWithString:@"bandera_small_es"];
        self.selected = @"Español";
    }
    else if (buttonIndex == 1) {
        path = [[NSString alloc] initWithString:@"bandera_small_cat"];
        self.selected = @"Catalán";
    }
    else if (buttonIndex == 2) {
        path = [[NSString alloc] initWithString:@"bandera_small_en"];
        self.selected = @"Inglés";
    }
    else if (buttonIndex == 3) {
        path = [[NSString alloc] initWithString:@"bandera_small_fr"];
        self.selected = @"Francés";
    }
    NSString* pathToImageFile = [[NSBundle mainBundle] pathForResource:path ofType:@"png"];
    UIImage *flag = [[UIImage alloc] initWithContentsOfFile:pathToImageFile];
    [theButton setImage:flag forState:UIControlStateNormal];
    [theButton setTitle:self.selected forState:UIControlStateNormal];
}


- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
}

// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    scrollView.contentInset = contentInsets;
    scrollView.scrollIndicatorInsets = contentInsets;
    
    // If active text field is hidden by keyboard, scroll it so it's visible
    // Your application might not need or want this behavior.
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbSize.height;
    if (!CGRectContainsPoint(aRect, self.termTextField.frame.origin) ) {
        CGPoint scrollPoint = CGPointMake(0.0, self.termTextField.frame.origin.y-kbSize.height);
        [scrollView setContentOffset:scrollPoint animated:YES];
    }
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    scrollView.contentInset = contentInsets;
    scrollView.scrollIndicatorInsets = contentInsets;
}

- (NSString *) getLanguageCode:(NSString*) language
{
    if ([language isEqualToString:@"Galego"]) {
        return @"GALICIAN";
    }
    if ([language isEqualToString:@"Español"]) {
        return @"SPANISH";
    }
    if ([language isEqualToString:@"Catalán"]) {
        return @"CATALAN";
    }
    if ([language isEqualToString:@"Inglés"]) {
        return @"ENGLISH";
    }
    if ([language isEqualToString:@"Francés"]) {
        return @"FRENCH";
    }
    return nil;
}

- (NSString *) getTranslationDirectionFrom:(NSString*) left to: (NSString *)right
{
    NSMutableString *result = [[NSMutableString alloc] initWithString: [self getLanguageCode:left]];
    [result appendString:@"-"];
    [result appendString:[self getLanguageCode:right]];
    return result;
}

- (IBAction)grabURLInBackground:(id)sender
{
    NSMutableString *urlString = [NSMutableString string];
    [urlString appendString:@"http://www.xunta.es/tradutor/text.do?"];
    NSString *translationDirection = [self getTranslationDirectionFrom:[self.buttonLeft titleForState:UIControlStateNormal] to:[self.buttonRight titleForState:UIControlStateNormal]];

    NSURL *url = [NSURL URLWithString:urlString];
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setPostValue:translationDirection forKey:@"translationDirection"];
    [request setPostValue:self.termTextField.text forKey:@"text"];
    [request setPostValue:@"(GV)" forKey:@"subjectArea"];
    
    if ([translationDirection rangeOfString:@"FRENCH"].location != NSNotFound ||
        [translationDirection rangeOfString:@"CATALAN"].location != NSNotFound)
    {
        [request setPostValue:@"SPANISH" forKey:@"DTS_PIVOT_LANGUAGE"];    
    }
    [request setDelegate:self];
    [request startAsynchronous];
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    // Use when fetching text data
    NSString *responseString = [request responseString];
    
    Parser *parser = [[Parser alloc] init];
    parser.text = self.termTextField.text;
    parser.delegate = self;
    [parser parse:responseString];
}

#pragma mark - ParserDelegate

-(void) doOnSuccess:(NSString *)translationHtml translation:(NSString *)translation;
{
    self.html = translation;
    self.translatedRawText = translation;
    [Helper dismissAlert];
    [self performSegueWithIdentifier:@"Translate" sender:self];
}

-(void) doOnError
{
    [Helper dismissAlert];
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void) doOnNotFound
{
    [Helper dismissAlert];
    NSMutableString *message = [[NSMutableString alloc] initWithFormat:NSLocalizedString(@"Non se atopa tradución", nil), self.termTextField.text];
    UIAlertView *info = [[UIAlertView alloc] 
                         initWithTitle:nil message:message delegate:self cancelButtonTitle:NSLocalizedString(@"Ok", nil) otherButtonTitles: nil];
    [info show];
}

#pragma end

- (void)requestFailed:(ASIHTTPRequest *)request
{
    [self doOnError];
}

@end

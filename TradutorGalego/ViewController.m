//
//  ViewController.m
//  TradutorGalego
//
//  Created by Xurxo Méndez Pérez on 15/01/12.
//  Copyright (c) 2012 ninguna. All rights reserved.
//

#import "ViewController.h"
#import "SelectLanguageViewController.h"
#import "TranslationViewController.h"
#import "ASIHTTPRequest.h"
#import "Parser.h"

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
        [self dismissAlert];
		TranslationViewController *translationViewController = 
        segue.destinationViewController;
        translationViewController.html = self.html;
        translationViewController.text = self.termTextField.text;
	}
    else if ([segue.identifier isEqualToString:@"LeftLanguage"])
    {
        SelectLanguageViewController *selectLanguageViewController = segue.destinationViewController;
        selectLanguageViewController.selected = [self.buttonLeft titleForState:UIControlStateNormal];
        selectLanguageViewController.options = self.languages;
        selectLanguageViewController.delegate = self;
    }
    else if ([segue.identifier isEqualToString:@"RightLanguage"])
    {
        SelectLanguageViewController *selectLanguageViewController = segue.destinationViewController;
        selectLanguageViewController.selected = [self.buttonRight titleForState:UIControlStateNormal];
        selectLanguageViewController.options = self.languages;
        selectLanguageViewController.delegate = self;
        
    }
}

- (void)selectLanguageViewController:
(SelectLanguageViewController *)controller 
                   didSelectLanguage:(NSString *)language
{
    
	[self.navigationController popViewControllerAnimated:YES];
    UIButton *theButton = [self.buttonLeft isEnabled] ? self.buttonLeft : self.buttonRight;
    NSString *path;
    if ([language isEqualToString:@"Español"]) {
        path = [[NSString alloc] initWithString:@"bandera_small_es"];
    }
    else if ([language isEqualToString:@"Catalán"]) {
        path = [[NSString alloc] initWithString:@"bandera_small_cat"];
    }
    else if ([language isEqualToString:@"Inglés"]) {
        path = [[NSString alloc] initWithString:@"bandera_small_en"];
    }
    else if ([language isEqualToString:@"Francés"]) {
        path = [[NSString alloc] initWithString:@"bandera_small_fr"];
    }
    NSString* pathToImageFile = [[NSBundle mainBundle] pathForResource:path ofType:@"png"];
    UIImage *flag = [[UIImage alloc] initWithContentsOfFile:pathToImageFile];
    [theButton setImage:flag forState:UIControlStateNormal];
    [theButton setTitle:language forState:UIControlStateNormal];
}

- (void)search {
    [self showAlert];
    [self grabURLInBackground:self];
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

- (IBAction)selectRightLanguage:(id)sender {
    [self performSegueWithIdentifier:@"RightLanguage" sender:self];
}

- (IBAction)selectLeftLanguage:(id)sender {
    [self performSegueWithIdentifier:@"LeftLanguage" sender:self];
}



-(void)showAlert {
    self.loadingAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Buscando tradución...", nil) 
                                                   message:nil delegate:self cancelButtonTitle:nil otherButtonTitles: nil];
    [self.loadingAlert show];
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    
    indicator.center = CGPointMake(self.loadingAlert.bounds.size.width / 2, self.loadingAlert.bounds.size.height - 50);
    [indicator startAnimating];
    [self.loadingAlert addSubview:indicator];
}

-(void)dismissAlert {
    [self.loadingAlert dismissWithClickedButtonIndex:0 animated:YES];
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

- (NSString *) getTranslationDirection:(NSString*) left: (NSString *)right
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
    
    NSString *translationDirection = [self getTranslationDirection:[self.buttonLeft titleForState:UIControlStateNormal] :[self.buttonRight titleForState:UIControlStateNormal]];
    
    [urlString appendString:@"translationDirection="];
    [urlString appendString:translationDirection];
    
    [urlString appendString:@"&text="];
    [urlString appendString:self.termTextField.text];
    
    [urlString appendString:@"&subjectArea=(GV)"];
    NSURL *url = [NSURL URLWithString:urlString];
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request setDelegate:self];
    [request startAsynchronous];
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    // Use when fetching text data
    NSString *responseString = [request responseString];
    
    Parser *parser = [[Parser alloc] init];
    parser.text = self.termTextField.text;
    self.html = [parser parse:responseString];
    [self dismissAlert];
    if ([self.html length] == 0) {
        NSMutableString *message = [[NSMutableString alloc] initWithFormat:NSLocalizedString(@"Non se atopa tradución", nil), self.termTextField.text];
        UIAlertView *info = [[UIAlertView alloc] 
                             initWithTitle:nil message:message delegate:self cancelButtonTitle:NSLocalizedString(@"Ok", nil) otherButtonTitles: nil];
        [info show];
        return;
    }
    
    [self performSegueWithIdentifier:@"Translate" sender:self];    
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    [self dismissViewControllerAnimated:YES completion:nil];
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

@end

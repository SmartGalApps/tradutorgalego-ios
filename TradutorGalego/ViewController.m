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
#import "Reachability.h"

@implementation ViewController

@synthesize switchButton;
@synthesize buttonLeft;
@synthesize buttonRight;
@synthesize profileButton;
@synthesize logoPortada;
@synthesize searchButton;
@synthesize scrollView;
@synthesize textTextField;
@synthesize languages;
@synthesize translationHtml;
@synthesize translatedRawText;
@synthesize textFromIntegration;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
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

-(void) setLandscape
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        logoPortada.frame = CGRectMake(20, 68, 150, 150);
        buttonLeft.frame = CGRectMake(178, 124, 117, 37);
        switchButton.frame = CGRectMake(298, 124, 41, 37);
        buttonRight.frame = CGRectMake(342, 124, 117, 37);
        textTextField.frame = CGRectMake(20, 222, 399, 31);
        searchButton.frame = CGRectMake(422, 219, 37, 37);
    }
    else
    {
        logoPortada.frame = CGRectMake(234, 344, 300, 300);
        buttonLeft.frame = CGRectMake(590, 475, 117, 37);
        switchButton.frame = CGRectMake(710, 475, 41, 37);
        buttonRight.frame = CGRectMake(754, 475, 117, 37);
        textTextField.frame = CGRectMake(234, 662, 591, 31);
        searchButton.frame = CGRectMake(829, 659, 37, 37);
    }
}

-(void) setPortrait
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        logoPortada.frame = CGRectMake(85, 67, 150, 150);
        buttonLeft.frame = CGRectMake(20, 235, 117, 37);
        switchButton.frame = CGRectMake(140, 235, 41, 37);
        buttonRight.frame = CGRectMake(184, 235, 117, 37);
        textTextField.frame = CGRectMake(20, 294, 235, 31);
        searchButton.frame = CGRectMake(263, 291, 37, 37);
    }
    else
    {
        logoPortada.frame = CGRectMake(234, 144, 300, 300);
        buttonLeft.frame = CGRectMake(244, 513, 117, 37);
        switchButton.frame = CGRectMake(364, 513, 41, 37);
        buttonRight.frame = CGRectMake(408, 513, 117, 37);
        textTextField.frame = CGRectMake(244, 572, 236, 31);
        searchButton.frame = CGRectMake(488, 569, 37, 37);
    }
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Comprobar si tiene perfil
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    // Get the result
    NSString *profile = [defaults stringForKey:@"tradutorGalegoProfile"];
    if (profile != nil)
    {
        if (![profile isEqualToString:@"galician"])
        {
            [self switchLanguage:self];
        }
    }
    
    [self registerForKeyboardNotifications];
    self.languages = [[NSArray alloc] initWithObjects:NSLocalizedString(@"Spanish", nil), NSLocalizedString(@"Catalan", nil), NSLocalizedString(@"English", nil), NSLocalizedString(@"French", nil), nil];
    if (self.textFromIntegration != nil) {
        [self.textTextField setText:self.textFromIntegration];
        [self.searchButton setEnabled:TRUE];
    }
}

-(BOOL) isConnected
{
    Reachability *internetReachable = [Reachability reachabilityForInternetConnection];
    return [internetReachable isReachable];
}

- (void)viewDidUnload
{
    [self setSwitchButton:nil];
    [self setButtonLeft:nil];
    [self setButtonRight:nil];
    [self setSearchButton:nil];
    [self setScrollView:nil];
    [self setTextTextField:nil];
    [self setLanguages:nil];
    [self setTranslationHtml:nil];
    [self setTranslatedRawText:nil];
    [self setTextFromIntegration:nil];
    [self setProfileButton:nil];
    [self setLogoPortada:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (UIDeviceOrientationIsLandscape(self.interfaceOrientation))
    {
        [self setLandscape];
    }
    else
    {
        [self setPortrait];        
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *profile = [defaults stringForKey:@"tradutorGalegoProfile"];

    if (profile == nil)
    {
        [self showSelectProfile:self];
    }
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
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        // Return YES for supported orientations
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    }
    else
    {
        // Return YES for supported orientations
        return YES;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    if (theTextField == self.textTextField) {
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
        translationViewController.translationHtml = self.translationHtml;
        translationViewController.originalText = self.textTextField.text;
        translationViewController.translatedText = [self.translatedRawText stringByTrimmingCharactersInSet:
                                                                           [NSCharacterSet whitespaceAndNewlineCharacterSet]];;
        translationViewController.originalLanguage = [self.buttonLeft titleForState:UIControlStateNormal];
        translationViewController.destinationLanguage = [self.buttonRight titleForState:UIControlStateNormal];
	}
}

- (NSString *) getLanguageCode:(NSString*) language
{
    if ([language isEqualToString:NSLocalizedString(@"Galician", nil)]) {
        return @"GALICIAN";
    }
    if ([language isEqualToString:NSLocalizedString(@"Spanish", nil)]) {
        return @"SPANISH";
    }
    if ([language isEqualToString:NSLocalizedString(@"Catalan", nil)]) {
        return @"CATALAN";
    }
    if ([language isEqualToString:NSLocalizedString(@"English", nil)]) {
        return @"ENGLISH";
    }
    if ([language isEqualToString:NSLocalizedString(@"French", nil)]) {
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
    [request setPostValue:self.textTextField.text forKey:@"text"];
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
    parser.text = self.textTextField.text;
    parser.delegate = self;
    [parser parse:responseString];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    [self doOnError];
}
- (void)search {
    if ([self.textTextField.text length] != 0) {
        if ([self isConnected])
        {
            [Helper showAlert];
            [self grabURLInBackground:self];
        }
        else
        {
            UIAlertView *info = [[UIAlertView alloc] 
                                 initWithTitle:nil message:NSLocalizedString(@"notConnected", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"Ok", nil) otherButtonTitles: nil];
            [info show];
        }
    }
}

- (IBAction)searchButton:(id)sender {
    [self search];
}

- (IBAction)showSelectProfile:(id)sender {
    UIActionSheet *popupQuery = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"So, where are you from?", nil) delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"I'm from Galicia", nil), NSLocalizedString(@"I'm from abroad", nil), nil];
    [[[popupQuery valueForKey:@"_buttons"] objectAtIndex:0] setImage:[UIImage imageNamed:@"bandera_small_gl.png"] forState:UIControlStateNormal];
    [[[popupQuery valueForKey:@"_buttons"] objectAtIndex:1] setImage:[UIImage imageNamed:@"bandera_small_es.png"] forState:UIControlStateNormal];
    
    [popupQuery setTag:1];
    popupQuery.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [popupQuery showInView:self.view];
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
    UIActionSheet *popupQuery = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"Select language", nil) delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"Spanish", nil), NSLocalizedString(@"Catalan", nil), NSLocalizedString(@"English", nil), NSLocalizedString(@"French", nil), nil];
    [[[popupQuery valueForKey:@"_buttons"] objectAtIndex:0] setImage:[UIImage imageNamed:@"bandera_small_es.png"] forState:UIControlStateNormal];
    [[[popupQuery valueForKey:@"_buttons"] objectAtIndex:1] setImage:[UIImage imageNamed:@"bandera_small_cat.png"] forState:UIControlStateNormal];
    [[[popupQuery valueForKey:@"_buttons"] objectAtIndex:2] setImage:[UIImage imageNamed:@"bandera_small_en.png"] forState:UIControlStateNormal];
    [[[popupQuery valueForKey:@"_buttons"] objectAtIndex:3] setImage:[UIImage imageNamed:@"bandera_small_fr.png"] forState:UIControlStateNormal];

    [popupQuery setTag:0];
    popupQuery.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [popupQuery showInView:self.view];

}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (actionSheet.tag == 0)
    {
        UIButton *theButton = [self.buttonLeft isEnabled] ? self.buttonLeft : self.buttonRight;
        NSString *path;
        NSString *languageName;
        if (buttonIndex == 0) {
            path = @"bandera_small_es";
            languageName = NSLocalizedString(@"Spanish", nil);
        }
        else if (buttonIndex == 1) {
            path = @"bandera_small_cat";
            languageName = NSLocalizedString(@"Catalan", nil);
        }
        else if (buttonIndex == 2) {
            path = @"bandera_small_en";
            languageName = NSLocalizedString(@"English", nil);
        }
        else if (buttonIndex == 3) {
            path = @"bandera_small_fr";
            languageName = NSLocalizedString(@"French", nil);
        }
        if (path != nil)
        {
        NSString* pathToImageFile = [[NSBundle mainBundle] pathForResource:path ofType:@"png"];
        UIImage *flag = [[UIImage alloc] initWithContentsOfFile:pathToImageFile];
        [theButton setImage:flag forState:UIControlStateNormal];
        [theButton setTitle:languageName forState:UIControlStateNormal];
        }
    }
    else if (actionSheet.tag == 1)
    {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        if (buttonIndex == 1)
        {
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"AppleLanguages"];        
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            // Establecer perfil a 'fromAbroad'
            [defaults setObject:@"fromAbroad" forKey:@"tradutorGalegoProfile"];
            [defaults synchronize];
            // Mirar si hay que intercambiar los botones
            if ([[self.buttonLeft titleForState:UIControlStateNormal] isEqualToString:NSLocalizedString(@"Galician", nil)])
            {
                [self switchLanguage:self];
                UIAlertView *info = [[UIAlertView alloc] 
                                     initWithTitle:nil message:NSLocalizedString(@"languageWillChangeOther", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"Ok", nil) otherButtonTitles: nil];
                [info show];
            }
        }
        else if (buttonIndex == 0)
        {
            // Establecer el perfil a 'galician'
            [defaults setObject:@"galician" forKey:@"tradutorGalegoProfile"];
            [defaults synchronize];
            // Poner el locale a gallego
            [[NSUserDefaults standardUserDefaults] setObject: [NSArray arrayWithObjects:@"gl", nil] forKey:@"AppleLanguages"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            // Mirar si hay que intercambiar los botones
            if ([[self.buttonRight titleForState:UIControlStateNormal] isEqualToString:NSLocalizedString(@"Galician", nil)])
            {
                [self switchLanguage:self];
                UIAlertView *info = [[UIAlertView alloc] 
                                     initWithTitle:nil message:NSLocalizedString(@"languageWillChangeGalician", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"Ok", nil) otherButtonTitles: nil];
                [info show];
            }
        }
    }
}

// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    CGFloat height;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        height = kbSize.width > kbSize.height ? kbSize.height : kbSize.width - 40;
    }
    else
    {
        height = kbSize.width > kbSize.height ? kbSize.height : kbSize.width + 170;
    }
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, height, 0.0);
    scrollView.contentInset = contentInsets;
    scrollView.scrollIndicatorInsets = contentInsets;
    
    // If active text field is hidden by keyboard, scroll it so it's visible
    // Your application might not need or want this behavior.
    CGRect aRect = self.view.frame;
    aRect.size.height -= height;
    if (!CGRectContainsPoint(aRect, self.textTextField.frame.origin) ) {
        CGPoint scrollPoint = CGPointMake(0.0, self.textTextField.frame.origin.y-height);
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

-(void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    if (fromInterfaceOrientation == UIInterfaceOrientationLandscapeLeft ||
        fromInterfaceOrientation == UIInterfaceOrientationLandscapeRight)
    {
        [self setPortrait];
    }
    else
    {
        [self setLandscape];
    }
}

#pragma mark - ParserDelegate

-(void) doOnSuccess:(NSString *)translationHtml translation:(NSString *)translation;
{
    self.translationHtml = translation;
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
    NSMutableString *message = [[NSMutableString alloc] initWithFormat:NSLocalizedString(@"Translation not found", nil), self.textTextField.text];
    UIAlertView *info = [[UIAlertView alloc] 
                         initWithTitle:nil message:message delegate:self cancelButtonTitle:NSLocalizedString(@"Ok", nil) otherButtonTitles: nil];
    [info show];
}

#pragma end

@end

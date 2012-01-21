//
//  TranlsationViewController.m
//  TradutorGalego
//
//  Created by Xurxo Méndez Pérez on 15/01/12.
//  Copyright (c) 2012 ninguna. All rights reserved.
//

#import "TranslationViewController.h"

@implementation TranslationViewController
@synthesize html;
@synthesize text;
@synthesize originalLanguage;
@synthesize destinationLanguage;
@synthesize webView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/

-(NSString *) getDrawableName:(NSString *) language
{
    if ([language isEqualToString:@"Galego"]) {
        return @"bandera_small_gl";
    }
    else if ([language isEqualToString:@"Español"]) {
        return @"bandera_small_es";
    }
    else if ([language isEqualToString:@"Catalán"]) {
        return @"bandera_small_cat";
    }
    else if ([language isEqualToString:@"Inglés"]) {
        return @"bandera_small_en";
    }
    else {
        return @"bandera_small_fr";
    }
}

-(NSString *) getPreTranslation:(NSString *) language
{
    NSString *result = [[NSString alloc] initWithFormat:@"<div class=\"translationHeader\"><div class=\"translationTitle\">%@</div><div class=\"translationImage\"><img src=\"%@.png\" ></div></div><div class=\"translation\">", @"Texto traducido", [self getDrawableName:language]];
    return result;
}

-(NSString *) getPostTranslation
{
    return @"</div>";
}

-(NSString *) getPreOriginal:(NSString *) language
{
    NSString *result = [[NSString alloc] initWithFormat:@"<div class=\"originalHeader\"><div class=\"originalTitle\">%@</div><div class=\"originalImage\"><img src=\"%@.png\" ></div></div><div class=\"original\">", @"Texto orixinal", [self getDrawableName:language]];
    return result;
}

-(NSString *) getPostOriginal
{
    return @"</div>";
}

-(void) wrapHtml
{
    self.html = [self.html stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"];
    self.html = [self.html stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"];
    self.html = [self.html stringByReplacingOccurrencesOfString:@"&iquest;" withString:@""];
    self.html = [self.html stringByReplacingOccurrencesOfString:@"&Acirc;&iexcl;" withString:@"¡"];
    self.html = [self.html stringByReplacingOccurrencesOfString:@"&Acirc;&iexcl;" withString:@"¡"];
    self.html = [[NSString alloc] initWithFormat:@"%@%@%@%@%@%@%@%@",@"<html><head><link rel=\"stylesheet\" type=\"text/css\" href=\"styles.css\" /></head><body>",[self getPreTranslation:self.destinationLanguage],self.html,[self getPostTranslation],
                 [self getPreOriginal:self.originalLanguage],self.text,[self getPostOriginal],@"</body></html>"];
    NSLog(@"%@", self.html);
}

- (IBAction)conjugate:(id)sender {
    
}

- (IBAction)define:(id)sender {
    NSString *urlString = [[NSString alloc] initWithFormat:@"dicio://%@", self.text];
    NSURL *myURL = [NSURL URLWithString:urlString];
    [[UIApplication sharedApplication] openURL:myURL];
}
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    NSString *path = [[NSBundle mainBundle] bundlePath];
    NSURL *baseURL = [NSURL fileURLWithPath:path];
    self.webView.opaque = NO;
    self.webView.backgroundColor = [UIColor clearColor];
    [self wrapHtml];
    [self.webView loadHTMLString:self.html baseURL:baseURL];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end

//
//  TranlsationViewController.m
//  TradutorGalego
//
//  Created by Xurxo Méndez Pérez on 15/01/12.
//  Copyright (c) 2012 ninguna. All rights reserved.
//

#import "TranslationViewController.h"
#import "Helper.h"

@implementation TranslationViewController
@synthesize translationHtml;
@synthesize originalText;
@synthesize translatedText;
@synthesize originalLanguage;
@synthesize destinationLanguage;
@synthesize webView;
@synthesize defineButton;
@synthesize conjugateButton;
@synthesize bottomToolbar;
@synthesize space1;
@synthesize space2;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

/*
 * Devuelve el nombre de la imagen de la bandera para el idioma pasado
 */
-(NSString *) getDrawableName:(NSString *) language
{
    if ([language isEqualToString:NSLocalizedString(@"Galician", nil)]) {
        return @"bandera_small_gl";
    }
    else if ([language isEqualToString:NSLocalizedString(@"Spanish", nil)]) {
        return @"bandera_small_es";
    }
    else if ([language isEqualToString:NSLocalizedString(@"Catalan", nil)]) {
        return @"bandera_small_cat";
    }
    else if ([language isEqualToString:NSLocalizedString(@"English", nil)]) {
        return @"bandera_small_en";
    }
    else {
        return @"bandera_small_fr";
    }
}

/*
 * Devuelve el html que va antes del texto traducido
 */
-(NSString *) getPreTranslation:(NSString *) language
{
    NSString *result = [[NSString alloc] initWithFormat:@"<div class=\"translationHeader\"><div class=\"translationTitle\">%@</div><div class=\"translationImage\"><img src=\"%@.png\" ></div></div><div class=\"translation\">", NSLocalizedString(@"Translated text", nil), [self getDrawableName:language]];
    return result;
}

/*
 * Devuelve el html que va después del texto traducido
 */
-(NSString *) getPostTranslation
{
    return @"</div>";
}

/*
 * Devuelve el html que va antes del texto original
 */
-(NSString *) getPreOriginal:(NSString *) language
{
    NSString *result = [[NSString alloc] initWithFormat:@"<div class=\"originalHeader\"><div class=\"originalTitle\">%@</div><div class=\"originalImage\"><img src=\"%@.png\" ></div></div><div class=\"original\">", NSLocalizedString(@"Original text", nil), [self getDrawableName:language]];
    return result;
}

/*
 * Devuelve el html que va después del texto original
 */
-(NSString *) getPostOriginal
{
    return @"</div>";
}

/*
 * Crea el HTML necesario alrededor de la traducción, del texto original, etc.
 */
-(void) wrapHtml
{
    self.translationHtml = [self.translationHtml stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"];
    self.translationHtml = [self.translationHtml stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"];
    self.translationHtml = [self.translationHtml stringByReplacingOccurrencesOfString:@"&iquest;" withString:@""];
    self.translationHtml = [self.translationHtml stringByReplacingOccurrencesOfString:@"&Acirc;&iexcl;" withString:@"¡"];
    self.translationHtml = [self.translationHtml stringByReplacingOccurrencesOfString:@"&Acirc;&iexcl;" withString:@"¡"];
    self.translationHtml = [[NSString alloc] initWithFormat:@"%@%@%@%@%@%@%@%@",@"<html><head><link rel=\"stylesheet\" type=\"text/css\" href=\"styles.css\" /></head><body>",[self getPreTranslation:self.destinationLanguage],self.translationHtml,[self getPostTranslation],
                 [self getPreOriginal:self.originalLanguage],self.originalText,[self getPostOriginal],@"</body></html>"];
}

/*
 * Botón para integración
 */
- (IBAction)conjugate:(id)sender {
    NSString* encodedText = [translatedText stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *urlString = [[NSString alloc] initWithFormat:@"conxuga://%@", encodedText];
    NSURL *myURL = [NSURL URLWithString:urlString];
    if ([[UIApplication sharedApplication] canOpenURL:myURL])
    {
        [[UIApplication sharedApplication] openURL:myURL];
    }
    else
    {
        NSString *appURLString = [[NSString alloc] initWithFormat:@"http://itunes.com/apps/conxugalego"];
        NSURL *appURL = [NSURL URLWithString:appURLString];
        [[UIApplication sharedApplication] openURL:appURL];
    }
}

/*
 * Botón para integración
 */
- (IBAction)define:(id)sender {
    NSString* encodedText = [translatedText stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *urlString = [[NSString alloc] initWithFormat:@"define://%@", encodedText];
    NSURL *myURL = [NSURL URLWithString:urlString];
    if ([[UIApplication sharedApplication] canOpenURL:myURL])
    {
        [[UIApplication sharedApplication] openURL:myURL];
    }
    else
    {
        NSString *appURLString = [[NSString alloc] initWithFormat:@"http://itunes.com/apps/dicionariogalego"];
        NSURL *appURL = [NSURL URLWithString:appURLString];
        [[UIApplication sharedApplication] openURL:appURL];
    }
}

/*
 * Decide si mostrar el botón de definir
 */
-(BOOL)showDefine
{
    return ([self.destinationLanguage isEqualToString:NSLocalizedString(@"Galician", nil)] &&
            [[[self translatedText] componentsSeparatedByString:@" "] count] == 1);
}

/*
 * Decide si mostrar el botón de conjugar
 */
-(BOOL)showConjugate
{
    return ([self.destinationLanguage isEqualToString:NSLocalizedString(@"Galician", nil)] &&
            [[[self translatedText] componentsSeparatedByString:@" "] count] == 1 &&
            [Helper existsVerb:self.translatedText]);
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSString *path = [[NSBundle mainBundle] bundlePath];
    NSURL *baseURL = [NSURL fileURLWithPath:path];
    self.webView.opaque = NO;
    self.webView.backgroundColor = [UIColor clearColor];
    if ([self showDefine] && [self showConjugate]) {
        [self.bottomToolbar setHidden:FALSE];
        [self.bottomToolbar setItems:[[NSArray alloc] initWithObjects:self.space1, self.defineButton,self.conjugateButton,self.space1, nil] animated:TRUE];
    }
    else if ([self showDefine]) {
        [self.bottomToolbar setHidden:FALSE];
        [self.bottomToolbar setItems:[[NSArray alloc] initWithObjects:self.space1, self.defineButton,self.space1, nil] animated:TRUE];
    }
    else if ([self showConjugate]) {
        [self.bottomToolbar setHidden:FALSE];
        [self.bottomToolbar setItems:[[NSArray alloc] initWithObjects:self.space1, self.conjugateButton,self.space1, nil] animated:TRUE];
    }
    else {
        [self.bottomToolbar setHidden:TRUE];
        [self.bottomToolbar setItems:[[NSArray alloc] initWithObjects:nil] animated:TRUE];
    }
    [self wrapHtml];
    [self.webView loadHTMLString:self.translationHtml baseURL:baseURL];
}

- (void)viewDidUnload
{
    [self setTranslationHtml:nil];
    [self setOriginalText:nil];
    [self setTranslatedText:nil];
    [self setOriginalLanguage:nil];
    [self setDestinationLanguage:nil];
    [self setWebView:nil];
    [self setDefineButton:nil];
    [self setConjugateButton:nil];
    [self setBottomToolbar:nil];
    [self setSpace1:nil];
    [self setSpace2:nil];
    [super viewDidUnload];
}

#pragma end


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

@end

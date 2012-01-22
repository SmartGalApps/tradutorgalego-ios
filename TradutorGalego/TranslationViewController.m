//
//  TranlsationViewController.m
//  TradutorGalego
//
//  Created by Xurxo Méndez Pérez on 15/01/12.
//  Copyright (c) 2012 ninguna. All rights reserved.
//

#import "TranslationViewController.h"

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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

/*
 * Devuelve el nombre de la imagen de la bandera para el idioma pasado
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

/*
 * Devuelve el html que va antes del texto traducido
 */
-(NSString *) getPreTranslation:(NSString *) language
{
    NSString *result = [[NSString alloc] initWithFormat:@"<div class=\"translationHeader\"><div class=\"translationTitle\">%@</div><div class=\"translationImage\"><img src=\"%@.png\" ></div></div><div class=\"translation\">", @"Texto traducido", [self getDrawableName:language]];
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
    NSString *result = [[NSString alloc] initWithFormat:@"<div class=\"originalHeader\"><div class=\"originalTitle\">%@</div><div class=\"originalImage\"><img src=\"%@.png\" ></div></div><div class=\"original\">", @"Texto orixinal", [self getDrawableName:language]];
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
    NSLog(@"%@", self.translationHtml);
}

/*
 * Botón para integración
 */
- (IBAction)conjugate:(id)sender {
    NSString *urlString = [[NSString alloc] initWithFormat:@"conxuga://%@", self.translatedText];
    NSURL *myURL = [NSURL URLWithString:urlString];
    [[UIApplication sharedApplication] openURL:myURL];
}

/*
 * Botón para integración
 */
- (IBAction)define:(id)sender {
    NSString *urlString = [[NSString alloc] initWithFormat:@"define://%@", self.translatedText];
    NSURL *myURL = [NSURL URLWithString:urlString];
    [[UIApplication sharedApplication] openURL:myURL];
}

/*
 * Decide si mostrar el botón de definir
 */
-(BOOL)showDefine
{
    return ([self.destinationLanguage isEqualToString:@"Galego"] &&
            [[[self translatedText] componentsSeparatedByString:@" "] count] == 1);
}

/*
 * Decide si mostrar el botón de conjugar
 */
-(BOOL)showConjugate
{
    return ([self.destinationLanguage isEqualToString:@"Galego"] &&
            [[[self translatedText] componentsSeparatedByString:@" "] count] == 1);
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSString *path = [[NSBundle mainBundle] bundlePath];
    NSURL *baseURL = [NSURL fileURLWithPath:path];
    self.webView.opaque = NO;
    self.webView.backgroundColor = [UIColor clearColor];
    NSLog(@"%@", self.translatedText);
    if ([self showDefine] && [self showConjugate]) {
        [self.bottomToolbar setHidden:FALSE];
        [self.bottomToolbar setItems:[[NSArray alloc] initWithObjects:self.defineButton,self.conjugateButton,nil] animated:TRUE];
    }
    else if ([self showDefine]) {
        [self.bottomToolbar setHidden:FALSE];
        [self.bottomToolbar setItems:[[NSArray alloc] initWithObjects:self.defineButton,nil] animated:TRUE];
    }
    else if ([self showConjugate]) {
        [self.bottomToolbar setHidden:FALSE];
        [self.bottomToolbar setItems:[[NSArray alloc] initWithObjects:self.conjugateButton,nil] animated:TRUE];
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
    [super viewDidUnload];
}

#pragma end

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end

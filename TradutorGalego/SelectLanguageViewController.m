//
//  SelectLanguageViewController.m
//  TradutorGalego
//
//  Created by Xurxo Méndez Pérez on 15/01/12.
//  Copyright (c) 2012 ninguna. All rights reserved.
//

#import "SelectLanguageViewController.h"
#import "CustomView.h"

@implementation SelectLanguageViewController
@synthesize languagesPicker;
@synthesize selected;
@synthesize options;
@synthesize delegate;

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


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    int i = 0;
    if ([self.selected isEqualToString:@"Catalán"]) {
        i = 1;
    }
    else if ([self.selected isEqualToString:@"Inglés"]) {
        i = 2;
    }
    else if ([self.selected isEqualToString:@"Francés"]) {
        i = 3;
    }
    [self.languagesPicker selectRow:i inComponent:0 animated:FALSE];
}

- (void)viewDidUnload
{
    [self setLanguagesPicker:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)languageSelected:(id)sender {
    [self.delegate selectLanguageViewController:self didSelectLanguage:self.selected];
}



- (NSInteger)numberOfComponentsInPickerView:
(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component
{
    return [self.options count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row
            forComponent:(NSInteger)component
{
    return [self.options objectAtIndex:row];
} 

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row
          forComponent:(NSInteger)component reusingView:(UIView *)view
{
    CustomView *customView = [[CustomView alloc] init];
    customView.title = [self.options objectAtIndex:row];
    NSString * path;
    if ([customView.title isEqualToString:@"Español"]) {
        path = [[NSString alloc] initWithString:@"bandera_small_es"];
    }
    else if ([customView.title isEqualToString:@"Catalán"]) {
        path = [[NSString alloc] initWithString:@"bandera_small_cat"];
    }
    else if ([customView.title isEqualToString:@"Inglés"]) {
        path = [[NSString alloc] initWithString:@"bandera_small_en"];
    }
    else if ([customView.title isEqualToString:@"Francés"]) {
        path = [[NSString alloc] initWithString:@"bandera_small_fr"];
    }
    NSString* pathToImageFile = [[NSBundle mainBundle] pathForResource:path ofType:@"png"];
    UIImage *flag = [[UIImage alloc] initWithContentsOfFile:pathToImageFile];

    customView.image = flag;
    return customView;
    
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row
      inComponent:(NSInteger)component
{
    self.selected = [self.options objectAtIndex:row];
}


@end

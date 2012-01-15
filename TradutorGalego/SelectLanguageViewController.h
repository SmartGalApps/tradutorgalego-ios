//
//  SelectLanguageViewController.h
//  TradutorGalego
//
//  Created by Xurxo Méndez Pérez on 15/01/12.
//  Copyright (c) 2012 ninguna. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SelectLanguageViewController;

@protocol SelectLanguageViewControllerDelegate <NSObject>
- (void)selectLanguageViewController:
(SelectLanguageViewController *)controller 
                   didSelectLanguage:(NSString *)language;
@end

@interface SelectLanguageViewController : UIViewController {
    NSArray *options;
    NSString *selected;
}

@property (nonatomic, weak) id <SelectLanguageViewControllerDelegate> delegate;

@property (nonatomic, retain) NSString *selected;
@property (nonatomic, retain) NSArray *options;

@property (weak, nonatomic) IBOutlet UIPickerView *languagesPicker;

- (IBAction)languageSelected:(id)sender;
@end

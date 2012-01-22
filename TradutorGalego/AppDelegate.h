//
//  AppDelegate.h
//  TradutorGalego
//
//  Created by Xurxo Méndez Pérez on 15/01/12.
//  Copyright (c) 2012 ninguna. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate> {
    ViewController *viewController;
}

@property (strong, nonatomic) ViewController *viewController;
@property (strong, nonatomic) UIWindow *window;

@end

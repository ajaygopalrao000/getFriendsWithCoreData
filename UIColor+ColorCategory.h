//
//  UIColor+ColorCategory.h
//  getFriendsWithCoreData
//
//  Created by Gopal Rao on 7/17/15.
//  Copyright (c) 2015 Gopal Rao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (ColorCategory)

//method for uicolor with hex and alpha

// method to return myAppPurple "#ec008c"
//for example [UIColor myAppPurple] should return a color with that speciic hexcolor and alpha 1.0

// myAppDarkPurple "#060001b"
// myAppPrimaryTextColor "#ffffff"
// myAppSecondaryTextColorDarkBackground "#9a9fac3"
// myAppSecondaryTextColorWhiteBackground "#707070"
// myAppDefaultTextColor "#231f20"
// myAppSelectedStateColor "#37214c"
// myAppNavigationBarBackgroundColor "#0f031b"

+ (UIColor *) myAppPurple;
+ (UIColor *) myAppDarkPurple;
+ (UIColor *) myAppPrimaryTextColor;
+ (UIColor *) myAppSecondaryTextColorDarkBackground;
+ (UIColor *) myAppSecondaryTextColorWhiteBackground;
+ (UIColor *) myAppDefaultTextColor;
+ (UIColor *) myAppSelectedStateColor;
+ (UIColor *) myAppNavigationBarBackgroundColor;

+(UIColor*)colorWithHexString:(NSString*)hex;


@end

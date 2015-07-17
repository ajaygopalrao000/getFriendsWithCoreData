//
//  UIColor+ColorCategory.m
//  getFriendsWithCoreData
//
//  Created by Gopal Rao on 7/17/15.
//  Copyright (c) 2015 Gopal Rao. All rights reserved.
//

#import "UIColor+ColorCategory.h"

@implementation UIColor (ColorCategory)


+ (UIColor *) myAppPurple;
{
    static UIColor *myAppPurple = nil;
    // If we haven't already initialised the colour, then do it now
    if (!myAppPurple) {
        myAppPurple = [self colorWithHexString :@"#ec008c"];
    }
    return myAppPurple;
    
}
+ (UIColor *) myAppDarkPurple;
{
    static UIColor *myAppPurple = nil;
    // If we haven't already initialised the colour, then do it now
    if (!myAppPurple) {
        myAppPurple = [self colorWithHexString :@"#060001b"];
    }
    return myAppPurple;
}
+ (UIColor *) myAppPrimaryTextColor;
{
    static UIColor *myAppPurple = nil;
    // If we haven't already initialised the colour, then do it now
    if (!myAppPurple) {
        myAppPurple = [self colorWithHexString :@"#ffffff"];
    }
    return myAppPurple;
    
}
+ (UIColor *) myAppSecondaryTextColorDarkBackground;
{
    static UIColor *myAppPurple = nil;
    // If we haven't already initialised the colour, then do it now
    if (!myAppPurple) {
        myAppPurple = [self colorWithHexString :@"#9a9fac3"];
    }
    return myAppPurple;
}
+ (UIColor *) myAppSecondaryTextColorWhiteBackground;
{
    static UIColor *myAppPurple = nil;
    // If we haven't already initialised the colour, then do it now
    if (!myAppPurple) {
        myAppPurple = [self colorWithHexString :@"#707070"];
    }
    return myAppPurple;
}
+ (UIColor *) myAppDefaultTextColor;
{
    static UIColor *myAppPurple = nil;
    // If we haven't already initialised the colour, then do it now
    if (!myAppPurple) {
        myAppPurple = [self colorWithHexString :@"#231f20"];
    }
    return myAppPurple;
}
+ (UIColor *) myAppSelectedStateColor;
{
    static UIColor *myAppPurple = nil;
    // If we haven't already initialised the colour, then do it now
    if (!myAppPurple) {
        myAppPurple = [self colorWithHexString :@"#37214c"];
    }
    return myAppPurple;
}
+ (UIColor *) myAppNavigationBarBackgroundColor;
{
    static UIColor *myAppPurple = nil;
    // If we haven't already initialised the colour, then do it now
    if (!myAppPurple) {
        myAppPurple = [self colorWithHexString :@"#0f031b"];
    }
    return myAppPurple;
}


+(UIColor*)colorWithHexString:(NSString*)hex
{
    NSString *cString = [[hex stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) return [UIColor grayColor];
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    
    if ([cString length] != 6) return  [UIColor grayColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                            alpha:1.0f];
}

@end

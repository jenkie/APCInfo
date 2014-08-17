//
//  CustomHud.m
//  BaraMobil
//
//  Created by Ben on 20.05.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CustomHud.h"
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

@implementation CustomHud


-(id) init {
    if (self = [super init]) {
        //hud = [[MBProgressHUD alloc] init];
    }
    return self;
}

-(void) showSuccessHudInView:(id)view {
    [CustomHud hideAllHUDsForView:view animated:YES];
    hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.minShowTime = 1.0;
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"checkmark.png"]];
    hud.mode = MBProgressHUDModeCustomView;
    hud.labelText = @"Erfolgreich.";
    hud.removeFromSuperViewOnHide = YES;
    [hud show:true];
    [hud hide:true];
}

-(void) showSuccessHudInView:(id)view  withDetailText:(NSString*)detail {
    [CustomHud hideAllHUDsForView:view animated:YES];
    hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.minShowTime = 1.0;
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"checkmark.png"]];
    hud.mode = MBProgressHUDModeCustomView;
    hud.labelText = detail;
    hud.removeFromSuperViewOnHide = YES;
    [hud show:true];
    [hud hide:true];
}

-(void) showFailureHudInView:(id)view withDetailText:(NSString*)detail {
    [CustomHud hideAllHUDsForView:view animated:YES];
    hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.minShowTime = 2.0;
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"error.png"]];
    hud.mode = MBProgressHUDModeCustomView;
    hud.labelText = @"Fehler";
    hud.detailsLabelText = detail;
    hud.removeFromSuperViewOnHide = YES;
    [hud show:true];
    [hud hide:true];
}

-(void) showLoadingHudInView:(id)view  withText:(NSString*)text andDetailText:(NSString*)detail {
    [CustomHud hideAllHUDsForView:view animated:YES];
    hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.labelText = text;
    hud.detailsLabelText = detail;
    hud.removeFromSuperViewOnHide= YES;
    [hud show:true];
}

-(void) showMessageHudInView:(id)view withText:(NSString*)text andDetailText:(NSString*)detail {
    [CustomHud hideAllHUDsForView:view animated:YES];
    hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
	hud.mode = MBProgressHUDModeText;
    hud.labelText = text;
    hud.detailsLabelText = detail;
	hud.removeFromSuperViewOnHide = YES;
    [hud show:YES];
	[hud hide:YES afterDelay:2];
    
}

-(void) showOffsetHudInView:(id)view withText:(NSString *)text {
    [CustomHud hideAllHUDsForView:view animated:YES];
    hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.multipleTouchEnabled = NO;
    hud.userInteractionEnabled = NO;
	hud.mode = MBProgressHUDModeText;
	hud.labelText = text;
	hud.margin = 5.f;
    CGRect screen = [[UIScreen mainScreen] bounds];
    CGFloat height = CGRectGetHeight(screen);
    CGFloat width = CGRectGetWidth(screen);
    CGFloat ref = 0;
    
    // [UIDevice currentDevice].orientation) returns always  null, so we're using this workaround:
    if (([[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationLandscapeLeft) || ([[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationLandscapeRight)) {
        ref = width;
    } else {
        ref = height;
    }
    if ([[UIDevice currentDevice].model isEqualToString:@"iPhone"]) {
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
            hud.yOffset = -(ref / 2 - 44);
        }
        else {
            hud.yOffset = -(ref / 2 - 80);
        }
    }
    else {
        hud.yOffset = -(ref / 2 - 84);
    }
	hud.removeFromSuperViewOnHide = YES;
	[hud show:YES];
}

-(void) showOffsetMessageHudInView:(id)view withText:(NSString *)text {
    [CustomHud hideAllHUDsForView:view animated:YES];
    hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.multipleTouchEnabled = NO;
    hud.userInteractionEnabled = NO;
	hud.mode = MBProgressHUDModeText;
	hud.labelText = text;
	hud.margin = 5.f;
    CGRect screen = [[UIScreen mainScreen] bounds];
    CGFloat height = CGRectGetHeight(screen);
    CGFloat width = CGRectGetWidth(screen);
    CGFloat ref = 0;
    
    // [UIDevice currentDevice].orientation) returns always  null, so we're using this workaround:
    if (([[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationLandscapeLeft) || ([[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationLandscapeRight)) {
        ref = width;
    } else {
        ref = height;
    }
    if ([[UIDevice currentDevice].model isEqualToString:@"iPhone"]) {
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
            hud.yOffset = -(ref / 2 - 64);
        }
        else {
            hud.yOffset = -(ref / 2 - 84);
        }
    }
    else {
        hud.yOffset = -(ref / 2 - 84);
    }
	hud.removeFromSuperViewOnHide = YES;
	[hud show:YES];
    [hud hide:YES afterDelay:2];
}

-(void) replaceText:(NSString*)text {
    if (hud != nil) 
        hud.labelText = text;
}

-(void) replaceDetailText:(NSString*)detail {
    if (hud != nil)
        hud.detailsLabelText = detail;
}
-(void) hideHud {
    [hud hide:true];
}
/*
-(void) hideAllHudsInView:(UIView*)view {
    for (MBProgressHUD *h in [CustomHud allHUDsForView:view]) {
        [h hide:true];
    }
}
 */
@end

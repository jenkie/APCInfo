//
//  CustomHud.h
//  BaraMobil
//
//  Created by Ben on 20.05.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"
@interface CustomHud : MBProgressHUD {
    MBProgressHUD *hud;
}
-(id) init;
-(void) showLoadingHudInView:(id)view  withText:(NSString*)text andDetailText:(NSString*)detail;
-(void) showSuccessHudInView:(id)view;
-(void) showSuccessHudInView:(id)view withDetailText:(NSString*)detail;
-(void) showFailureHudInView:(id)view withDetailText:(NSString*)detail;
-(void) hideHud;
-(void) replaceText:(NSString*)text;
-(void) showMessageHudInView:(id)view withText:(NSString*)text andDetailText:(NSString*)detail;
-(void) showOffsetHudInView:(id)view withText:(NSString *)text;
-(void) showOffsetMessageHudInView:(id)view withText:(NSString *)text;
@end

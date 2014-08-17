//
//  ApcBtCom.h
//  APCInfo
//
//  Created by Ben on 15.04.14.
//  Copyright (c) 2014 Marco Bendowski. All rights reserved.
//

#import "BLE.h"
@interface ApcBtCom : BLE <BLEDelegate> {
    BLE *ble;
    Boolean connected;
    Boolean isReconnect;
    int waitForBluetoothRetryCount;
}
+ (id)sharedApcBtCom;
- (void)connect;
- (void)reconnect;
- (void)disconnect;
- (void) sendString:(NSString *) strData;
- (void) sendInitString:(NSString*) initCmd;
@end


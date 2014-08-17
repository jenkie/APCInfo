//
//  ApcBtCom.m
//  APCInfo
//
//  Created by Ben on 15.04.14.
//  Copyright (c) 2014 Marco Bendowski. All rights reserved.
//

#import "ApcBtCom.h"
#import "CustomHelper.h"

@implementation ApcBtCom

+ (id)sharedApcBtCom {
    static ApcBtCom *sharedApcBtComObj = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedApcBtComObj = [[self alloc] init];
    });
    return sharedApcBtComObj;
}

- (id)init {
    if (self = [super init]) {
        ble = [[BLE alloc] init];
        [ble controlSetup];
        ble.delegate = self;
        waitForBluetoothRetryCount = 0;
        isReconnect = false;
        //NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    }
    return self;
}

-(void)reconnect {
    isReconnect = true;
    [self _connect];
};
-(void)connect{
    isReconnect = false;
    [self _connect];
};

-(void)_connect {
    if (ble.activePeripheral.state != CBPeripheralStateConnected) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"connectingDevice" object:self userInfo:nil];
    }
    if (ble.CM.state != CBCentralManagerStatePoweredOn && waitForBluetoothRetryCount < 10) { //Ready?
        waitForBluetoothRetryCount++;
        [self performSelector: @selector(connect) withObject:nil afterDelay:0.5];
        return;
    }
    
    if (ble.activePeripheral) {
      if(ble.activePeripheral.state == CBPeripheralStateConnected) {
            //[[ble CM] cancelPeripheralConnection:[ble activePeripheral]];
            return;
      }
    }
    if (ble.peripherals)
        ble.peripherals = nil;
    
    [ble findBLEPeripherals:3];
    [NSTimer scheduledTimerWithTimeInterval:(float)3.0 target:self selector:@selector(connectionTimer:) userInfo:nil repeats:NO];

}

-(void)disconnect {
    [[ble CM] cancelPeripheralConnection:[ble activePeripheral]];
}

//called from Timer
-(void) connectionTimer:(NSTimer *)timer
{
    if(ble.peripherals.count > 0)
    {
        [ble connectPeripheral:[ble.peripherals objectAtIndex:0]];
    }
}

//called after connect, if there are init-cmds
-(void) delayedSend:(NSTimer *)timer {
    NSString *cmd =[timer userInfo];
    [self sendString:[NSString stringWithFormat:@"%@\n", cmd]];
}

-(void) bleDidConnect
{
    waitForBluetoothRetryCount = 0;
    if (!isReconnect) {
        NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
        //NSString *initCmd = [defaults stringForKey:@"initCmd"];
        
        [self sendInitString:[defaults stringForKey:@"initCmd"]];
        /*
        NSArray *cmds = [initCmd componentsSeparatedByString:@";"];
        if (cmds.count == 0 && initCmd.length > 0) {  //only one cmd
            [NSTimer scheduledTimerWithTimeInterval:(float)1.0 target:self selector:@selector(delayedSend:) userInfo:initCmd repeats:NO];
        }
        else {
            for (int i = 0; i < cmds.count; i++) {
                [NSTimer scheduledTimerWithTimeInterval:(float)(i+1)*0.5 target:self selector:@selector(delayedSend:) userInfo:cmds[i] repeats:NO];
            }
        }
        */
    }
    isReconnect = false;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"connectedDevice" object:self userInfo:nil];
}



- (void) bleDidDisconnect
{
  waitForBluetoothRetryCount = 0;
  [[NSNotificationCenter defaultCenter] postNotificationName:@"disconnectedDevice" object:self userInfo:nil];
}

-(void) sendInitString:(NSString*) initCmd {
    NSArray *cmds = [initCmd componentsSeparatedByString:@";"];
    if (cmds.count == 0 && initCmd.length > 0) {  //only one cmd
        [self sendString:[NSString stringWithFormat:@"%@\n", initCmd]];
    }
    else {
        for (int i = 0; i < cmds.count; i++) {
            [NSTimer scheduledTimerWithTimeInterval:(float)(i+1)*0.5 target:self selector:@selector(delayedSend:) userInfo:cmds[i] repeats:NO];
        }
    }
}

-(void) sendString:(NSString *) strData {
    NSData *data = [strData dataUsingEncoding:NSASCIIStringEncoding];
    [ble write:data];
}

//ble delegate
-(void) bleDidReceiveData:(unsigned char *)data length:(int)length
{
    NSData *d = [NSData dataWithBytes:data length:length];
    //NSLog(@"%@", [[NSString alloc] initWithData:d encoding:NSASCIIStringEncoding]);
    NSMutableDictionary *e = [self parseData:[[NSString alloc] initWithData:d encoding:NSASCIIStringEncoding]];
    NSDictionary *payload = [NSDictionary dictionaryWithObject:e forKey:@"logEntry"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"receivedData" object:self userInfo:payload];
}

-(NSMutableDictionary*)parseData:(NSString*) str {
    str = [str stringByReplacingOccurrencesOfString:@"\r\n" withString:@""];
    NSMutableDictionary *e = [[NSMutableDictionary alloc] init];
    if ([str hasPrefix:@"ps"]) {
      // psOK oder ps1023
    }
    else if ([str hasPrefix:@"sp"]) {
      //spOK
    }
    else if ([str hasPrefix:@"lp"]) {
      //lpOK
    }
    else if ([str hasPrefix:@"pr"]) {
      //prOK
    }
    else if ([str rangeOfString:@";"].length > 0) {
        NSArray *arr = [str componentsSeparatedByString:@";"];
        if (arr.count == 14) {  //Android + custom format
            [e setValue:[NSNumber numberWithFloat:[[arr objectAtIndex:0] floatValue]] forKeyPath:@"voltage"];
            [e setValue:[NSNumber numberWithFloat:[[arr objectAtIndex:1] floatValue]] forKeyPath:@"current"];
            [e setValue:[NSNumber numberWithFloat:[[arr objectAtIndex:2] floatValue]] forKeyPath:@"power"];
            [e setValue:[NSNumber numberWithFloat:[[arr objectAtIndex:3] floatValue]] forKeyPath:@"speed"];
            [e setValue:[NSNumber numberWithFloat:[[arr objectAtIndex:4] floatValue]] forKeyPath:@"km"];
            [e setValue:[NSNumber numberWithFloat:[[arr objectAtIndex:5] floatValue]] forKeyPath:@"cadence"];
            [e setValue:[NSNumber numberWithFloat:[[arr objectAtIndex:6] floatValue]] forKeyPath:@"wh"];
            [e setValue:[NSNumber numberWithFloat:[[arr objectAtIndex:7] floatValue]] forKeyPath:@"humanPower"];
            [e setValue:[NSNumber numberWithFloat:[[arr objectAtIndex:8] floatValue]] forKeyPath:@"humanWh"];
            [e setValue:[NSNumber numberWithFloat:[[arr objectAtIndex:9] floatValue]] forKeyPath:@"poti"];
            [e setValue:[arr objectAtIndex:10] forKeyPath:@"controlMode"];
            [e setValue:[NSNumber numberWithFloat:[[arr objectAtIndex:11] floatValue]] forKeyPath:@"mah"];
            [e setValue:[NSNumber numberWithFloat:[[arr objectAtIndex:12] floatValue]] forKeyPath:@"currentProfile"];
            [e setValue:[NSNumber numberWithFloat:[[arr objectAtIndex:13] floatValue]] forKeyPath:@"potiMax"];
        }
    }
    return e;
}



@end

//
//  AppDelegate.m
//  AudioOutputSwitcher
//
//  Created by Guo Xu (Jason)-JGUO on 2/23/14.
//  Copyright (c) 2014 Guo Xu (Jason)-JGUO. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate
@synthesize statusItem;
@synthesize audioPortList;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
}

- (void)awakeFromNib{
    
    // this should be called from awakeFromNib method
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"LaunchAsAgentApp"])
    {
        ProcessSerialNumber psn = { 0, kCurrentProcess };
        
        // display dock icon
        TransformProcessType(&psn, kProcessTransformToBackgroundApplication);
        
        // switch to Dock.app
        [[NSWorkspace sharedWorkspace] launchAppWithBundleIdentifier:@"com.apple.dock"    options:NSWorkspaceLaunchDefault additionalEventParamDescriptor:nil launchIdentifier:nil];
        
        // switch back
        [[NSApplication sharedApplication] activateIgnoringOtherApps:TRUE];
        
    }
    
    [self.statusMenu removeAllItems];
    audioPortList = [self outputDeviceNames];
    for (int i = 0; i < audioPortList.count; i++)
    {
        NSMenuItem *item = [[NSMenuItem alloc] initWithTitle:[audioPortList objectAtIndex:i] action:@selector(buttonSelected:) keyEquivalent:[NSString stringWithFormat:@"%d", i+1]];
        [self.statusMenu addItem:item];
        NSLog(@"%@", [audioPortList objectAtIndex:i]);
    }
    NSMenuItem *item = [[NSMenuItem alloc] initWithTitle:@"Quit" action:@selector(quit) keyEquivalent:@"Q"];
    [self.statusMenu addItem:item];
    self.statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    [statusItem setMenu:self.statusMenu];
    [statusItem setTitle:@"Audio Output"];
    [statusItem setHighlightMode:YES];
}

- (void)buttonSelected:(id)sender
{
    NSMenuItem *curItem = (NSMenuItem*) sender;
    [self setDeviceByID:[self deviceIDForName:[curItem title]]];
    NSLog(@"set audio output to: %@", [curItem title]);
}

- (void) quit
{
    [NSApp terminate: nil];
}

- (NSArray *)outputDeviceNames {
    NSArray *availableOutputDeviceIDs = [self availableOutputDeviceIDs];
    
    UInt32 deviceCount = (UInt32)[availableOutputDeviceIDs count];
    NSMutableArray *deviceNamesForType = [[NSMutableArray alloc] initWithCapacity:deviceCount];
    
    for(NSNumber *deviceIDNumber in availableOutputDeviceIDs) {
        UInt32 deviceID = [deviceIDNumber unsignedIntValue];
        NSString *deviceName = [self deviceNameForID:deviceID];
        
        [deviceNamesForType addObject:deviceName];
    }
    
    return [NSArray arrayWithArray:deviceNamesForType];
}


- (NSArray *)availableOutputDeviceIDs {
    UInt32 propertySize;
    AudioDeviceID devices[64];
    int devicesCount = 0;
    
    AudioHardwareGetPropertyInfo(kAudioHardwarePropertyDevices, &propertySize, NULL);
    AudioHardwareGetProperty(kAudioHardwarePropertyDevices, &propertySize, devices);
    devicesCount = (propertySize / sizeof(AudioDeviceID));
    
    NSMutableArray *availableOutputDeviceIDs = [[NSMutableArray alloc] initWithCapacity:devicesCount];
    
    for(int i = 0; i < devicesCount; ++i) {
        if ([self isOutputDevice:devices[i]]) {
            NSNumber *outputDeviceID = [NSNumber numberWithUnsignedInt:devices[i]];
            [availableOutputDeviceIDs addObject:outputDeviceID];
        }
    }
    
    return [NSArray arrayWithArray:availableOutputDeviceIDs];
}

- (BOOL)isOutputDevice:(AudioDeviceID)deviceID {
    UInt32 propertySize = 256;
    
    AudioDeviceGetPropertyInfo(deviceID, 0, false, kAudioDevicePropertyStreams, &propertySize, NULL);
    BOOL isOutputDevice = (propertySize > 0);
    
    return isOutputDevice;
}

- (AudioDeviceID)currentOutputDeviceID {
    UInt32 propertySize;
    AudioDeviceID deviceID = kAudioDeviceUnknown;
    
    propertySize = sizeof(deviceID);
    AudioHardwareGetProperty(kAudioHardwarePropertyDefaultOutputDevice, &propertySize, &deviceID);
    
    return deviceID;
}

- (NSString *)deviceNameForID:(AudioDeviceID)deviceID {
    UInt32 propertySize = 256;
    char deviceName[256];
    
    AudioDeviceGetProperty(deviceID, 0, false, kAudioDevicePropertyDeviceName, &propertySize, deviceName);
    NSString *deviceNameForID = [NSString stringWithCString:deviceName encoding:NSUTF8StringEncoding];
    
    return deviceNameForID;
}

- (AudioDeviceID)deviceIDForName:(NSString *)requestedDeviceName {
    AudioDeviceID deviceIDForName = kAudioDeviceUnknown;
    NSArray *availableOutputDeviceIDs = [self availableOutputDeviceIDs];
    
    for(NSNumber *deviceIDNumber in availableOutputDeviceIDs) {
        UInt32 deviceID = [deviceIDNumber unsignedIntValue];
        NSString *deviceName = [self deviceNameForID:deviceID];
        
        if ([requestedDeviceName isEqualToString:deviceName]) {
            deviceIDForName = deviceID;
            break;
        }
    }
    return deviceIDForName;
}

- (void)setDeviceByID:(AudioDeviceID)newDeviceID {
    UInt32 propertySize = sizeof(UInt32);
    AudioHardwareSetProperty(kAudioHardwarePropertyDefaultOutputDevice, propertySize, &newDeviceID);
}

@end

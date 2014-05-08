//
//  AppDelegate.h
//  AudioOutputSwitcher
//
//  Created by Guo Xu (Jason)-JGUO on 2/23/14.
//  Copyright (c) 2014 Guo Xu (Jason)-JGUO. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <CoreServices/CoreServices.h>
#import <CoreAudio/CoreAudio.h>

@interface AppDelegate : NSObject <NSApplicationDelegate>
{
    NSStatusItem * statusItem;
    NSArray *audioPortList;
}

@property (nonatomic, strong) NSStatusItem * statusItem;
@property (nonatomic, strong) NSArray *audioPortList;
@property (assign) IBOutlet NSMenu *statusMenu;
@property (assign) IBOutlet NSWindow *window;

@end

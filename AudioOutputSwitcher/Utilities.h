//
//  Utilities.h
//  AudioOutputSwitcher
//
//  Created by Jason Guo on 5/22/14.
//  Copyright (c) 2014 Guo Xu (Jason)-JGUO. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Utilities:NSObject

+(BOOL) copyFileFromBundleTo:(NSString *)sourceName :(NSString*)sourceType :(NSString *)destinationPath;

+(BOOL) loadDaemonFromPath:(NSString *)userPath;

@end

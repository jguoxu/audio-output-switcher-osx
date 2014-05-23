//
//  Utilities.m
//  AudioOutputSwitcher
//
//  Created by Jason Guo on 5/22/14.
//  Copyright (c) 2014 Guo Xu (Jason)-JGUO. All rights reserved.
//

#import "Utilities.h"

@implementation Utilities

+(BOOL) copyFileFromBundleTo:(NSString *)sourceName :(NSString*)sourceType :(NSString *)destinationPath
{
    NSBundle *thisBundle = [NSBundle mainBundle];
    
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    NSString *src = [thisBundle pathForResource:sourceName ofType:sourceType];
    NSString *dest = [NSString stringWithFormat:@"/Users/%@%@/%@.%@", NSUserName(), destinationPath, sourceName, sourceType];
    NSError *error = [[NSError alloc]init];
    if(![fileManager copyItemAtPath:src toPath:dest error:&error])
    {
        NSLog(@"%@", [error localizedDescription]);
        return false;
    }
    return true;
}

+(BOOL) loadDaemonFromPath:(NSString *)userPath
{
    NSTask *task;
    task = [[NSTask alloc] init];
    [task setLaunchPath: @"/bin/launchctl"];
    
    NSArray *arguments;
    NSString *path = [NSString stringWithFormat:@"/Users/%@%@", NSUserName(), userPath];
    arguments = [NSArray arrayWithObjects: @"load", path, nil];
    [task setArguments: arguments];
    [task launch];
    return true;
}

@end

//
//  main.m
//  file-sort
//
//  Created by HanShaokun on 21/8/15.
//  Copyright (c) 2015 by. All rights reserved.
//

#import <Foundation/Foundation.h>

BOOL isDirectoryExist(NSString* path)
{
    BOOL isDirectory = NO;
    BOOL exist = [[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDirectory];
    
    return !!(exist && isDirectory);
}

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        
        NSMutableArray *keys = [NSMutableArray array];
        NSMutableArray *values = [NSMutableArray array];
        bool start = false;
        
        for (int i = 0; i < argc; i++) {
            NSString* tmp = [NSString stringWithFormat:@"%s", argv[i]];
            
            if ([tmp hasPrefix:@"-"]) {
                [keys addObject:[tmp substringFromIndex:1]];
                start = true;
            }
            else {
                if (start) {
                    [values addObject:tmp];
                }
            }
        }
        
        if (keys.count != values.count) {
            printf("img-cp 参数:\n");
            printf("-s //源文件夹 \n"
                   "-d //目标文件夹 \n "
                   "-v true //仅显示对比列表");
            return -1;
        }
        
        NSDictionary *dict = [NSDictionary dictionaryWithObjects:values forKeys:keys];
        
        NSFileManager* mgr = [NSFileManager defaultManager];
        NSString* src = dict[@"s"];
        NSString* des = dict[@"d"];
        BOOL bViewStatus = [[dict[@"v"] lowercaseString] isEqualToString:@"true"];
        
        if (isDirectoryExist(src) && isDirectoryExist(des)) {
            //PASS
        }
        else {
            printf("img-cp 参数:\n");
            printf("-s //源文件夹 \n"
                   "-d //目标文件夹 \n "
                   "-v true //仅显示对比列表");
            return -1;
        }
        
        NSArray* array = [mgr subpathsAtPath:src];
        for (NSString* name in array) {
            NSString* src_path = [src stringByAppendingPathComponent:name];
            if ([src_path.pathExtension.lowercaseString isEqualToString:@"png"]
                || [src_path.pathExtension.lowercaseString isEqualToString:@"jpg"]
                || [src_path.pathExtension.lowercaseString isEqualToString:@"jpeg"]) {
                NSString* des_path = [des stringByAppendingPathComponent:name];
                
                if ([mgr fileExistsAtPath:src_path] && [mgr fileExistsAtPath:des_path]) {
                    if (bViewStatus) {
                        NSLog(@"will replace %@", name);
                    }
                    else {
                        [mgr removeItemAtPath:des_path error:nil];
                        
                        NSError* err = nil;
                        if ([mgr copyItemAtPath:src_path toPath:des_path error:&err]) {
                            NSLog(@"copy and replace %@", name);
                        }
                        else {
                            NSLog(@"failed to replace file %@", name);
                        }
                    }
                }
                else {
                    NSLog(@"image not exist %@", name);
                }
            }
        }
    }
    return 0;
}

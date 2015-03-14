//
//  SharedInstallManager.h
//  InstallProgress
//
//  Created by star on 14/12/21.
//  Copyright (c) 2014年 Star. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SharedInstallManager : NSObject

@property (strong, nonatomic)NSMutableArray *installAry;


+(SharedInstallManager *)shareInstallInstance;

-(void)updateInstallList;

@end

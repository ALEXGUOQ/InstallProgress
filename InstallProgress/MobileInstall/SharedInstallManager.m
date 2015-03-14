//
//  SharedInstallManager.m
//  InstallProgress
//
//  Created by star on 14/12/21.
//  Copyright (c) 2014年 Star. All rights reserved.
//

#import "SharedInstallManager.h"

#import "LSApplicationProxy.h"
#import "LSApplicationWorkspace.h"
#import <dlfcn.h>

#import "InstallingModel.h"

@implementation SharedInstallManager

+(SharedInstallManager *)shareInstallInstance{
    
    static SharedInstallManager *shareInstallInstance = nil;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        
        if (shareInstallInstance == nil) {
            
            shareInstallInstance = [[SharedInstallManager alloc] init];
        }
        
    });
    
    return shareInstallInstance;
}

- (id)init
{
    self = [super init];
    if (self) {
        _installAry = [[NSMutableArray alloc] init];
        
        [self updateInstallList];
        
    }
    return self;
}


-(void)updateInstallList{

    void *lib = dlopen("/System/Library/Frameworks/MobileCoreServices.framework/MobileCoreServices", RTLD_LAZY);
    
    if (lib)
    {
        Class LSApplicationWorkspace = NSClassFromString(@"LSApplicationWorkspace");
        id AAURLConfiguration1 = [LSApplicationWorkspace defaultWorkspace];
        
        if (AAURLConfiguration1)
        {
            id arrApp = [AAURLConfiguration1 allApplications];
            
            for (int i=0; i<[arrApp count]; i++) {
                
                LSApplicationProxy *LSApplicationProxy = [arrApp objectAtIndex:i];
                NSString* bundleId =[LSApplicationProxy applicationIdentifier];
               
                
                NSProgress *progress = (NSProgress *)[LSApplicationProxy installProgress];
                InstallingModel *model = [self getInstallModel:bundleId];

                if (progress)
                {
                    if (model) {
                        
                        model.progress = [progress localizedDescription];
                        model.status  =  [NSString stringWithFormat:@"%@",[[progress userInfo] valueForKey:@"installState"]];
                        
                    }else{
                        InstallingModel *model = [[InstallingModel alloc] init];
                        
                        model.bundleID = bundleId;
                        model.progress = [progress localizedDescription];
                        model.status  = [NSString stringWithFormat:@"%@",[[progress userInfo] valueForKey:@"installState"]];
                        
                        [_installAry addObject:model];
                    }
                    
                }else{
                
                    [_installAry removeObject:model];
                }
            }
        }
        
        if (lib) dlclose(lib);
    }

}


-(InstallingModel *)getInstallModel:(NSString *)bunldID{

    for (InstallingModel *model in _installAry) {
        
        if ([model.bundleID isEqualToString:bunldID]) {
            
            return model;
        }
    }

    return nil;
}

@end

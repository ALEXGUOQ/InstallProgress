//
//  ViewController.m
//  InstallProgress
//
//  Created by star on 14/12/21.
//  Copyright (c) 2014年 Star. All rights reserved.
//

#import "ViewController.h"
#import "SharedInstallManager.h"
#import "InstallingModel.h"

@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *installingTB;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  
    
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(refreshProgress) userInfo:nil repeats:YES];
}


-(void)refreshProgress{

    [[SharedInstallManager shareInstallInstance] updateInstallList];
    
    
    [_installingTB reloadData];
}

#pragma mark- UITableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return  [[SharedInstallManager shareInstallInstance].installAry count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 44.0f;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"installingID"];
   
    UILabel *bunldIDLB = (UILabel *)[cell.contentView viewWithTag:10000];
    UILabel *progressLB = (UILabel *)[cell.contentView viewWithTag:10001];
    UILabel *statuLB = (UILabel *)[cell.contentView viewWithTag:10002];
    
    InstallingModel *model = [[SharedInstallManager shareInstallInstance].installAry objectAtIndex:indexPath.row];
    bunldIDLB.text = model.bundleID;
    progressLB.text = model.progress;
    statuLB.text = model.status;
    
    return cell;
}

@end

//
//  ViewController.m
//  ProtocolInjection
//
//  Created by 李浩 on 2019/12/8.
//  Copyright © 2019 GodL. All rights reserved.
//

#import "ViewController.h"
#import "Runnable.h"

@interface ViewController ()<Runnable>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"%d   %@",self.canRun,[[self class] runClass]);
    // Do any additional setup after loading the view.
}

@end

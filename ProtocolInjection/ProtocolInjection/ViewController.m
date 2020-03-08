//
//  ViewController.m
//  ProtocolInjection
//
//  Created by 李浩 on 2019/12/8.
//  Copyright © 2019 GodL. All rights reserved.
//

#import "ViewController.h"
#import "Runnable.h"


@interface ViewController ()<Singable>

@end
 
injectionable(ViewController)

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"%d %@ %d   %@",self.canRun,self.name,self.canSing,[[self class] runClass]);
    // Do any additional setup after loading the view.
}

@end

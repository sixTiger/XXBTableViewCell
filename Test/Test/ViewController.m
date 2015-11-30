//
//  ViewController.m
//  Test
//
//  Created by xiaobing on 15/11/15.
//  Copyright © 2015年 xiaobing. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    UITextField *textFiled  = [[UITextField alloc] initWithFrame:CGRectMake(0, 80, 100, 100)];
    textFiled.placeholder = @"hajkdhakjd";
    [self.view addSubview:textFiled];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.navigationController pushViewController:[[ViewController alloc] init]animated:YES];
}
@end

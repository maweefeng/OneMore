//
//  SecondViewController.m
//  oneMore
//
//  Created by Weefeng Ma on 2017/11/17.
//  Copyright © 2017年 maweefeng. All rights reserved.
//

#import "SecondViewController.h"
#import "WeiboAuthViewController.h"
@interface SecondViewController ()

@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}
- (IBAction)accessThirdApi:(UIButton *)sender {
    
    switch (sender.tag) {
            case 1:
            //微博
        {
            WeiboAuthViewController * vc = [[WeiboAuthViewController alloc]init];
            vc.title = @"微博授权";
            [self.navigationController pushViewController:vc animated:YES];
        }
        

            break;
            case 2:
            //豆瓣
            break;
            case 3:
            //ins
            break;
            
        default:
            break;
    }
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

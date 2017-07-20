//
//  ViewController.m
//  StockLine
//
//  Created by wanglei on 2017/7/19.
//  Copyright © 2017年 wanglei. All rights reserved.
//

#import "ViewController.h"
#import "WLHorizontalKlineController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIButton *fenshiButton;
@property (weak, nonatomic) IBOutlet UIButton *kLineButton;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
}
- (IBAction)fenshiClick:(id)sender {
    WLHorizontalKlineController *ctrl = [[WLHorizontalKlineController alloc] init];
    [ctrl setLineViewType:WLShowHightLightView_Time];
    [self presentViewController:ctrl animated:YES completion:nil];
}

- (IBAction)kLineClick:(id)sender {
    WLHorizontalKlineController *ctrl = [[WLHorizontalKlineController alloc] init];
    [ctrl setLineViewType:WLShowHightLightView_KLine];
    [self presentViewController:ctrl animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

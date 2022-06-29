//
//  ViewController.m
//  codeViewDemo
//
//  Created by NJK on 2022/6/29.
//

#import "ViewController.h"

#import <Masonry.h>
#import "NJKVerificationCodeViewHeader.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self creadeUI];
}
- (void)creadeUI{
    self.view.backgroundColor = UIColor.blueColor;

    NJKVerificationCodeViewConfig *NJKConfig = NJKVerificationCodeViewConfig.new;
    NJKConfig.inputCodeNumber = 6;


    [self.view addSubview:({
        NJKVerificationCodeView *codeView = [[NJKVerificationCodeView alloc] initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, 50) config:NJKConfig];
        codeView.backgroundColor = UIColor.whiteColor;
        codeView.boxBackViewName = @"NJKVerificationBoxBackView";
        codeView.finishBlock = ^(NJKVerificationCodeView * _Nonnull codeView, NSString * _Nonnull code) {
            NSLog(@"%@",code);
        };
        codeView;
    })];
}

@end


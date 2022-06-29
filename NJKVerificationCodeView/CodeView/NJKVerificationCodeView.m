//
//  NJKVerificationCodeView.m
//  CodeTextField
//
//  Created by NJK on 2022/6/24.
//

#import "NJKVerificationCodeView.h"
#import <Masonry/Masonry.h>
#import "NJKVerificationBoxBackView.h"

#define NJKVerificationAnimation @"NJKVerificationAnimation"

@interface NJKVerificationCodeView ()
@property (nonatomic, strong)NJKVerificationCodeViewConfig         *config;
@property (nonatomic, assign)CGFloat                                rootWidth;
@property (nonatomic, assign)CGFloat                                rootHeight;
@property (nonatomic, strong)UITextField                            *rootTextField;
@property (nonatomic, strong)NSMutableArray                         *textFArr;
@property (nonatomic, strong)CAShapeLayer                           *flickerLayer;
@end

@implementation NJKVerificationCodeView

- (instancetype)initWithFrame:(CGRect)frame config:(NJKVerificationCodeViewConfig *)config{
    if (self = [super initWithFrame:frame]) {
        self.config = config;
        self.rootWidth = self.frame.size.width;
        self.rootHeight = self.frame.size.height;

        [self updateConfig];
        [self creadeUI];
    }
    return self;
}

- (void)updateConfig{
#pragma ===================== 这里处理的是空间不够用的情况
    if ((self.config.padding.left+self.config.padding.right  - self.config.inputCodeNumber*2 + 1)>self.rootWidth) {//左右边距和不能大于父宽度
        self.config.inputBoxSpacing = 1;
        self.config.inputBoxWidth = 1;
        self.config.padding = UIEdgeInsetsMake(self.config.padding.top, (self.rootWidth - self.config.inputCodeNumber*2 + 1)/2, self.config.padding.bottom, (self.rootWidth - self.config.inputCodeNumber*2 + 1)/2);
    }
    if ((self.config.padding.top+self.config.padding.bottom + 1)>self.rootHeight) {//上下边距和不能大于父高度
        self.config.inputBoxHeight = 1;
        self.config.padding = UIEdgeInsetsMake((self.rootHeight-1)/2, self.config.padding.left, (self.rootHeight-1)/2, self.config.padding.right);
    }

    if ((self.config.padding.left+self.config.padding.right+self.config.inputCodeNumber*(self.config.inputBoxWidth+self.config.inputBoxSpacing)-self.config.inputBoxSpacing)>self.rootWidth) {//间距和宽度的设置
        if ((self.config.padding.left+self.config.padding.right+self.config.inputCodeNumber*(self.config.inputBoxWidth+1) - 1)>self.rootWidth) {//没有间隔时，如果还是大
            self.config.inputBoxSpacing = 1;
            self.config.inputBoxWidth = (self.rootWidth - (self.config.padding.left+self.config.padding.right) + 1)/self.config.inputCodeNumber - 1;
        }else{
            self.config.inputBoxSpacing = (self.rootWidth - (self.config.padding.left+self.config.padding.right) - self.config.inputCodeNumber*self.config.inputBoxWidth)/(self.config.inputCodeNumber-1);
        }
    }
    if ((self.config.padding.top+self.config.padding.bottom+self.config.inputBoxHeight)>self.rootHeight) {//高度的设置
        self.config.inputBoxHeight = self.rootHeight - (self.config.padding.top+self.config.padding.bottom);
    }

#pragma ===================== 这里处理的是空间未使用完整的情况
    if ((self.config.padding.left+self.config.padding.right+self.config.inputCodeNumber*(self.config.inputBoxWidth+self.config.inputBoxSpacing)-self.config.inputBoxSpacing)<self.rootWidth) {
        CGFloat leftAndRight = (self.rootWidth - (self.config.inputCodeNumber*(self.config.inputBoxWidth+self.config.inputBoxSpacing)-self.config.inputBoxSpacing))/2;
        self.config.padding = UIEdgeInsetsMake(self.config.padding.top, leftAndRight, self.config.padding.bottom, leftAndRight);
    }
    if ((self.config.padding.top+self.config.padding.bottom+self.config.inputBoxHeight)<self.rootHeight) {//高度的设置
        self.config.padding = UIEdgeInsetsMake((self.rootHeight-self.config.inputBoxHeight)/2, self.config.padding.left, (self.rootHeight-self.config.inputBoxHeight)/2, self.config.padding.right);
    }
}
- (void)creadeUI{
    UIStackView *stackView = [[UIStackView alloc] init];
    stackView.spacing = self.config.inputBoxSpacing;
    stackView.backgroundColor = UIColor.yellowColor;
    stackView.axis  =  UILayoutConstraintAxisHorizontal;

    [self addSubview:stackView];
    [stackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.config.padding.left);
        make.top.mas_equalTo(self.config.padding.top);
        make.width.mas_equalTo(self.rootWidth - self.config.padding.left - self.config.padding.right);
        make.height.mas_equalTo(self.rootHeight - self.config.padding.top - self.config.padding.bottom);
    }];



    [self.textFArr removeAllObjects];
    for (int i = 0; i<self.config.inputCodeNumber; i++) {
        UITextField *textF = UITextField.new;
        textF.textAlignment = NSTextAlignmentCenter;
        textF.backgroundColor = UIColor.greenColor;
        textF.userInteractionEnabled = NO;

        [stackView addArrangedSubview:textF];
        [self.textFArr addObject:textF];

        [textF mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(self.config.inputBoxWidth));
            make.height.equalTo(@(self.config.inputBoxHeight));
       }];
    }


    self.rootTextField = [[UITextField alloc] init];
    self.rootTextField.frame = CGRectMake(0, CGRectGetHeight(stackView.frame), 0, 0);
    self.rootTextField.keyboardType = self.config.keyboardType;
    self.rootTextField.hidden = YES;
    if (@available(iOS 12.0, *)) {
        self.rootTextField.textContentType = UITextContentTypeOneTimeCode;
    }
    [self addSubview:self.rootTextField];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(RootTextFTextChange:) name:UITextFieldTextDidChangeNotification object:self.rootTextField];
    [self addGestureRecognizer:({
        [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(RootTextFTextChangeTap)];
    })];
}

- (void)setBoxBackViewName:(NSString *)boxBackViewName{
    _boxBackViewName = boxBackViewName;

    for (UITextField *textF in self.textFArr) {
        UIView *boxBackView = [[NSClassFromString(self.boxBackViewName) alloc] init];
        [textF insertSubview:boxBackView atIndex:0];

        __weak typeof(boxBackView) weakBoxBackView = boxBackView;
        [boxBackView mas_makeConstraints:^(MASConstraintMaker *make) {
            __strong typeof(weakBoxBackView) strongBoxBackView = weakBoxBackView;

            make.edges.equalTo(textF);
            if ([strongBoxBackView isKindOfClass:[NJKVerificationBoxBackView class]]) {
                [(NJKVerificationBoxBackView *)strongBoxBackView updateUIAfterFrame];
            }
        }];
    }
}

- (void)RootTextFTextChangeTap{
    [self.rootTextField becomeFirstResponder];
    [self updateTextFS];
}
- (void)RootTextFTextChange:(NSNotification *)noti{
    if (self.rootTextField != noti.object) {
        return;
    }

    [self filterTextCode];
    [self updateTextFS];

    if (self.rootTextField.text.length == self.config.inputCodeNumber) {
        [self TextFSFinish];
    }
}

- (void)filterTextCode{
    NSString *text = [self.rootTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""];

    // number & alphabet
    NSMutableString *mstr = @"".mutableCopy;
    for (int i = 0; i < text.length; ++i) {
        unichar c = [text characterAtIndex:i];
        if (self.config.inputType == NJKConfigInputType_Number_Alphabet) {
            if ((c >= '0' && c <= '9') ||
                (c >= 'A' && c <= 'Z') ||
                (c >= 'a' && c <= 'z')) {
                [mstr appendFormat:@"%c",c];
            }
        }else if (self.config.inputType == NJKConfigInputType_Number) {
            if ((c >= '0' && c <= '9')) {
                [mstr appendFormat:@"%c",c];
            }
        }else if (self.config.inputType == NJKConfigInputType_Alphabet) {
            if ((c >= 'A' && c <= 'Z') ||
                (c >= 'a' && c <= 'z')) {
                [mstr appendFormat:@"%c",c];
            }
        }
    }

    text = mstr;
    NSInteger count = self.config.inputCodeNumber;
    if (text.length > count) {
        text = [text substringToIndex:count];
    }
    self.rootTextField.text = text;
}
- (void)updateTextFS{
    NSString *textString = self.rootTextField.text;
    for (int i = 0; i < self.textFArr.count; ++i) {
        UITextField *textF = self.textFArr[i];
        if (i>=textString.length) {
            textF.text = @"";
        }else{
            unichar c = [textString characterAtIndex:i];
            textF.text = [NSString stringWithFormat:@"%c",c];

#pragma ==========> 光标移动
            [self.flickerLayer removeAnimationForKey:NJKVerificationAnimation];
            [self.flickerLayer removeFromSuperlayer];
            if (i<(self.config.inputCodeNumber-1)) {
                UITextField *nextTextF = self.textFArr[i+1];
                [self.flickerLayer addAnimation:[self xx_alphaAnimation] forKey:NJKVerificationAnimation];
                [nextTextF.layer addSublayer:self.flickerLayer];
            }
        }
    }
    if (!textString.length) {
        UITextField *textF = self.textFArr.firstObject;

        [self.flickerLayer removeAnimationForKey:NJKVerificationAnimation];
        [self.flickerLayer removeFromSuperlayer];
        [self.flickerLayer addAnimation:[self xx_alphaAnimation] forKey:NJKVerificationAnimation];
        [textF.layer addSublayer:self.flickerLayer];
    }
}
- (void)TextFSFinish{
    if (self.finishBlock) {
        self.finishBlock(self, self.rootTextField.text);
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self endEditing:YES];
    });
}

- (NSMutableArray *)textFArr{
    if (!_textFArr) {
        _textFArr = NSMutableArray.array;
    }
    return _textFArr;
}
- (CAShapeLayer *)flickerLayer{
    if (!_flickerLayer) {
        UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(self.config.inputBoxWidth/2-1
                                                                         ,(self.config.inputBoxHeight-self.config.font.lineHeight)/2
                                                                         ,2
                                                                         ,self.config.font.lineHeight)];
        _flickerLayer = [CAShapeLayer layer];
        _flickerLayer.path = path.CGPath;
        _flickerLayer.fillColor = self.config.tintColor.CGColor;
        [_flickerLayer addAnimation:[self xx_alphaAnimation] forKey:NJKVerificationAnimation];
    }
    return _flickerLayer;
}
- (CABasicAnimation *)xx_alphaAnimation{
    CABasicAnimation *alpha = [CABasicAnimation animationWithKeyPath:@"opacity"];
    alpha.fromValue = @(1.0);
    alpha.toValue = @(0.0);
    alpha.duration = 1.0;
    alpha.repeatCount = CGFLOAT_MAX;
    alpha.removedOnCompletion = NO;
    alpha.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    return alpha;
}

@end

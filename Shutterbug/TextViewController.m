//
//  TextViewController.m
//  Shutterbug
//
//  Created by 樊凡 on 15/7/24.
//  Copyright (c) 2015年 Appress. All rights reserved.
//

#import "TextViewController.h"
#import "ChangeFontViewController.h"

@interface TextViewController ()
@property (weak, nonatomic) IBOutlet UITextView *newsText;
@end

@implementation TextViewController

static const unsigned int BUTTON_FIRST  = 20;
static const unsigned int BUTTON_MID    = 10;
static const unsigned int BUTTON_LATER  = 20;
static const unsigned int BUTTON_HEIGHT = 20;

- (IBAction)changeFont:(id)sender
{
    if (self.FontView == nil) {
        //文本控制框
        self.FontView = [[UIView alloc] initWithFrame:CGRectMake(0, -20, self.view.frame.size.width, 100)];
        //self.FontView = [[UIView alloc] initWithFrame:CGRectMake(0, yFontView, self.view.frame.size.width, 100)];
        [self.FontView setTag:5];
        self.FontView.backgroundColor = [UIColor colorWithRed:250/250.0 green:250/250.0 blue:250/250.0 alpha:0.95];
        
        //字体调整框框度
        int buttonWidth = (self.view.frame.size.width - BUTTON_FIRST - BUTTON_MID - BUTTON_LATER) / 2;
        
        //字体调整框y轴
        int yButton = (self.FontView.frame.size.height / 2) - (BUTTON_HEIGHT / 2);
        
        //字体调整加大框
        UIButton *largerFont = [[UIButton alloc] initWithFrame:CGRectMake(BUTTON_FIRST,yButton,buttonWidth,30)];
        //加大框标示
        [largerFont setTag:10];
        //加大框文字和颜色
        [largerFont setTitle:@"Aa+" forState:UIControlStateNormal];
        [largerFont setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        //加大框圆角曲率
        [largerFont.layer setCornerRadius:3];
        //加大框边框宽度和颜色
        [largerFont.layer setBorderWidth:1.0];
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 0, 0, 1, 1 });
        [largerFont.layer setBorderColor:colorref];
        //加大框背景颜色
        largerFont.backgroundColor = [UIColor colorWithRed:245/250.0 green:245/250.0 blue:245/250.0 alpha:0.95];
        //加大框点击事件
        [largerFont addTarget:self action:@selector(changeFontSize:) forControlEvents:UIControlEventTouchDown];
        [largerFont addTarget:self action:@selector(changeFontColor:) forControlEvents:UIControlEventTouchUpInside];
        
        
        //字体调整缩小框
        UIButton *smallerFont = [[UIButton alloc] initWithFrame:CGRectMake(BUTTON_FIRST+buttonWidth+BUTTON_MID,yButton,buttonWidth,30)];
        //缩小框标示
        [smallerFont setTag:20];
        //缩小框文字和颜色
        [smallerFont setTitle:@"Aa-" forState:UIControlStateNormal];
        [smallerFont setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        //缩小框曲率
        [smallerFont.layer setCornerRadius:3];
        //缩小框边框框度和颜色
        [smallerFont.layer setBorderWidth:0.5];
        [smallerFont.layer setBorderColor:colorref];
        //缩小框背景颜色
        smallerFont.backgroundColor = [UIColor colorWithRed:245/250.0 green:245/250.0 blue:245/250.0 alpha:0.95];
        //缩小框点击事件
        [smallerFont addTarget:self action:@selector(changeFontSize:) forControlEvents:UIControlEventTouchDown];
        [smallerFont addTarget:self action:@selector(changeFontColor:) forControlEvents:UIControlEventTouchUpInside];
        
        //添加按钮
        [self.FontView addSubview:largerFont];
        [self.FontView addSubview:smallerFont];

        //添加渐进动画
        int yFontView = self.navigationController.navigationBar.frame.size.height + self.navigationController.navigationBar.frame.origin.y;
        [self.view addSubview:self.FontView];
        [UIView animateWithDuration:0.6  animations:^{
            [self.FontView setFrame:CGRectMake(0, yFontView, self.view.frame.size.width, 100)];
        }];
        
    }
    else {
        //去除
        [UIView animateWithDuration:0.4 animations:^{
            [self.FontView setFrame:CGRectMake(0, -50, self.view.frame.size.width, 100)];
            [self.FontView removeFromSuperview];
            self.FontView = nil;
            
        }];
        
    }
}

- (void)changeFontSize:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    NSRange contentRange = [self.newsText.text rangeOfString:@"\n\n"];
    NSRange tailRange = [self.newsText.text rangeOfString:@"本信息来源于互联网"];
    tailRange.length = [@"本信息来源于互联网，仅供参考，并且不构成任何投资建议或投资劝诱。根据本软件提供的信息进行投资，后果自负。" length];
    
    if ((btn.tag == 10) && (self.contentSize < 25))
    {
        contentRange.length   = tailRange.location - contentRange.location;
        
        self.contentSize += 1;
        self.tailSize += 1;
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setFloat:self.contentSize forKey:@"contentSize"];
        [userDefaults setFloat:self.tailSize forKey:@"tailSize"];
        [userDefaults synchronize];
        
    }
    else if ((btn.tag == 20) && (self.contentSize > 11))
    {
        contentRange.length   = tailRange.location - contentRange.location;
        
        self.contentSize -= 1;
        self.tailSize -= 1;
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setFloat:self.contentSize forKey:@"contentSize"];
        [userDefaults setFloat:self.tailSize forKey:@"tailSize"];
        [userDefaults synchronize];
    }
    
    if ((self.contentSize < 25) && (self.contentSize > 11)) {
        
        [self.newsText.textStorage addAttribute:NSFontAttributeName
                                          value:[UIFont fontWithName:@"helvetica" size:self.contentSize]
                                          range:contentRange];
        
        [self.newsText.textStorage addAttribute:NSFontAttributeName
                                          value:[UIFont fontWithName:@"helvetica" size:self.tailSize]
                                          range:tailRange];
    }
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 0, 1, 0, 1 });
    [btn.layer setBorderColor:colorref];
}

- (void)changeFontColor:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 0, 0, 1, 1 });
    [btn.layer setBorderColor:colorref];
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (NSMutableString *)newsContent
{
    if (!_newsContent) _newsContent = [[NSMutableString alloc] init];
    return _newsContent;
}

- (NSMutableString *)newsTitle
{
    if (!_newsTitle) _newsTitle = [[NSMutableString alloc] init];
    return _newsTitle;
}

-(void)fingerTapped:(UITapGestureRecognizer *)gestureRecognizer

{
    //[self.view endEditing:YES];
    if (self.FontView) {
        CGPoint touchPoint;
        touchPoint = [gestureRecognizer locationOfTouch:0 inView:nil];
        
        CGFloat touchY = self.navigationController.navigationBar.frame.size.height + self.navigationController.navigationBar.frame.origin.y + 100;
        NSLog(@"touch x %f y %f",touchPoint.x,touchPoint.y);
        
        if (touchPoint.y > touchY) {
            CATransition *transition = [CATransition animation];
            transition.duration = 0.4;
            transition.type = kCATransitionFade;
            transition.subtype = kCATransitionFromBottom;
            
            [self.view.layer removeAllAnimations];
            [self.view.layer addAnimation:transition forKey:nil];
            [self.FontView removeFromSuperview];
            self.FontView = nil;
        }
    }
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //添加手势用于消除字体调整窗口
    //self.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fingerTapped:)];
    
    [self.view addGestureRecognizer:singleTap];
    
    NSUserDefaults *userDefaluts = [NSUserDefaults standardUserDefaults];
    self.contentSize = [userDefaluts floatForKey:@"contentSize"];
    self.tailSize    = [userDefaluts floatForKey:@"tailSize"];
    
    if ( (0 == self.contentSize) || (0 == self.tailSize)) {
        self.contentSize = 18.0;
        self.tailSize    = 12.0;
    }
    
    
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    NSString *tmp = [self.newsContent stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    self.newsContent = [NSMutableString stringWithString:tmp];
    tmp = [self.newsContent stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    self.newsContent = [NSMutableString stringWithString:tmp];
    
    NSRange range;
    range = [self.newsTitle rangeOfString:@"："];
    NSString *title = [[NSString alloc] init];
    NSString *subTitle = [[NSString alloc] init];
    if (range.location < 10) {
        title = [self.newsTitle substringFromIndex:range.location+1];
        subTitle = [self.newsTitle substringToIndex:range.location];
        
    } else {
        title = self.newsTitle;
        subTitle = @"分析专栏";
    }
    

    
    NSString *tail = @"本信息来源于互联网，仅供参考，并且不构成任何投资建议或投资劝诱。根据本软件提供的信息进行投资，后果自负。";
   
    
    self.newsText.text = [[NSString alloc] initWithFormat:@"%@\n%@\n\n%@\n%@",title,subTitle,self.newsContent,tail];

    
    range.location = 0;
    range.length = [title length];
    [self.newsText.textStorage addAttribute:NSFontAttributeName
                                      value:[UIFont boldSystemFontOfSize:25.0f]
                                      range:range];
    
    NSMutableParagraphStyle *titleParaStyle = [[NSMutableParagraphStyle alloc] init];
    titleParaStyle.alignment = NSTextAlignmentLeft;
    titleParaStyle.lineSpacing = 6.0;
    [self.newsText.textStorage addAttribute:NSParagraphStyleAttributeName
                                      value:titleParaStyle
                                      range:range];
    
    range.location = [title length];
    range.length   = [subTitle length]+1;
    NSMutableParagraphStyle *subTitleParaStyle = [[NSMutableParagraphStyle alloc] init];
    subTitleParaStyle.alignment = NSTextAlignmentRight;
    [self.newsText.textStorage addAttribute:NSParagraphStyleAttributeName
                                      value:subTitleParaStyle
                                      range:range];
    [self.newsText.textStorage addAttribute:NSForegroundColorAttributeName
                                      value:[UIColor grayColor]
                                      range:range];
    
    
    range.location = [title length] + [subTitle length] + 1;
    range.length = [self.newsContent length]+2;
    [self.newsText.textStorage addAttribute:NSFontAttributeName
                                      value:[UIFont fontWithName:@"helvetica" size:self.contentSize]
                                      range:range];
    
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineSpacing = 12.0;
    paraStyle.firstLineHeadIndent = 28.0;
    paraStyle.paragraphSpacing = 2.0;
    [self.newsText.textStorage addAttribute:NSParagraphStyleAttributeName
                                      value:paraStyle
                                      range:range];
    
    range.location += [self.newsContent length] + 2;
    range.length    = [tail length];
    [self.newsText.textStorage addAttribute:NSForegroundColorAttributeName
                                      value:[UIColor redColor]
                                      range:range];
    [self.newsText.textStorage addAttribute:NSFontAttributeName
                                      value:[UIFont fontWithName:@"helvetica" size:self.tailSize]
                                      range:range];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

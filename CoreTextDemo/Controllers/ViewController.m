//
//  ViewController.m
//  CoreTextDemo
//
//  Created by TangQiao on 13-12-3.
//  Copyright (c) 2013年 TangQiao. All rights reserved.
//

#import "ViewController.h"
#import "CTDisplayView.h"
#import "CTFrameParser.h"
#import "CTFrameParserConfig.h"
#import "ImageViewController.h"
#import "WebContentViewController.h"
#import "CoreTextLinkData.h"

@interface ViewController ()

@property (strong, nonatomic) CTDisplayView *ctView;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupUserInterface];
    [self setupNotifications];
}

- (void)setupUserInterface {
    CTFrameParserConfig *config = [[CTFrameParserConfig alloc] init];
    config.width = kScreenWidth-30;
    NSString *path = [[NSBundle mainBundle] pathForResource:@"content" ofType:@"json"];
    CoreTextData *data = [CTFrameParser parseTemplateFile:path config:config];
    
//    NSArray *array = @[@{ @"color" : @"0x575757", @"content" : @"CoreText排版 \n", @"size" : @22, @"type" : @"txt"},@{ @"color" : @"0x9C9C9C",@"content" : @"阅读量:232 作者：boy n",@"size" : @12, @"type" : @"txt"}];
//    CoreTextData *data = [CTFrameParser parseTemplateData:array config:config];
    self.ctView = [[CTDisplayView alloc] initWithFrame:CGRectMake(15, 20, self.view.frame.size.width-30, self.view.frame.size.height-40)];
    self.ctView.data = data;
    self.ctView.height = data.height;
    self.ctView.backgroundColor = [UIColor whiteColor];
    self.ctView.userInteractionEnabled = YES;

    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    scrollView.contentSize = CGSizeMake(self.view.frame.size.width, data.height+50);
    scrollView.scrollEnabled = YES;
    scrollView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:scrollView];
    
    [scrollView addSubview:self.ctView];
}

- (void)setupNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(imagePressed:)
                                                 name:CTDisplayViewImagePressedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(linkPressed:)
                                                 name:CTDisplayViewLinkPressedNotification object:nil];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)imagePressed:(NSNotification*)notification {
    NSDictionary *userInfo = [notification userInfo];
    CoreTextImageData *imageData = userInfo[@"imageData"];
    
    ImageViewController *vc = [[ImageViewController alloc] init];
    vc.image = [UIImage imageNamed:imageData.name];
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)linkPressed:(NSNotification*)notification {
    NSDictionary *userInfo = [notification userInfo];
    CoreTextLinkData *linkData = userInfo[@"linkData"];
    
    WebContentViewController *vc = [[WebContentViewController alloc] init];
    vc.urlTitle = linkData.title;
    vc.url = linkData.url;
    vc.dataId = linkData.dataId;
    [self presentViewController:vc animated:YES completion:nil];
}
@end

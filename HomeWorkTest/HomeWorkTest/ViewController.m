//
//  ViewController.m
//  HomeWorkTest
//
//  Created by pxh on 16/4/9.
//  Copyright © 2016年 裴新华. All rights reserved.
//

#import "ViewController.h"
#import "FirstViewController.h"
#import "SecondViewController.h"

#define kSCREEN_WIDTH   CGRectGetWidth([UIScreen  mainScreen].bounds)
#define kSCRENN_HEIGHT  CGRectGetHeight([UIScreen mainScreen].bounds)

@interface ViewController ()<UIScrollViewDelegate>
@property (weak, nonatomic ) IBOutlet UISegmentedControl   *headerSegment;
@property (weak, nonatomic ) IBOutlet UIScrollView         *contentScrollview;
@property (nonatomic,strong) FirstViewController  * first;
@property (nonatomic,strong) SecondViewController * second;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self setUpScrollView];
    [self setUpChildViewControll];
    [_headerSegment addTarget:self action:@selector(segmentSelect:) forControlEvents:UIControlEventValueChanged];
}
-(void)segmentSelect:(UISegmentedControl*)seg{
    NSInteger index = seg.selectedSegmentIndex;
    CGRect frame = _contentScrollview.frame;
    frame.origin.x = index * CGRectGetWidth(_contentScrollview.frame);
    frame.origin.y = 0;
    [_contentScrollview scrollRectToVisible:frame animated:YES];
}
-(void)setUpScrollView{
    [_contentScrollview setFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kSCRENN_HEIGHT - 66)];
    _contentScrollview.pagingEnabled = YES;
    _contentScrollview.delegate = self;
    _contentScrollview.showsHorizontalScrollIndicator = NO;
    _contentScrollview.bounces = false;
    //方向锁
    _contentScrollview.directionalLockEnabled = YES;
    //取消自动布局
    self.automaticallyAdjustsScrollViewInsets = NO;
    //为scrollview设置大小  需要计算调整
    _contentScrollview.contentSize = CGSizeMake(kSCREEN_WIDTH * 2, kSCRENN_HEIGHT - 66);
}
/**
 *  设置控制的每一个子控制器
 */
-(void)setUpChildViewControll{
    UIStoryboard* storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    self.first = [storyBoard instantiateViewControllerWithIdentifier:@"FirstViewController"];
    self.second = [storyBoard instantiateViewControllerWithIdentifier:@"SecondViewController"];
    
    NSMutableArray* vcs = [NSMutableArray array];
    [vcs addObject:self.first];
    [vcs addObject:self.second];
    for (int i = 0;i< vcs.count; i ++) {
        UIViewController* vc = vcs[i];
        //设置view的大小为contentScrollview单个页面的大小
        vc.view.frame = CGRectMake(i * kSCREEN_WIDTH, 0, kSCREEN_WIDTH, CGRectGetHeight(_contentScrollview.frame));
        [_contentScrollview addSubview:vc.view];
    }
}

#pragma mark - Scrollview delegate
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    CGFloat offSetX = scrollView.contentOffset.x;
    NSInteger ratio = round(offSetX / kSCREEN_WIDTH);
    _headerSegment.selectedSegmentIndex = ratio;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

//
//  ViewController.m
//  TM
//
//  Created by City--Online on 15/11/5.
//  Copyright © 2015年 City--Online. All rights reserved.
//

#import "ViewController.h"
#import "MJRefresh.h"
#import "ViewController1.h"

@interface ViewController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>
@property (nonatomic,strong) ViewController1 *SecondVc;
@property (nonatomic,strong) UITableView *firstTableView;
@property (nonatomic,strong) UIButton *btn;

@property (nonatomic,assign) BOOL isStop;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _isStop=NO;
    
    _firstTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-80)];
    _firstTableView.delegate=self;
    _firstTableView.dataSource=self;
    _firstTableView.bounces=YES;
    _firstTableView.tableHeaderView=[[UIView alloc]initWithFrame:CGRectZero];
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 30)];
    label.text=@"继续拖动,查看更多";
    label.textAlignment=NSTextAlignmentCenter;
    _firstTableView.tableFooterView=label;
    [_firstTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    [self.view addSubview:_firstTableView];
    
    _btn=[UIButton buttonWithType:UIButtonTypeSystem];
    _btn.frame=CGRectMake(0,self.view.bounds.size.height-80, self.view.bounds.size.width, 80);
    _btn.backgroundColor=[UIColor yellowColor];
    [self.view addSubview:_btn];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"Cell"forIndexPath:indexPath];
    cell.backgroundColor=[UIColor blueColor];
    cell.textLabel.text=@"2";
    return cell;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGPoint contentOffset = scrollView.contentOffset;
    CGRect bounds = scrollView.bounds;
    CGSize contentSize = scrollView.contentSize;
    UIEdgeInsets contentInset = scrollView.contentInset;
    CGFloat currentOffset = contentOffset.y + bounds.size.height - contentInset.bottom;
    CGFloat maximumOffset = contentSize.height;
    //当currentOffset与maximumOffset的值相等时，说明scrollview已经滑到底部了。也可以根据这两个值的差来让他做点其他的什么事情
    CGFloat offsetY = currentOffset - maximumOffset;
    
    if (!_isStop && offsetY > 0){
        _SecondVc.view.frame = CGRectMake(0, self.view.bounds.size.height-80-offsetY, self.view.bounds.size.width, self.view.bounds.size.height-80);
    }
    
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    CGPoint offset = scrollView.contentOffset;
    CGRect bounds = scrollView.bounds;
    CGSize size = scrollView.contentSize;
    UIEdgeInsets inset = scrollView.contentInset;
    CGFloat currentOffset = offset.y + bounds.size.height - inset.bottom;
    CGFloat maximumOffset = size.height;
    CGFloat offsetY = currentOffset - maximumOffset;

    if (offsetY > 60) {
        if (!_SecondVc) {
            _SecondVc=[[ViewController1 alloc]init];
            _SecondVc.view.frame=CGRectMake(0, self.view.frame.size.height-80, self.view.frame.size.width, self.view.bounds.size.height-80);
            __weak typeof(self) weakself = self;
            _SecondVc.headRefReshBlock=^()
            {
                __weak typeof(self) weakself2 = weakself;
                [UIView animateWithDuration:0.5 animations:^{
                    weakself2.firstTableView.frame=CGRectMake(0, 0, weakself2.view.bounds.size.width, weakself2.view.bounds.size.height-80);
                    weakself2.SecondVc.view.frame=CGRectMake(0, weakself2.view.bounds.size.height, weakself2.view.bounds.size.width, weakself2.view.bounds.size.height-80);
                } completion:^(BOOL finished) {
                    
                }];
            };
            [self addChildViewController:_SecondVc];
            [self.view insertSubview:_SecondVc.view belowSubview:_btn];
        }
        
        _isStop = YES;
        _firstTableView.contentInset = UIEdgeInsetsMake(0, 0, offsetY, 0);
        
        [UIView animateWithDuration:1 animations:^{
            _firstTableView.frame = CGRectMake(0, -self.view.bounds.size.height+80+offsetY, self.view.bounds.size.width, self.view.bounds.size.height-80);
            _SecondVc.view.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-80);
        } completion:^(BOOL finished) {
            _firstTableView.frame = CGRectMake(0, -self.view.bounds.size.height+80, self.view.bounds.size.width, self.view.bounds.size.height-80);
            _firstTableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                _isStop = !finished;
            });
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

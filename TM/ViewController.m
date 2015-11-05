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

@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) ViewController1 *SecondVc;
@property (nonatomic,strong) UITableView *firstTableView;
@property (nonatomic,strong) UIButton *btn;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _firstTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-80+44)];
    _firstTableView.delegate=self;
    _firstTableView.dataSource=self;
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 30)];
    label.text=@"继续拖动,查看更多";
    label.textAlignment=NSTextAlignmentCenter;
    _firstTableView.tableFooterView=label;
    [_firstTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    [self.view addSubview:_firstTableView];
    _firstTableView.footer=[MJRefreshAutoFooter footerWithRefreshingTarget:self refreshingAction:@selector(FooterRefresh)];
    
    _btn=[UIButton buttonWithType:UIButtonTypeSystem];
    _btn.frame=CGRectMake(0,self.view.bounds.size.height-80, self.view.bounds.size.width, 80);
    _btn.backgroundColor=[UIColor yellowColor];
    [self.view addSubview:_btn];
//    [_firstTableView.footer beginRefreshing];
//    [_firstTableView ]
    
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 20;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

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
-(void)FooterRefresh
{
    NSLog(@"HeadRefresh");
    __block ViewController *weakSelf=self;
    if (_SecondVc==nil) {
        _SecondVc=[[ViewController1 alloc]init];
        
    
        _SecondVc.headRefReshBlock=^()
        {
            [UIView animateWithDuration:0.5 animations:^{
                _firstTableView.frame=CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-80+44);
                _SecondVc.view.frame=CGRectMake(0, self.view.bounds.size.height, self.view.bounds.size.width, self.view.bounds.size.height-80);
            }];
        };
       
        _SecondVc.view.frame=CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.bounds.size.height-80);
        [self addChildViewController:_SecondVc];
        [self.view insertSubview:_SecondVc.view belowSubview:_btn];
       
    }
    [UIView animateWithDuration:0.5 animations:^{
        _firstTableView.frame=CGRectMake(0, -self.view.bounds.size.height, self.view.bounds.size.width, self.view.bounds.size.height-80+44);
        _SecondVc.view.frame=CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-80);
    }];

//    else
//    {
//        [UIView animateWithDuration:0.5 animations:^{
//            _firstTableView.frame=CGRectMake(0, -self.view.bounds.size.height, self.view.bounds.size.width, self.view.bounds.size.height);
//            _SecondVc.view.frame=self.view.bounds;
//        }];
//        
//    }
    
    [_firstTableView.footer endRefreshing];

    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

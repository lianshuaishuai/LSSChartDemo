//
//  ViewController.m
//  LSSChartDemo
//
//  Created by 连帅帅 on 2018/11/10.
//  Copyright © 2018年 连帅帅. All rights reserved.
//

#import "ViewController.h"
#import "LSSChartView.h"
@interface ViewController ()
@property(nonatomic,weak)LSSChartView * chartView;
@property(nonatomic,weak)LSSChartView * chartView1;
@property(nonatomic,strong)UILabel * loadingLabel;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    /**
     要想确定x轴的位置  y轴的坐标要含有0这个数据
     */
    LSSChartView * chartView = [[LSSChartView alloc]init];
    _chartView = chartView;
    chartView.frame = CGRectMake(10, 0, (self.view.bounds.size.width - 10*3)/2.0, self.view.bounds.size.height - 100);
    chartView.backgroundColor = [UIColor whiteColor];
    chartView.width = (self.view.bounds.size.width - 10*3)/2.0;
    chartView.yinterval = 2.0;
    chartView.xinterval = 1.0;
    [self.view addSubview:chartView];
    LSSChartView * chartView1 = [[LSSChartView alloc]init];
    _chartView1 = chartView1;
    chartView1.frame = CGRectMake(CGRectGetMaxX(chartView.frame)+10, 0, (self.view.bounds.size.width - 10*3)/2.0, self.view.bounds.size.height - 100);
    chartView1.backgroundColor = [UIColor whiteColor];
    chartView1.width = (self.view.bounds.size.width - 10*3)/2.0;
    chartView1.yinterval = 2.0;
    chartView1.xinterval = 1.0;
    [self.view addSubview:chartView1];
    [self setUpLoadinLabel];
    [self setUpChartView];

    UIButton * b  = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:b];
    b.frame = CGRectMake(20, self.view.bounds.size.height - 100, 100, 100);
    [b setTitle:@"刷新" forState:UIControlStateNormal];
    [b addTarget:self action:@selector(resh) forControlEvents:UIControlEventTouchUpInside];
    [b setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    b.backgroundColor = [UIColor redColor];
    
}
-(void)setUpLoadinLabel{
    self.loadingLabel = [[UILabel alloc]init];
    self.loadingLabel.textColor = [UIColor blackColor];
    self.loadingLabel.textAlignment = NSTextAlignmentCenter;
    self.loadingLabel.text = @"加载中...";
    self.loadingLabel.frame = CGRectMake(self.view.bounds.size.width/2.0 - 50, self.view.bounds.size.height/2.0 - 6, 100, 12);
    self.loadingLabel.font = [UIFont systemFontOfSize:12];
    [self.view addSubview:self.loadingLabel];
}
-(void)setUpChartView{
    //模拟网络加载
    self.loadingLabel.hidden = NO;

    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0/*延迟执行时间*/ * NSEC_PER_SEC));
    
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
        [_chartView deleteLayerAndSubView];
        [_chartView1 deleteLayerAndSubView];
        self.loadingLabel.hidden = YES;
        //第一条线
        /**
         [NSValue valueWithCGPoint:CGPointMake(2, 4.5)],
         [NSValue valueWithCGPoint:CGPointMake(3, 2)],
         */
        CGFloat secondY = 7.9 * 2 /3.0;
        CGFloat secondX = 3.8 - 2.8*2/3.0;
        CGFloat thressY = 7.9/3.0;
        CGFloat thressX =  3.8 - 2.8 /3.0;
        NSArray *  tmp = @[[NSValue valueWithCGPoint:CGPointMake(0, 0)],
                           [NSValue valueWithCGPoint:CGPointMake(1, 7.9)],
                           
                           [NSValue valueWithCGPoint:CGPointMake(3.8, 0)]];
        NSArray * pointTmp = @[[NSValue valueWithCGPoint:CGPointMake(0, 0)],
                               [NSValue valueWithCGPoint:CGPointMake(1, 7.9)],
                               [NSValue valueWithCGPoint:CGPointMake(secondX, secondY)],
                               [NSValue valueWithCGPoint:CGPointMake(thressX, thressY)],
                               [NSValue valueWithCGPoint:CGPointMake(3.8, 0)]];
        NSArray * lbTmp = @[@"",@"MEF75",@"MEF50",@"MEF25",@"FVC"];
        
        
        //第二条线
        NSArray * dataTmp =  @[[NSValue valueWithCGPoint:CGPointMake(1.0, 2)],
                               [NSValue valueWithCGPoint:CGPointMake(3.0, -1)],
                               [NSValue valueWithCGPoint:CGPointMake(4, 5)]];
        
        //第三条线
        NSArray * thressTmp = @[[NSValue valueWithCGPoint:CGPointMake(0, 6)],
                                [NSValue valueWithCGPoint:CGPointMake(4, 6)]];
        
        NSMutableArray * attributeArray = [NSMutableArray new];
        
        
        //第一个
        LSSChartAttribute * attribute1 = [[LSSChartAttribute alloc]init];
        attribute1.isDottedLine = YES;
        attribute1.labelColor = [UIColor redColor];
        attribute1.cycleColor = [UIColor orangeColor];
        for (int i = 0; i <tmp.count; i++) {
            [attribute1.dataArray addObject:tmp[i]];
        }
        for (int i = 0; i <pointTmp.count; i++) {
            [attribute1.pointArray addObject:pointTmp[i]];
            [attribute1.pointLabelArray addObject:lbTmp[i]];
        }
        [attributeArray addObject:attribute1];
        
        //第二个
        LSSChartAttribute * attribute2 = [[LSSChartAttribute alloc]init];
        attribute2.lineColor = [UIColor redColor];
        for (int i = 0; i <dataTmp.count; i++) {
            [attribute2.dataArray addObject:dataTmp[i]];
        }
        [attributeArray addObject:attribute2];
        
        //第三个
        LSSChartAttribute * attribute3 = [[LSSChartAttribute alloc]init];
        attribute3.isDottedLine = YES;
        for (int i = 0; i <thressTmp.count; i++) {
            [attribute3.dataArray addObject:thressTmp[i]];
        }
        [attributeArray addObject:attribute3];
        [self.chartView drawWithX_name:@[@"1",@"2",@"3",@"4"] andY_name:@[@"14",@"12",@"10",@"8",@"6",@"4",@"2",@"0",@"-2",@"-4",@"-6",@"-8"] andDatarray:attributeArray andXtitle:@"x轴" andYtitle:@"y轴"];
         [self.chartView1 drawWithX_name:@[@"1",@"2",@"3",@"4"] andY_name:@[@"14",@"12",@"10",@"8",@"6",@"4",@"2",@"0",@"-2",@"-4",@"-6",@"-8"] andDatarray:attributeArray andXtitle:@"x轴" andYtitle:@"y轴"];
       
    });
  
}
-(void)resh{
   
    NSLog(@"%@",_chartView);
   
     NSLog(@"%@",_chartView);
    //
   
    [self setUpChartView];
   
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

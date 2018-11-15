//
//  LSSChartView.m
//  LSSChartDemo
//
//  Created by 连帅帅 on 2018/11/10.
//  Copyright © 2018年 连帅帅. All rights reserved.
//

#import "LSSChartView.h"
@implementation LSSChartAttribute
-(NSMutableArray *)dataArray{
    
    if (!_dataArray) {
        
        _dataArray = [NSMutableArray new];
    }
    
    return _dataArray;
}

-(NSMutableArray *)pointArray {
    
    if (!_pointArray) {
        
        _pointArray = [NSMutableArray new];
    }
    
    return _pointArray;
}

-(NSMutableArray *)pointLabelArray{
    
    if (!_pointLabelArray) {
        
        _pointLabelArray = [NSMutableArray new];
    }
    return _pointLabelArray;
}

@end

@interface LSSChartView ()
{
    CGFloat kXWidth;
}
@property(nonatomic,assign)CGFloat yzero;//y轴的0点的位置
@property(nonatomic,assign)CGPoint point;
@property(nonatomic,strong)NSArray<LSSChartAttribute*>
*attributeArray;
@property(nonatomic,strong)NSArray * xnameArr;
@property(nonatomic,strong)NSArray * ynameArr;
@property(nonatomic,strong)UILabel * yLabel;//y轴的标题
@property(nonatomic,strong)UILabel * xLabel;//x轴的标题
@end

@implementation LSSChartView

-(UILabel *)yLabel{
    
    if (!_yLabel) {
        _yLabel = [[UILabel alloc]init];
        _yLabel.textColor = [UIColor blackColor];
        _yLabel.textAlignment = NSTextAlignmentCenter;
        _yLabel.font = [UIFont systemFontOfSize:12];
    }
    return _yLabel;
}
-(UILabel *)xLabel{
    
    if (!_xLabel) {
        
        _xLabel = [[UILabel alloc]init];
        _xLabel.textColor = [UIColor blackColor];
        _xLabel.font = [UIFont systemFontOfSize:12];
    }
    return _xLabel;
}
-(void)drawWithX_name:(NSArray *)xnameArr andY_name:(NSArray *)ynameArr andDatarray:(NSMutableArray<LSSChartAttribute *> *)array andXtitle:(NSString *)xtitle andYtitle:(NSString *)ytitle{
    
    kXWidth = self.width - kX_x * 2;
    //x轴数据
    self.xnameArr = xnameArr;
    //y轴数据
    self.ynameArr =ynameArr;
    //数据线的数组（有多少个数组就有多少个县包括辅助线）
    self.attributeArray = array;
    [self addSubview:self.yLabel];
    self.yLabel.text = ytitle;
    
    [self addSubview:self.xLabel];
    self.xLabel.text = xtitle;
    //创建y轴线
    [self setUpY];
    [self setUpYZ];
    [self setUpYZLabel];
    [self setUpX];
    [self setUpXZ];
    [self setUpXZLabel];
    [self setUpine:self.attributeArray];
}
-(instancetype)init{
    if (self = [super init]) {
        
       
        
    }
    return self;
    
}
-(void)layoutSubviews{
    
    [super layoutSubviews];
    self.yLabel.frame = CGRectMake(kX_x-15, kYTop - 20, 30, 12);
    
    self.xLabel.frame = CGRectMake(kX_x + kXWidth+5, self.yzero - 6, 30, 12);
}

//画线（包括辅助线 数据的线）
-(void)setUpine:(NSArray<LSSChartAttribute *>*)array{
    
    for (LSSChartAttribute * attribute in array) {
        
        // 画数据的线
        [self setUpDataLine:attribute];
    }
}
//画数据的线
-(void)setUpDataLine:(LSSChartAttribute *)attribute{
    
    //没有数据的情况下 直接return
    if (!attribute.dataArray.count) return;
    CGPoint point = attribute.dataArray[0].CGPointValue;
    CGFloat x = (kXWidth/(CGFloat)self.xnameArr.count)/self.xinterval *point.x+kX_x;
    
    CGFloat y = self.yzero - point.y/self.yinterval*(kYHeight/(CGFloat)self.ynameArr.count);
    UIBezierPath *path1 = [UIBezierPath bezierPath];
    [path1 moveToPoint:CGPointMake(x, y)];
    for (int i =1 ; i < attribute.dataArray.count ;i++) {
        CGPoint point = attribute.dataArray[i].CGPointValue;
        CGFloat x = (kXWidth/(CGFloat)self.xnameArr.count)/self.xinterval*point.x+kX_x;
        
        CGFloat y = self.yzero - point.y/self.yinterval*(kYHeight/(CGFloat)self.ynameArr.count);
        
        [path1 addLineToPoint:CGPointMake(x, y)];//添加一条子路径
        
    }
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    if (attribute.isDottedLine) {
        //是否是虚线
        [shapeLayer setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithInt:5], [NSNumber numberWithInt:2],nil]];
    }
    
    shapeLayer.path = path1.CGPath;
    UIColor * lineCor = attribute.lineColor ? attribute.lineColor :[UIColor blackColor];
    shapeLayer.strokeColor = lineCor.CGColor;
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    
    shapeLayer.lineWidth = [self setUpLineWidth:attribute];
    [self.layer addSublayer:shapeLayer];
    //画圆点
    [self setUpCycleAndLabel:attribute];
}
//线的宽度
-(CGFloat)setUpLineWidth:(LSSChartAttribute *)attri{
    CGFloat lineWidth = attri.lineWidth ? attri.lineWidth : 1.0;
    return lineWidth;
}
//是否需要画圆点和圆点的label
-(void)setUpCycleAndLabel:(LSSChartAttribute *)attribute{
    NSMutableArray *allPoints = [NSMutableArray array];
    CGFloat cornerRadius = attribute.cycleRudius ? attribute.cycleRudius : 3.0;
    for (int i = 0; i< attribute.pointArray.count; i++) {
        
        CGPoint point = attribute.pointArray[i].CGPointValue;
        
        CGFloat  x = (kXWidth/(CGFloat)self.xnameArr.count)/self.xinterval*point.x+kX_x;
        CGFloat  y = self.yzero - point.y/self.yinterval*(kYHeight/(CGFloat)self.ynameArr.count);
        x = x - [self setUpLineWidth:attribute]/2.0;
        y = y - [self setUpLineWidth:attribute]/2.0;
        
        //剪去线宽的一半
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(x, y, cornerRadius, cornerRadius) cornerRadius:cornerRadius];
        CAShapeLayer *layer = [CAShapeLayer layer];
        UIColor * cycleCor = attribute.cycleColor ? attribute.cycleColor :[UIColor blackColor];
        layer.strokeColor = cycleCor.CGColor;
        layer.fillColor = [UIColor purpleColor].CGColor;
        layer.path = path.CGPath;
        [self.layer addSublayer:layer];
        [allPoints addObject:[NSValue valueWithCGPoint:CGPointMake(x, y)]];
        
        UILabel * LevelLabel= [[UILabel alloc]initWithFrame:CGRectMake(x + 2, y-12, 80, 10)];
        LevelLabel.text = attribute.pointLabelArray[i];
        UIColor * labelCor = attribute.labelColor ? attribute.labelColor :[UIColor blackColor];
        LevelLabel.textColor = labelCor;
        LevelLabel.font = [UIFont systemFontOfSize:10];
        [self addSubview:LevelLabel];
    }
    
    
}

-(void)setUpX{
    UIBezierPath *path1 = [UIBezierPath bezierPath];
    [path1 moveToPoint:CGPointMake(kX_x, self.yzero)];
     [path1 addLineToPoint:CGPointMake(kXWidth + kX_x, self.yzero)];//添加一条子路径
     CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = path1.CGPath;
//    UIColor * lineCor = attribute.lineColor ? attribute.lineColor :[UIColor blackColor];
    shapeLayer.strokeColor = [UIColor grayColor].CGColor;
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    
    shapeLayer.lineWidth = 0.5;
    [self.layer addSublayer:shapeLayer];

}
-(void)setUpY{
    UIBezierPath *path1 = [UIBezierPath bezierPath];
    [path1 moveToPoint:CGPointMake(kX_x, kYHeight - kYHeight/(CGFloat)self.ynameArr.count+kYTop)];
    [path1 addLineToPoint:CGPointMake(kX_x, kYTop)];//添加一条子路径
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = path1.CGPath;
    //    UIColor * lineCor = attribute.lineColor ? attribute.lineColor :[UIColor blackColor];
    shapeLayer.strokeColor = [UIColor grayColor].CGColor;
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    
    shapeLayer.lineWidth = 0.5;
    [self.layer addSublayer:shapeLayer];

}
-(CGFloat)xz:(CGFloat)i{
    CGFloat x = (i + 1)* (kXWidth/(CGFloat)self.xnameArr.count)+kX_x;
    return x;
}
//添加x轴
-(void)setUpXZ{
   
    CGFloat heigth = self.yzero  + kWidthAndHeight;
    for (int i = 0; i < self.xnameArr.count; i++) {
        
        CGFloat x = [self xz:i];
       
        UIBezierPath *path1 = [UIBezierPath bezierPath];
        [path1 moveToPoint:CGPointMake(x-0.5, heigth)];
        [path1 addLineToPoint:CGPointMake(x-0.5, self.yzero)];//添加一条子路径
        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        shapeLayer.path = path1.CGPath;
        //    UIColor * lineCor = attribute.lineColor ? attribute.lineColor :[UIColor blackColor];
        shapeLayer.strokeColor = [UIColor grayColor].CGColor;
        shapeLayer.fillColor = [UIColor clearColor].CGColor;
        
        shapeLayer.lineWidth = 0.5;
        [self.layer addSublayer:shapeLayer];
    }
}

-(CGFloat)yz:(CGFloat)i{
    CGFloat y = i* (kYHeight/(CGFloat)self.ynameArr.count)+kYTop;
    return y;
}
//添加y轴
-(void)setUpYZ{
   
    CGFloat x = kX_x - kWidthAndHeight;
    
    for (int i = 0; i < self.ynameArr.count; i++) {
        
        CGFloat y = [self yz:i];
        NSInteger index = [self.ynameArr indexOfObject:@"0"];
        if (i == index) {
            self.yzero = y;
        }
        UIBezierPath *path1 = [UIBezierPath bezierPath];
        [path1 moveToPoint:CGPointMake(x, y)];
        [path1 addLineToPoint:CGPointMake(kX_x, y)];//添加一条子路径
        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        shapeLayer.path = path1.CGPath;
        //    UIColor * lineCor = attribute.lineColor ? attribute.lineColor :[UIColor blackColor];
        shapeLayer.strokeColor = [UIColor grayColor].CGColor;
        shapeLayer.fillColor = [UIColor clearColor].CGColor;
        
        shapeLayer.lineWidth = 0.5;
        [self.layer addSublayer:shapeLayer];

    }
}

//创建x轴上面的label
-(void)setUpXZLabel{
    for (int i = 0; i < self.xnameArr.count; i++) {
        CGFloat width = kXWidth/(CGFloat)self.xnameArr.count;
        CGFloat x = (i + 1)* width+kX_x;
        //此处的2是距离x轴线的距离
        CGFloat y = self.yzero + kWidthAndHeight + 2;
        UILabel * LevelLabel= [[UILabel alloc]initWithFrame:CGRectMake(x-width/2.0, y, width, 12)];
        LevelLabel.textAlignment=NSTextAlignmentCenter;
        
        LevelLabel.text = self.xnameArr[i];
        
        LevelLabel.textColor = [self setUpXAndYLabelCor];
        LevelLabel.font = [UIFont systemFontOfSize:12];
        [self addSubview:LevelLabel];
    }
}

//创建y轴上面的label
-(void)setUpYZLabel{
    for (int i = 0; i < self.ynameArr.count; i++) {
        CGFloat height = 12;
        CGFloat width = 20;
        CGFloat x = kX_x - kWidthAndHeight -width;
        CGFloat y = i* (kYHeight/(CGFloat)self.ynameArr.count)+kYTop-height/2.0;
        UILabel * LevelLabel= [[UILabel alloc]initWithFrame:CGRectMake(x, y, width, height)];
        LevelLabel.textAlignment=NSTextAlignmentCenter;
        
        LevelLabel.text = self.ynameArr[i];
        
        LevelLabel.textColor = [self setUpXAndYLabelCor];
        LevelLabel.font = [UIFont systemFontOfSize:12];
        [self addSubview:LevelLabel];
    }
}
-(UIColor *)setUpXAndYLabelCor{
    UIColor * cor = self.xAndYLabelCor ? self.xAndYLabelCor : [UIColor blackColor];
    return cor;
}

/**
 移除所有的控件以及layer
 */
-(void)deleteLayerAndSubView{
   
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
//    [self removeFromSuperview];
    [self.layer.sublayers makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
//    [self.layer removeFromSuperlayer];
   
}
-(void)dealloc{
    NSLog(@"333");
}
@end

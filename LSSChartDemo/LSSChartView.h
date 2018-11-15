//
//  LSSChartView.h
//  LSSChartDemo
//
//  Created by 连帅帅 on 2018/11/10.
//  Copyright © 2018年 连帅帅. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kWidthAndHeight 5//线的宽度以及高度
#define kYTop 100
#define kYHeight 200

#define kX_x 30.0
/**
 
 明天需要抽出来属性画线设置一个继承nsobject一个东西  根据个数开辟数组就是想要的继承nsobject的类（这个类里面写的要有点的坐标数组（存的是cgpoint）  还有就是现实lable的数组 只要现实label必须存的点的数组一致 这个数组一定要是可变数组 写成懒加载的形式）
 这个类需要的属性是  线的个数 是否是 虚线  线的颜色 是否需要展示小圆点 是否需要显示label  垂直x轴还是垂直y轴 y轴的间隔 x轴的间隔  折线的数据 显示label的位置 上 下 左 右 x轴tile的位置 右 下 （预留属性是否有柱形图）
 */
//发送状态
typedef enum : NSInteger{
    pointRight = 0,//默认
    pointLeft,
    pointTop,
    pointBottom
}pointLabelPosition;
/**
 本view中开辟三个可变数组 一个 是 x轴 y轴 以及存画线类的数组  还有就是y轴的间距以及x轴的间距
 */
@interface LSSChartAttribute : NSObject
/**
 存储的是画线的数据
 */
@property(nonatomic,strong)NSMutableArray<NSValue*>
*dataArray;
/**
 存储的是圆点的数据 (可以和画线的数据个数不同但是必须和圆点的label个数相同)
 */
@property(nonatomic,strong)NSMutableArray<NSValue *>
*pointArray;
/**
 存储的是圆点上面的label
 */
@property(nonatomic,strong)NSMutableArray<NSString *>
*pointLabelArray;

/**
 线的颜色
 */
@property(nonatomic,strong)UIColor
*lineColor;//默认黑色
/**
 圆点的颜色
 */
@property(nonatomic,strong)UIColor
*cycleColor;//默认黑色
/**
 label的颜色
 */
@property(nonatomic,strong)UIColor
*labelColor;//默认黑色
/**
 是虚线还是实线默认实线
 */
@property(nonatomic,assign)BOOL isDottedLine;
/**
 label的位置 默认右边
 */
@property(nonatomic,assign)pointLabelPosition position;

/**
 圆圈的大小
 */
@property(nonatomic,assign)CGFloat cycleRudius;//默认是3

/**
 线的宽度
 */
@property(nonatomic,assign)CGFloat lineWidth;//默认是2.0
@end

@interface LSSChartView : UIView
@property(nonatomic,assign)CGFloat yinterval;//y轴的间距是多大
@property(nonatomic,assign)CGFloat xinterval;//x轴的间距是多大（一般是1）
@property(nonatomic,strong)UIColor * xAndYLabelCor;//x y轴的label颜色 //默认黑色
@property(nonatomic,assign)CGFloat width;

/**
 根据array的个数画多少线（包括数据线和辅助线等等）
 */
-(void)drawWithX_name:(NSArray *)xnameArr
                    andY_name:(NSArray *)ynameArr
                  andDatarray:(NSMutableArray <LSSChartAttribute *>*)array
                    andXtitle:(NSString *)xtitle
                    andYtitle:(NSString *)ytitle;

/**
 移除所有的控件以及layer
 */
-(void)deleteLayerAndSubView;
@end

//
//  BaseTableViewImpl.h
//  NormalCoder
//
//  Created by Jason on 7/7/16.
//  Copyright © 2016 JasCoder. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  tableview service delegate declare
 */
@protocol ServiceTableViewDelegate <NSObject>

@optional

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

@end

@protocol BaseTableViewDelegate <UITableViewDataSource,UITableViewDelegate>

@optional

/**
 *  Packing a foundation class to a JASBaseCellModel object,just for UITableViewCell at present
 *
 *  @param obj founcation class
 *
 *  @return a JASBaseCellModel object
 */
- (id)packFoundationClass:(id)obj;

@end

/*
 *  目前扩展提供3种方式(cdelegate有值 => 3,cdeldate没有值 sdelegate有值 => 2, 两者都没有值 => 1)
 *      1.纯粹继承项目中的某个tableview类(视图和视图控制器的耦合性低)
 *         1.1 在子类中实现数据源,代理等方法
 *         1.2 新建继承项目中的某个中cell类(实现setModel:方法)
 *         1.3 控制器仅负责视图的创建(提供数据源,frame等)与展现
 *       2.控制器遵守sdelegate,继承或直接使用项目中的tableView类(控制器和业务的联系可以比较紧密)
 *       3.控制器(继承JASTableViewController)遵守cdelegate,继承或直接使用项目中的tableView(主要简化了tableview的数据源代理部分,其他与平时开发类似)
 */
@interface AbstractBaseTableView : UITableView <BaseTableViewDelegate>{
    NSArray *_dataList;
}

/**
 *  UITableView cell class
 */
@property (nonatomic,strong,readonly) Class cellClass;

/**
 *  reuse flag
 */
@property (nonatomic,copy,readonly) NSString *identifier;

/**
 *  the dataList of tableview
 */
@property (nonatomic,strong) NSArray *dataList;

/**
 *  If you like use vc to become tableview delegate object,set it.
 */
@property (nonatomic,weak) id<BaseTableViewDelegate> cdelegate;

/**
 *  关注点击在cell触发动作的代理
 *  因为点击触发的操作与具体的业务有关,
 *  可以放在工程对应的vc中实现
 */
@property (nonatomic,weak) id<ServiceTableViewDelegate> sdelegate;

/**
 *  If need custom setter method
 */
@property (nonatomic,assign) BOOL customSetter;

/**
 *  It's a shortcut property to show system UITableViewCell type
 */
@property (nonatomic,assign) UITableViewCellStyle cellStyle;

/**
 *  the tableview cell reuse times;
 */
@property (nonatomic,assign) NSUInteger reuseCount;

/**
 *  register tableview cell class and set a reuse id which equal to classname
 *
 *  @param cellClass which class is tableview cell
 */
- (void)registerClass:(Class)cellClass;

@end

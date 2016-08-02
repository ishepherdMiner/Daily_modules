//
//  BaseTableViewControllerDemo.m
//  DRArtisan
//
//  Created by Jason on 7/31/16.
//  Copyright © 2016 DR. All rights reserved.
//

#import "BaseTableViewControllerDemo.h"
#import "FlexibleHeightTableView.h"

@interface BaseTableViewControllerDemo () <ServiceTableViewDelegate>

@property (nonatomic,weak) BaseTableView *base_table_v;

@property (nonatomic,copy) NSArray * (^modelBlock)(NSArray *);

@property (nonatomic,strong) NSArray *datas;

@property (nonatomic,assign) NSInteger identifier;

@end

@implementation BaseTableViewControllerDemo

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // Set demo cell option
    self.identifier = 3;
    [self tableViewDemoWithIdentifier:self.identifier];
}

- (void)tableViewDemoWithIdentifier:(NSInteger)identifier {
    
    // 使用流程:
    // 1.创建tableview对象
    //
    // BaseTableView:系统的cell
    // FlexibleHeightTabelView:自定义cell [可指定高度]
    // 
    //
    // BaseTableView *base_table_v = [BaseTableView tableViewWithFrame:fRect(kZero,kZero, Screen_width, Screen_height) style:UITableViewStylePlain dataList:[self datas]];
    
    // 2.注册cell对象(要求实现:setModel:方法)
    // [base_table_v registerClass:[JASDefaultCell class]];
    
    // 3.设置cell的内容类型,默认为UITableViewCellDefault(option)
    // base_table_v.cellStyle = UITableViewCellStyleDefault;
    
    // 4.添加到父视图
    // [self.view addSubview:_base_table_v = base_table_v];
    
    // 创建TableView
    BaseTableView *base_table_v = [BaseTableView tableViewWithFrame:fRect(kZero,kZero, Screen_width, Screen_height) style:UITableViewStylePlain dataList:[self datas]];
    switch (identifier) {
        case UITableViewCellStyleDefault:{
            [base_table_v registerClass:[JASDefaultCell class]];
            // option
            base_table_v.cellStyle = UITableViewCellStyleDefault;
        }
            break;
        case UITableViewCellStyleValue1:{
            [base_table_v registerClass:[JASValue1Cell class]];
            base_table_v.cellStyle = UITableViewCellStyleValue1;
        }
            break;
        case UITableViewCellStyleValue2:{
            [base_table_v registerClass:[JASValue2Cell class]];
            base_table_v.cellStyle = UITableViewCellStyleValue2;
        }
            break;
        case UITableViewCellStyleSubtitle:{
            [base_table_v registerClass:[JASSubtitleCell class]];
            base_table_v.cellStyle = UITableViewCellStyleSubtitle;
        }
            break;
    }
    
    // options
    base_table_v.sdelegate = self;
    
    [self.view addSubview:_base_table_v = base_table_v];

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // 点击cell执行相关操作
    XcLog(@"点击了%zd组%zd行",indexPath.section,indexPath.row);
}


- (NSArray *)datas {
    if (_datas == nil) {
        __weak typeof(self) weakself = self;
        self.modelBlock = ^(NSArray *dicList) {
            NSMutableArray *modelsM = [NSMutableArray arrayWithCapacity:[dicList count]];
            for (NSDictionary *dic in dicList) {
                switch (weakself.identifier) {
                    case 0:{
                        [modelsM addObject:[JASDefaultCellModel modelWithDic:dic]];
                    }
                        break;
                    case 1:{
                        [modelsM addObject:[JASValue1CellModel modelWithDic:dic]];
                    }
                        break;
                    case 2:{
                        [modelsM addObject:[JASValue2CellModel modelWithDic:dic]];
                    }
                        break;
                    case 3:{
                        [modelsM addObject:[JASSubtitleCellModel modelWithDic:dic]];
                    }
                        break;
                }
                
            }
            return [modelsM copy];
        };
        _datas = self.modelBlock([self demoListWithIdentifier:self.identifier]);
    }
    
    return _datas;
}

- (NSArray *)demoListWithIdentifier:(NSInteger)identifier {
    NSArray *dicList = nil;
    switch (identifier) {
        case 0:{
           dicList = @[
                       @{
                           @"id":@1,
                           @"title":@"测试",
                           @"icon":@"demo_tableview_02"
                           },
                       @{
                           @"id":@2,
                           @"title":@"c测试,2342...c测试,2342...c测试,2342...c测试,2342...c测试,2342...",
                           @"icon":@"demo_tableview_01"
                           },
                       @{
                           @"id":@3,
                           @"title":@"cfads,测试...",
                           @"icon":@"demo_tableview_02"
                           },
                       @{
                           @"id":@4,
                           @"title":@"c测试,测试...",
                           @"icon":@"demo_tableview_01"
                           }
                       ];
            }
            break;
        case 1:
        case 2:{
            dicList = @[
                        @{
                            @"id":@1,
                            @"title":@"c测试,234...",
                            @"blue_title":@"忘掉了挨个打算暗示"
                            },
                        @{
                            @"id":@1,
                            @"title":@"c测试,234...",
                            @"blue_title":@"忘掉了挨个打算暗示"
                            },
                        @{
                            @"id":@1,
                            @"title":@"c测试,234...",
                            @"blue_title":@"忘掉了挨个打算暗示"
                            },
                        @{
                            @"id":@1,
                            @"title":@"c测试,234...",
                            @"blue_title":@"忘掉了挨个打算暗示"
                            }
                        ];
            }
            break;
        case 3:{
            dicList = @[
                        @{
                            @"id":@1,
                            @"title":@"c测试,234...",
                            @"blue_title":@"忘掉了挨个打算暗示",
                            @"image":@"fadsfadsfadsfadsfadsfdsa"
                         },
                        @{
                            @"id":@1,
                            @"title":@"c测试,234...",
                            @"blue_title":@"忘掉了挨个打算暗示",
                            @"image":@"demo_tableview_01"
                        },
                        @{
                            @"id":@1,
                            @"title":@"c测试,234...",
                            @"blue_title":@"忘掉了挨个打算暗示",
                            @"image":@"demo_tableview_02"
                        },
                        @{
                            @"id":@1,
                            @"title":@"c测试,234...",
                            @"blue_title":@"忘掉了挨个打算暗示",
                            @"image":@"fadsfadsfadsfadsfadsfdsa"
                        },
                      ];
        }
    }
    return dicList;
}


@end
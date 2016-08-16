//
//  FlexibleHeightCollectionViewController.m
//  DRArtisan
//
//  Created by Jason on 7/31/16.
//  Copyright © 2016 DR. All rights reserved.
//

#import "FlexibleHeightCollectionViewController.h"
#import "NewsModel.h"
#import "NewsCollectionCell.h"

@interface FlexibleHeightCollectionViewController ()

@property (nonatomic,weak) BaseCollectionView *collect_v;

@property (nonatomic,strong) Capable *capable;

@end

@implementation FlexibleHeightCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    WaterFlowVerLayout *flowLayout = [WaterFlowVerLayout LayoutWithColumnsCount:2 lineSpace:5 interitemSpace:5 sectionInset:UIEdgeInsetsMake(0, 5, 5, 5)];

    BaseCollectionView *collect_v = [BaseCollectionView collectionViewWithFrame:Screen_bounds layout:flowLayout classType:XCCollectionViewClassTypeFlexVer clickItemBlock:^(UICollectionView *collectionView, NSIndexPath *indexPath) {
        
         XcLog(@"%@",@"点击了Cell");
        
    }];
    
    flowLayout.delegate = collect_v;
    
    collect_v.backgroundColor = HexRGB(0xffffff);
    [collect_v registerClass:[NewsCollectionCell class]];
    [self.view addSubview:_collect_v = collect_v];
    
    // Add Move ability
    Capable *capable = [Capable capableWithCollectionView:collect_v];
    [capable mobility];
    self.capable = capable;
    // [[Capable capableWithCollectionView:collect_v] mobility];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSDictionary *dic = @{@"pn":@"0",@"rn":@"60"};
    
    NSString *tag1 = @"美女";    // theme
    NSString *tag2 = @"小清新";  // category
    
    NSString *urlString = [NSString stringWithFormat:@"http://image.baidu.com/wisebrowse/data?tag1=%@&tag2=%@",tag1,tag2];
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    XCHTTPSessionManager *manager = [XCHTTPSessionManager managerWithBaseUrl:nil];
    manager.responseSerializer.acceptableContentTypes =[NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    
    [manager GET:urlString parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (responseObject) {
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                if ([[responseObject objectForKey:@"imgs"] isKindOfClass:[NSArray class]]) {
                    NSArray *imgs = [responseObject objectForKey:@"imgs"];
                    NSMutableArray *imgsM = [NSMutableArray arrayWithCapacity:[imgs count]];
                    for (NSDictionary *img in imgs) {
                        
                        NewsModel *model = [NewsModel modelWithDic:img];
                        [imgsM addObject:model];
                    }
                    
                     _collect_v.dataList = [imgsM copy];
                     XcLog(@"%@",_collect_v.dataList);
                     [_collect_v reloadData];
                }
            }
        
            // XcLog(@"%@",responseObject);
        }

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        XcLog(@"%@",error);
    }];
     
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
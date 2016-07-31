//
//  BaseTableView.m
//  DRArtisan
//
//  Created by Jason on 7/11/16.
//  Copyright © 2016 DR. All rights reserved.
//

#import "BaseTableView.h"

#define kSlack      kZero
#define kStrict     kOne

@interface BaseTableView ()

@property (nonatomic,assign,getter=isSingleDimension) BOOL singleDimension;

@end

@implementation BaseTableView

+ (instancetype)tableViewWithFrame:(CGRect)frame
                             style:(UITableViewStyle)style
                        dataList:(NSArray *)dataList{
    
    NSAssert([dataList isKindOfClass:[NSArray class]], @"dataSource param must be an array class");
    
    BaseTableView *obj = [[self alloc] initWithFrame:frame style:style];
    
    // default datasource is single dimension array
    obj.singleDimension = true;
    if (kTypecheck == kStrict) {
        for (id subList in dataList) {
            if ([subList isKindOfClass:[NSArray class]]) {
                obj.singleDimension = false;
                break;
            }
        }
    }else if(kTypecheck == kSlack) {
        if ([dataList.firstObject isKindOfClass:[NSArray class]]) {
            obj.singleDimension = false;
        }
    }
    
    obj.customSetter = true;
    obj.dataList = dataList;
    
    return obj;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.isSingleDimension ?
        [super numberOfSectionsInTableView:tableView] : [self.dataList count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.isSingleDimension ?
        [super tableView:tableView numberOfRowsInSection:section] : [self.dataList[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:self.identifier];
    // static int i = 0;
    if (cell == nil) {
        cell = [[[[self cellClass] class] alloc] initWithStyle:self.cellStyle
                                               reuseIdentifier:self.identifier];
        JasLog(@"cell reuse => %zd",self.reuseCount++);
    }
    
    if(self.singleDimension) {
        cell.model = self.dataList[indexPath.row];
    }else {
        cell.model = self.dataList[indexPath.section][indexPath.row];
    }
    return cell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // If you want to do anything like before,your viewcontroller should become cdelegate
    if(self.cdelegate){
        if([self.cdelegate respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)]){
            return [self.cdelegate tableView:tableView didSelectRowAtIndexPath:indexPath];
        }
    }
    
    // If you just want to write click cell in viewcontroller,your viewcontroller should become sdelegate
    if (self.sdelegate) {
        if ([self.sdelegate respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)]) {
            return [self.sdelegate tableView:tableView didSelectRowAtIndexPath:indexPath];
        }
    }
    
    // If you extends BaseTableView and you can implement tableView:didSelectRowAtIndexPath: action event
    JasLog(@"You can implement tableView:didSelectRowAtIndexPath: in class which is extends BaseTableView.");
    
}

- (void)setDataList:(NSArray *)dataList {
    _dataList = dataList;
    if (self.customSetter == false) { return; }
    
    // Need Custom implement setter dataList
    NSMutableArray *dataListM = [NSMutableArray arrayWithCapacity:[dataList count]];
    if (self.isSingleDimension) {
        NSMutableArray *dataListM = [NSMutableArray arrayWithCapacity:[dataList count]];
        for (id data in dataList) {
            if(kFoundationProperty(data)){
                [dataListM addObject:[self packFoundationClass:data]];
            }else {
                [dataListM addObject:data];
            }
        }
    }else {
        for (NSArray *subdataList in dataList) {
            NSMutableArray *subdataListM = [NSMutableArray arrayWithCapacity:[subdataList count]];
            for (id subdata in subdataList) {
                if(kFoundationProperty(subdata)){
                    [subdataListM addObject:[self packFoundationClass:subdata]];
                }else {
                    [subdataListM addObject:subdata];
                }
            }
            [dataListM addObject:[subdataListM copy]];
        }
    }
    _dataList = [dataListM copy];
}

@end

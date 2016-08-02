//
//  FlexibleHeightTableView.m
//  DRArtisan
//
//  Created by Jason on 7/11/16.
//  Copyright © 2016 DR. All rights reserved.
//

#import "FlexibleHeightTableView.h"

#define kDefaultCellHeight 60

@implementation FlexibleHeightTableView

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    // if you want to return height in viewcontroller,please set self.cdelegate = viewcontroller...
    if(self.cdelegate){
        if([self.cdelegate respondsToSelector:@selector(tableView:heightForRowAtIndexPath:)]){
            return [self.cdelegate tableView:tableView heightForRowAtIndexPath:indexPath];
        }
    }
    // NSAssert([self.dataList[indexPath.row] cell_h], @"You should set cell_h at setModel: on table view cell object");
    
    if (self.isSingleDimension) {
        if ([self.dataList[indexPath.row] cell_h] == kZero) {
            return self.rowHeight == kZero ? kDefaultCellHeight : self.rowHeight;
        }
        return [self.dataList[indexPath.row] cell_h];
    }else {
        if ([self.dataList[indexPath.section][indexPath.row] cell_h] == kZero) {
            return self.rowHeight == kZero ? kDefaultCellHeight : self.rowHeight;
        }
        return [self.dataList[indexPath.section][indexPath.row] cell_h];
    }
}
@end
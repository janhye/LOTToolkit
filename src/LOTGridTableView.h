//
//  LOTGridTableView.h
//  Zqyx
//
//  Created by yjh on 11-7-14.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LOTGridTableView;

@protocol LOTGridTableViewDataSource <NSObject>

@required
- (NSInteger)numberOfRowsInGridTableView:(LOTGridTableView *)gridTableView;

@optional
- (void)gridTableView:(LOTGridTableView *)gridTableView configureCellView:(UIView *)cellView row:(NSInteger)row column:(NSInteger)col;
- (NSString *)gridTableView:(LOTGridTableView *)gridTableView titleForHeaderInColumn:(NSInteger)col;

@end

@protocol LOTGridTableViewDelegate <NSObject>

@optional
- (UIView *)gridTableView:(LOTGridTableView *)gridTableView cellViewForRow:(NSInteger)row column:(NSInteger)col;
- (UIView *)gridTableView:(LOTGridTableView *)gridTableView headerViewForColumn:(NSInteger)col;
- (CGFloat)gridTableView:(LOTGridTableView *)gridTableView heightForRow:(NSInteger)row;
- (CGFloat)heightForHeaderInGridTableView:(LOTGridTableView *)gridTableView;
- (CGFloat)gridTableView:(LOTGridTableView *)gridTableView widthForColumn:(NSInteger)col;

@end

@interface LOTGridTableView : UIView <UITableViewDataSource, UITableViewDelegate> {
    UIView *_headerPanel;
    UITableView *_tableView;
    NSInteger _numberOfColumns;
    NSArray *_columnViews;
    NSArray *_columnWidthArray;
    id <LOTGridTableViewDataSource> _dataSource;
    id <LOTGridTableViewDelegate>   _delegate;
}

@property (nonatomic, assign) id <LOTGridTableViewDataSource> dataSource;
@property (nonatomic, assign) id <LOTGridTableViewDelegate>   delegate;
@property (nonatomic, readonly) NSInteger numberOfColumns;
@property (nonatomic, readonly) UIView *headerPanel;

- (id)initWithFrame:(CGRect)frame numberOfColumns:(NSInteger)ncol;

@end

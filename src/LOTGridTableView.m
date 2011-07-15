//
//  LOTGridTableView.m
//  Zqyx
//
//  Created by yjh on 11-7-14.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "LOTGridTableView.h"
#import <QuartzCore/QuartzCore.h>

#define kCellView 1
#define kHeaderView 1


@interface LOTGridTableViewRowCell : UITableViewCell {
@private
    NSArray *_columnWidthArray;
    NSArray *_columnViews;
    BOOL _isUsedCustomView;
}

@property (nonatomic, retain) NSArray *columnViews;
@property (nonatomic, retain) NSArray *columnWidthArray;
@property (nonatomic, assign) BOOL isUsedCustomView;

- (id)initWithColumns:(NSArray *)cols reuseIdentifier:(NSString *)reuseIdentifier;

@end

@implementation LOTGridTableViewRowCell
@synthesize columnViews = _columnViews;
@synthesize columnWidthArray = _columnWidthArray;
@synthesize isUsedCustomView = _isUsedCustomView;

- (void)dealloc
{
    [_columnWidthArray release];
    [_columnViews release];
    [super dealloc];
}

- (id)initWithColumns:(NSArray *)cols reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        self.isUsedCustomView = NO;
        self.columnWidthArray = cols;
        NSInteger numberOfColumns = [self.columnWidthArray count];
        NSMutableArray *array = [[[NSMutableArray alloc] initWithCapacity:numberOfColumns] autorelease];
        for (int i = 0; i < numberOfColumns; i++) {
            UIView *cellContentView = [[UIView alloc] initWithFrame:CGRectZero];
            [self addSubview:cellContentView];
            [array addObject:cellContentView];
            [cellContentView release];
        }
        self.columnViews = array;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat cellHeight = self.bounds.size.height;
    
    CGFloat originX = 0;
    NSInteger numberOfColumns = [self.columnWidthArray count];
    for (int i = 0; i < numberOfColumns; i++) {
        CGFloat columnWidth = [[self.columnWidthArray objectAtIndex:i] floatValue];
        UIView *cellContentView = [self.columnViews objectAtIndex:i];
        cellContentView.frame = CGRectMake(originX, 0, columnWidth, cellHeight);
        originX += columnWidth;
        
        if (!self.isUsedCustomView) {
            UILabel *cellDefaultLabel = (UILabel *)[cellContentView viewWithTag:kCellView];
            cellDefaultLabel.frame = CGRectMake(10.0f, 5.0f, columnWidth - 20.0f, cellHeight - 10.0f);
        }
    }
}

@end


@interface LOTGridTableView ()
@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) NSArray *columnViews;
@property (nonatomic, retain) NSArray *columnWidthArray;
@end


@implementation LOTGridTableView
@synthesize dataSource = _dataSource;
@synthesize delegate = _delegate;
@synthesize numberOfColumns = _numberOfColumns;
@synthesize columnWidthArray = _columnWidthArray;
@synthesize columnViews = _columnViews;
@synthesize headerPanel = _headerPanel;
@synthesize tableView = _tableView;

- (void)dealloc
{
    [_columnWidthArray release];
    [_columnViews release];
    [_headerPanel release];
    [_tableView release];
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    return [self initWithFrame:frame numberOfColumns:1];
}

- (id)initWithFrame:(CGRect)frame numberOfColumns:(NSInteger)ncol
{
    self = [super initWithFrame:frame];
    if (self) {
        _numberOfColumns = ncol;
        
        _headerPanel = [[UIView alloc] initWithFrame:CGRectZero];
        [self addSubview:self.headerPanel];
        
        NSMutableArray *array = [[[NSMutableArray alloc] initWithCapacity:_numberOfColumns] autorelease];
        for (int i = 0; i < _numberOfColumns; i++) {
            UIView *headerContentView = [[UIView alloc] initWithFrame:CGRectZero];
            [self.headerPanel addSubview:headerContentView];
            [array addObject:headerContentView];
            [headerContentView release];
        }
        self.columnViews = array;
        
        self.tableView = [[[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain] autorelease];
        self.tableView.allowsSelection = NO;
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        [self addSubview:self.tableView];
        
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat headerHeight;
    if ([self.delegate respondsToSelector:@selector(heightForHeaderInGridTableView:)]) {
        headerHeight = [self.delegate heightForHeaderInGridTableView:self];
    } else {
        headerHeight = 45.0f;
    }
    
    self.headerPanel.frame = CGRectMake(0, 0, self.bounds.size.width, headerHeight);
    
    NSMutableArray *widthArray = [NSMutableArray arrayWithCapacity:self.numberOfColumns];
    CGFloat originX = 0;
    for (int i = 0; i < self.numberOfColumns; i++) {
        CGFloat columnWidth;
        if ([self.delegate respondsToSelector:@selector(gridTableView:widthForColumn:)]) {
            columnWidth = [self.delegate gridTableView:self widthForColumn:i];
        } else {
            columnWidth = self.frame.size.width / self.numberOfColumns;
        }
        
        [widthArray addObject:[NSNumber numberWithFloat:columnWidth]];
        
        UIView *headerContentView = [self.columnViews objectAtIndex:i];
        headerContentView.frame = CGRectMake(originX, 0, columnWidth, headerHeight);
        originX += columnWidth;
        
        UIView *headerView = [headerContentView viewWithTag:kHeaderView];
        if (headerView == nil) {
            if ([self.delegate respondsToSelector:@selector(gridTableView:headerViewForColumn:)]) {
                headerView = [self.delegate gridTableView:self headerViewForColumn:i];
            } else if ([self.dataSource respondsToSelector:@selector(gridTableView:titleForHeaderInColumn:)]) {
                NSString *headerTitle = [self.dataSource gridTableView:self titleForHeaderInColumn:i];
                UILabel *headerLabel = [[[UILabel alloc] initWithFrame:CGRectMake(10.0f, 5.0f, headerContentView.bounds.size.width - 20.0f, headerContentView.bounds.size.height - 10.0f)] autorelease];
                headerLabel.text = headerTitle;
                headerLabel.backgroundColor = [UIColor clearColor];
                headerLabel.textColor = [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:1];
                headerLabel.shadowOffset = CGSizeMake(0, 1);
                headerLabel.shadowColor = [UIColor colorWithWhite:0 alpha:0.25];
                headerView = headerLabel;
            } else {
                headerView = nil;
            }
            
            if (headerView != nil) {
                headerView.tag = kHeaderView;
                [headerContentView addSubview:headerView];
            }
        }
    }
    self.columnWidthArray = widthArray;
    
    self.tableView.frame = CGRectMake(0, headerHeight, self.bounds.size.width, self.bounds.size.height - headerHeight);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataSource numberOfRowsInGridTableView:self];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"__LOTGridTableViewCell";
    
    LOTGridTableViewRowCell *cell = (LOTGridTableViewRowCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[LOTGridTableViewRowCell alloc] initWithColumns:self.columnWidthArray reuseIdentifier:CellIdentifier] autorelease];
        for (int i = 0; i < self.numberOfColumns; i++) {
            UIView *cellView;
            if ([self.delegate respondsToSelector:@selector(gridTableView:cellViewForRow:column:)]) {
                cell.isUsedCustomView = YES;
                cellView = [self.delegate gridTableView:self cellViewForRow:indexPath.row column:i];
            } else {
                cell.isUsedCustomView = NO;
                UILabel *cellDefaultLabel = [[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
                cellDefaultLabel.backgroundColor = [UIColor clearColor];
                cellDefaultLabel.textColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1];
                cellDefaultLabel.shadowOffset = CGSizeMake(0, 1);
                cellDefaultLabel.shadowColor = [UIColor colorWithWhite:0 alpha:0.25];
                cellView = cellDefaultLabel;
            }
            cellView.tag = kCellView;
            UIView *cellContentView = [cell.columnViews objectAtIndex:i];
            [cellContentView addSubview:cellView];
        }
    }
    
    for (int i = 0; i < self.numberOfColumns; i++) {
        UIView *cellContentView = [cell.columnViews objectAtIndex:i];
        UIView *cellView = [cellContentView viewWithTag:kCellView];
        if ([self.dataSource respondsToSelector:@selector(gridTableView:configureCellView:row:column:)]) {
            [self.dataSource gridTableView:self configureCellView:cellView row:indexPath.row column:i];
        }
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height;
    if ([_delegate respondsToSelector:@selector(gridTableView:heightForRow:)]) {
        height = [_delegate gridTableView:self heightForRow:indexPath.row];
    } else {
        height = 45.0f;
    }
    return height;
}

@end

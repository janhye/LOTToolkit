//
//  LOTCheckBox.h
//  Zqyx
//
//  Created by yjh on 11-6-1.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LOTCheckBox;
@class LOTTextField;

@protocol LOTCheckBoxDelegate <NSObject>
@optional
- (void)checkBoxDidClicked:(LOTCheckBox *)checkBox;
@end

@interface LOTCheckBox : UIButton {
    id<LOTCheckBoxDelegate> delegate;
}

@property (nonatomic, retain) id<LOTCheckBoxDelegate> delegate;
@property (nonatomic, retain) NSString *columnName;
@property (nonatomic, retain) IBOutlet LOTTextField *contentTextField;

@end

//
//  LOTCheckBox.m
//  Zqyx
//
//  Created by yjh on 11-6-1.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "LOTCheckBox.h"
#import "LOTTextField.h"

@interface LOTCheckBox (Private)

- (void)setupButton;
- (void)checkAction;

@end

@implementation LOTCheckBox

@synthesize delegate;
@synthesize columnName;
@synthesize contentTextField;

- (void)dealloc
{
    [delegate release];
    [columnName release];
    [super dealloc];
}

- (id)init
{
    self = [super init];
    if (self) {
        [self setupButton];
    }
    return  self;
}

- (void)setupButton
{
    [self setBackgroundColor:[UIColor clearColor]];
    [self setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [self setImage:[UIImage imageNamed:@"checkbox_unchecked.png"] forState:UIControlStateNormal];
    [self setImage:[UIImage imageNamed:@"checkbox_checked.png"] forState:UIControlStateSelected];
    [self setTitleColor:[self titleColorForState:UIControlStateNormal] forState:UIControlStateHighlighted];
    [self addTarget:self action:@selector(checkAction) forControlEvents:UIControlEventTouchUpInside];
}

- (void)awakeFromNib
{
    [self setupButton];
    if(self.contentTextField){
        [self.contentTextField setEnabled:NO];
    }
}

- (void)checkAction
{
    self.selected = !self.selected;
    
    if ([delegate respondsToSelector:@selector(checkBoxDidClicked:)]) {
        [delegate checkBoxDidClicked:self];
    }
    if(self.contentTextField){
        [self.contentTextField setEnabled:self.selected];
        if(self.selected == NO){
            self.contentTextField.text = @"";
        }
    }
}

- (void)setHighlighted:(BOOL)highlighted
{    
    // 用一个空方法复写setHighlighted，取消highlighted的设置。
}

@end

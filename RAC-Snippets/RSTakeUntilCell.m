//
//  RSTakeUntilCell.m
//  RAC-Snippets
//
//  Created by Limboy on 2/11/14.
//  Copyright (c) 2014 ReactiveCocoa. All rights reserved.
//

#import "RSTakeUntilCell.h"

@interface RSTakeUntilCell ()
@property (nonatomic, readwrite) UIButton *button;
@end

@implementation RSTakeUntilCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self.contentView addSubview:self.button];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - Public Methods

- (void)configureCellWithIndexPath:(NSIndexPath *)indexPath
{
    // set title will 'blink' in iOS 7, it's a system 'feature'
    [self.button setTitle:[NSString stringWithFormat:@"Cell %d", indexPath.row] forState:UIControlStateNormal];
    [[[self.button
       rac_signalForControlEvents:UIControlEventTouchUpInside]
       takeUntil:self.rac_prepareForReuseSignal] // when the cell is ready for reuse, this signal will be disposed.
       subscribeNext:^(id x) {
           NSString *message = [NSString stringWithFormat:@"Cell %d Tapped", indexPath.row];
           UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
           [alertView show];
       }];
}

#pragma mark - Accessors

- (UIButton *)button
{
    if (!_button) {
        _button = [UIButton buttonWithType:UIButtonTypeSystem];
        _button.frame = CGRectMake(0, 0, 300, 44);
        [_button setTitle:@"Cell" forState:UIControlStateNormal];
    }
    return _button;
}

@end

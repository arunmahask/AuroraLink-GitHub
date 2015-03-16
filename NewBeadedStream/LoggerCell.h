//
//  LoggerCell.h
//  NewBeadedStream
//
//  Created by fsp on 6/17/13.
//  Copyright (c) 2013 fsp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoggerCell : UITableViewCell<UIGestureRecognizerDelegate>
{
//ImageView object Declaration
    UIImageView *cellBackgroundView,*viewDataView,*downloadDataView;

//UILabel object Creation
    UILabel *loggerName,*dateTime,*description;
    
//GestureRecognizer declaration
    UITapGestureRecognizer *tap1,*tap2;
    
    UIButton *viewData, *downloadData;
}

//****** Control declartion for Cell creation *******//
@property (strong, nonatomic)UIImageView *cellBackgroundView;
@property (strong, nonatomic)UIImageView *viewDataView;
@property (strong, nonatomic)UIImageView *downloadDataView;

@property (strong, nonatomic) UILabel *loggerName;
@property (strong, nonatomic) UILabel *dateTime;
@property (strong, nonatomic) UILabel *description;

@property ( nonatomic) UIButton *viewData;
@property ( nonatomic) UIButton *downloadData;

@property (strong, nonatomic) UITapGestureRecognizer *tap1;
@property (strong, nonatomic) UITapGestureRecognizer *tap2;

@end

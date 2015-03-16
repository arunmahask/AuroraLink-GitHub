//
//  HistoryCell.h
//  NewBeadedStream
//
//  Created by fsp on 6/18/13.
//  Copyright (c) 2013 fsp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HistoryCell : UITableViewCell
{
//Declaration the Imageview
    UIImageView *calanderView, *clockView;
    
//Label Intialization
    UILabel *loggerName, *description, *date, *time;
}

//******** Image view delcaration *******//
@property (strong, nonatomic)UIImageView *calanderView;
@property (strong, nonatomic)UIImageView *clockView;

//******** Controls for cell creation *******//
@property (strong, nonatomic)UILabel *loggerName;
@property (strong, nonatomic)UILabel *description;
@property (strong, nonatomic)UILabel *date;
@property (strong, nonatomic)UILabel *time;

@end

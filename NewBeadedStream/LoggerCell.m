//
//  LoggerCell.m
//  NewBeadedStream
//
//  Created by fsp on 6/17/13.
//  Copyright (c) 2013 fsp. All rights reserved.
//

#import "LoggerCell.h"

//****** Class to create customized cell for the Logger table in logger in range page **m****//
@implementation LoggerCell
@synthesize cellBackgroundView,viewDataView,downloadDataView,tap1,tap2,loggerName,dateTime,viewData,downloadData,description;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        cellBackgroundView=[[UIImageView alloc]init];
        
        loggerName=[[UILabel alloc]init];
        dateTime=[[UILabel alloc]init];
        description=[[UILabel alloc]init];
                    
        loggerName.backgroundColor=[UIColor clearColor];
        loggerName.textColor=[UIColor yellowColor];
       
        dateTime.backgroundColor=[UIColor clearColor];
        dateTime.textColor=[UIColor whiteColor];
        
        description.backgroundColor=[UIColor clearColor];
        description.textColor=[UIColor whiteColor];
        

        if((UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone))
        {
            loggerName.frame=CGRectMake(18.0, 11.0, 200.0, 30.0);
            description.frame=CGRectMake(18.0, 28, 100, 30);
            dateTime.frame=CGRectMake(110.0, 28.0, 200.0, 30.0);
            
            [loggerName setFont:[UIFont fontWithName:@"MyriadPro-Semibold" size:17.0]];
            [dateTime setFont:[UIFont fontWithName:@"MyriadPro-Semibold" size:13.0]];
            [description setFont:[UIFont fontWithName:@"MyriadPro-Semibold" size:13.0]];
            
        }
        else
        {
            loggerName.frame=CGRectMake(33.0, 35.0, 300.0, 30.0);
            description.frame=CGRectMake(33.0, 70, 200, 25);
            dateTime.frame=CGRectMake(210.0, 70.0, 300.0, 25.0);
            
            [loggerName setFont:[UIFont fontWithName:@"MyriadPro-Semibold" size:27.0]];
            [description setFont:[UIFont fontWithName:@"MyriadPro-Semibold" size:25.0]];
            [dateTime setFont:[UIFont fontWithName:@"MyriadPro-Semibold" size:25.0]];
        }
        [self.contentView addSubview:loggerName];
        [self.contentView addSubview:dateTime];
        [self.contentView addSubview:description];
        
        NSLog(@"frame :%@", NSStringFromCGRect(self.frame));
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated{
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

-(void)drawRect:(CGRect)rect
{
    if((UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone))
    {
        [[UIImage imageNamed:@"LoggerItemBGU.png"] drawInRect:rect];
    }
    else
    {
        [[UIImage imageNamed:@"LoggerItemBGU~ipad.png"] drawInRect:rect];
    }
}

@end

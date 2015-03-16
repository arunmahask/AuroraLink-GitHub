//
//  HistoryCell.m
//  NewBeadedStream
//
//  Created by fsp on 6/18/13.
//  Copyright (c) 2013 fsp. All rights reserved.
//

#import "HistoryCell.h"

//****** Class to create the customized cell for the history table ******//

@implementation HistoryCell
@synthesize clockView,calanderView,loggerName,description,date,time;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self){
        
        //******** defination for the cell contorls ********//
        
        
        loggerName=[[UILabel alloc]init];
        description=[[UILabel alloc]init];
        date=[[UILabel alloc]init];
        time=[[UILabel alloc]init];
        
        clockView=[[UIImageView alloc]init];
        calanderView=[[UIImageView alloc]init];
        
        loggerName.backgroundColor=[UIColor clearColor];
        loggerName.textColor=[UIColor yellowColor];
        
        description.backgroundColor=[UIColor clearColor];
        description.textColor=[UIColor whiteColor];

        date.backgroundColor=[UIColor clearColor];
        date.textColor=[UIColor whiteColor];
    
        time.backgroundColor=[UIColor clearColor];
        time.textColor=[UIColor whiteColor];
        
        if((UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone))
        {
            loggerName.frame=CGRectMake(10.0, 13.0, 150.0, 30.0);
            description.frame=CGRectMake(10.0, 40.0, 300.0, 30.0);
            date.frame=CGRectMake(183.0, 18.0, 80.0, 20.0);
            time.frame=CGRectMake(278.0, 17.0, 40.0, 20.0);
        
            calanderView.frame=CGRectMake(168.0, 20.0, 10.0, 10.0);
            clockView.frame=CGRectMake(265.0, 20.0, 10.0, 10.0);
            
            [loggerName setFont:[UIFont fontWithName:@"MyriadPro-Semibold" size:17.0]];
            [description setFont:[UIFont fontWithName:@"MyriadPro-Semibold" size:16.0]];
            [date setFont:[UIFont fontWithName:@"MyriadPro-Semibold" size:16.0]];
            [time setFont:[UIFont fontWithName:@"MyriadPro-Semibold" size:15.0]];
        }
        else
        {
            loggerName.frame=CGRectMake(10.0, 23.0, 300.0, 30.0);
            description.frame=CGRectMake(10.0, 60.0, 800.0, 30.0);
            date.frame=CGRectMake(500.0, 23.0, 150.0, 22.0);
            time.frame=CGRectMake(670.0, 23.0, 80.0, 22.0);
            
            calanderView.frame=CGRectMake(475.0, 23.0, 19.0, 19.0);
            clockView.frame=CGRectMake(645.0, 23.0, 19.0, 19.0);
            
            [loggerName setFont:[UIFont fontWithName:@"MyriadPro-Semibold" size:27.0]];
            [description setFont:[UIFont fontWithName:@"MyriadPro-Semibold" size:25.0]];
            [date setFont:[UIFont fontWithName:@"MyriadPro-Semibold" size:25.0]];
            [time setFont:[UIFont fontWithName:@"MyriadPro-Semibold" size:25.0]];
        }
        
        [self.contentView addSubview:loggerName];
        [self.contentView addSubview:description];
        [self.contentView addSubview:date];
        [self.contentView addSubview:time];
        [self.contentView addSubview:calanderView];
        [self.contentView addSubview:clockView];
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    
// Configure the view for the selected state    
    [super setSelected:selected animated:animated];

}

//******* set the back ground for cell ********//

-(void)drawRect:(CGRect)rect
{
    if((UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone))
    {
        [[UIImage imageNamed:@"HistoryItemBG.png"] drawInRect:rect];
    }
    else
    {
        [[UIImage imageNamed:@"HistoryItemBG~ipad.png"] drawInRect:rect];
    }
}

@end

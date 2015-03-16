//
//  DataCell.m
//  NewBeadedStream
//
//  Created by fsp on 6/22/13.
//  Copyright (c) 2013 fsp. All rights reserved.
//

#import "DataCell.h"

@implementation DataCell

//**** class used to create a table custom cell for the page View Data in the landscape mode to show the sensor value *****//

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UILabel *data = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 30)];
        data.tag = 1111;
        data.numberOfLines = 1;
        data.backgroundColor = [UIColor clearColor];
        data.textColor=[UIColor whiteColor];
        [data setFont:[UIFont fontWithName:@"MyriadPro-Semibold" size:15.0]];
        [self.contentView addSubview:data];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated{
    [super setSelected:selected animated:animated];

}

-(void)drawRect:(CGRect)rect
{
    if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
    {
        [[UIImage imageNamed:@"LoggerItemBG.png"] drawInRect:rect];
    }
    else
    {
        [[UIImage imageNamed:@"LoggerItemBG~ipad.png"] drawInRect:rect];
    }
    
}

@end

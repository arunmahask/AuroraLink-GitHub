//
//  HistroyView.m
//  NewBeadedStream
//
//  Created by fsp on 6/18/13.
//  Copyright (c) 2013 fsp. All rights reserved.
//

#import "HistroyView.h"

@interface HistroyView ()

@end
@implementation HistroyView

@synthesize histroyoflogger=_histroyoflogger;
@synthesize settings=_settings;
@synthesize loggerinrange=_loggerinrange;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.histroyoflogger reloadData];
    
    //******* Background Image Settings ******//
    
    dbc=[[DataBaseControl alloc] init];
    [dbc initDatabase];
    
    frame1=[[UIScreen mainScreen]bounds];
    NSLog(@" Content of the History - %@",historyInfo);
    
    //***** Navigation Settings ********//
    
    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.hidesBackButton=YES;

    _settings = [UIButton buttonWithType:UIButtonTypeCustom];
    
    //******* Table intializaiton for display Logger Histroy *****//
    
    _histroyoflogger=[[UITableView alloc]initWithFrame:CGRectMake(0.0,0.0,frame1.size.width,frame1.size.height - 128) style:UITableViewStylePlain];
    _histroyoflogger.delegate=self;
    _histroyoflogger.dataSource=self;
    _histroyoflogger.separatorStyle=UITableViewCellSeparatorStyleNone;
    _histroyoflogger.backgroundColor=[UIColor clearColor];
    _histroyoflogger.showsVerticalScrollIndicator=NO;
   
    
    //******* Tabbar to switch to logger in range Screen *******//
    
    _loggerinrange=[UIButton buttonWithType:UIButtonTypeCustom];
    
    [_histroyoflogger reloadData];
    
    historySelect = [[UIImageView alloc] init];
    historySelect.image  =[UIImage imageNamed:@"historySelect.png"] ;
    
}
-(void)viewWillAppear:(BOOL)animated
{
        historyInfo=[[NSMutableArray alloc]init];
    
        historyInfo = [dbc getHistoryInfo];
    
        [self.histroyoflogger reloadData];
    
        if((UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone))
        {
                buttonImage=[UIImage imageNamed:@"info.png"];
                [_settings setBackgroundImage:buttonImage forState:UIControlStateNormal];
                _settings.frame = CGRectMake(0, 0, (buttonImage.size.width / buttonImage.size.height) * 30, 30);
                [_settings addTarget:self action:@selector(infoView:) forControlEvents:UIControlEventTouchUpInside];
                barButton = [[UIBarButtonItem alloc] initWithCustomView:_settings];

                backgroundImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Background.png"]];
    
                if([[UIScreen mainScreen] bounds].size.height == 568 )
                {
                        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
                        {
                                historySelect.frame=CGRectMake(0, 504, 320, 64);
                                _histroyoflogger.frame=CGRectMake(0,64.0,frame1.size.width,frame1.size.height - 128);
                                _loggerinrange.frame=CGRectMake(0,frame1.size.height-63,frame1.size.width - 160,63.0);
                            
                                if ([self.navigationController.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)])
                                {
                                        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"historynav7.png"] forBarMetrics:UIBarMetricsDefault];
                                        self.navigationController.navigationBar.frame=CGRectMake(0.0, 0.0, 320.0, 65.0);
                                }
                        }
                        else
                        {
                                historySelect.frame=CGRectMake(0, 440, 320, 64);
                                _loggerinrange.frame=CGRectMake(0.0,frame1.size.height - 120,frame1.size.width - 160,63.0);
                            
                                if ([self.navigationController.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)])
                                {
                                        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"Historytitle.png"] forBarMetrics:UIBarMetricsDefault];
                                }
            
                        }
                }
            
                else if([[UIScreen mainScreen] bounds].size.height == 480)
                {
                        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
                        {
                                historySelect .frame= CGRectMake(0,frame1.size.height-64, frame1.size.width,64);
                                _histroyoflogger.frame=CGRectMake(0,65.0,frame1.size.width,frame1.size.height - 128);
                                _loggerinrange.frame=CGRectMake(0,frame1.size.height - 64,frame1.size.width - 160,63.0);
            
                                _histroyoflogger.backgroundColor=[UIColor clearColor];
            
                                if ([self.navigationController.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)])
                                {
                                        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"historynav7.png"] forBarMetrics:UIBarMetricsDefault];
                                }
                            }
        
                        else
                        {
                                historySelect.frame= CGRectMake(0, frame1.size.height-64, frame1.size.width,64);
                                _histroyoflogger.frame=CGRectMake(0,0,frame1.size.width,frame1.size.height - 64);
                                _loggerinrange.frame=CGRectMake(0,frame1.size.height - 64,frame1.size.width - 160,63.0);
                            
                                _histroyoflogger.backgroundColor=[UIColor clearColor];
            
                                if ([self.navigationController.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)])
                                {
                                        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"Historytitle.png"] forBarMetrics:UIBarMetricsDefault];
                                }
                        }
                }
        }
        else
        {
                if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
                {
                        buttonImage=[UIImage imageNamed:@"info~ipad.png"];
                        [_settings setBackgroundImage:buttonImage forState:UIControlStateNormal];
                        _settings.frame = CGRectMake(0,0,38, 38);
                        [_settings addTarget:self action:@selector(infoView:) forControlEvents:UIControlEventTouchUpInside];
                        barButton = [[UIBarButtonItem alloc] initWithCustomView:_settings];

                        backgroundImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background~ipad.png"]];
            
                        [historySelect setImage:[UIImage imageNamed:@"historySelect~ipad.png"]];
            
                        historySelect.frame = CGRectMake(0, frame1.size.height-107,frame1.size.width, 107);
                        _loggerinrange.frame=CGRectMake(0.0,frame1.size.height - 102,frame1.size.width - 384,102.0);
                        _histroyoflogger.frame   =CGRectMake(10.0,81.0,frame1.size.width-20,frame1.size.height - 185);
            
                        if ([self.navigationController.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)])
                        {
                                [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"Historytitle~ipad.png"] forBarMetrics:UIBarMetricsDefault];
                                self.navigationController.navigationBar.frame=CGRectMake(0.0, 0.0,frame1.size.width, 78.0);
                        }
                }
        }
    
    [_loggerinrange addTarget:self action:@selector(backToLogger:) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem=barButton;
    
    [self.view addSubview:backgroundImage];
    [self.view sendSubviewToBack:backgroundImage];

    [self.view addSubview:historySelect];
    [self.view addSubview:_histroyoflogger];
    [self.view addSubview:_loggerinrange];
}

-(void)viewWillDisappear:(BOOL)animated
{
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return historyInfo.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier=@"Cell";
    
    HistoryCell *cell=[tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    if(cell==nil){
        cell=[[HistoryCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.backgroundColor=[UIColor clearColor];
    
    //****** Table Cell Creation to display the logger history in table ******//
    
    cell.loggerName.text = [[historyInfo objectAtIndex:indexPath.row] valueForKey:@"logger_name"];
    cell.date.text = [[historyInfo objectAtIndex:indexPath.row] valueForKey:@"date"];
    
    NSString *strTime=[[historyInfo objectAtIndex:indexPath.row] valueForKey:@"time"];
    NSString *exactTime;
    
    if([strTime rangeOfString:@"AM"] .location!= NSNotFound)
    {
        array=[strTime componentsSeparatedByString:@"AM"];
        exactTime=[array objectAtIndex:0];
    }
    else if([strTime rangeOfString:@"am"] .location!= NSNotFound)
    {
        array=[strTime componentsSeparatedByString:@"am"];
        exactTime=[array objectAtIndex:0];
    }
    else if([strTime rangeOfString:@"PM"].location !=NSNotFound)
    {
        array=[strTime componentsSeparatedByString:@"PM"];
        exactTime=[array objectAtIndex:0];
    }
    else if ([strTime rangeOfString:@"pm"].location !=NSNotFound)
    {
        array=[strTime componentsSeparatedByString:@"pm"];
        exactTime=[array objectAtIndex:0];
    }
    else
    {
        exactTime=strTime;
    }
    
    cell.time.text=exactTime;
    cell.description.text = [[historyInfo objectAtIndex:indexPath.row] valueForKey:@"description"];
    
   if((UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone))
   {
       cell.clockView.image =[UIImage imageNamed:@"HistoryTimeIcon.png"];
       cell.calanderView.image =[UIImage imageNamed:@"HistoryCalendar.png"];
   }
    else
    {
        cell.clockView.image =[UIImage imageNamed:@"HistoryTimeIcon~ipad.png"];
        cell.calanderView.image =[UIImage imageNamed:@"HistoryCalendarIcon~ipad.png"];
    }
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    NSLog(@"row id - %@",[[historyInfo objectAtIndex:indexPath.row] valueForKey:@"row_id"]);
    NSLog(@"index path - %d",indexPath.row);
    
    return cell;
}

//***** method to get the information about the selected row to the like, file name and file path to show the logger information and downloaded logger sensor data to the user ******//

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    hisLoggerName=[[historyInfo objectAtIndex:indexPath.row] valueForKey:@"logger_name"];
    
    [[NSUserDefaults standardUserDefaults] setValue:hisLoggerName forKey:@"Navtitle"];
    [[NSUserDefaults standardUserDefaults] synchronize];
  
    LoggerDataOnHistory *ldoh=[[LoggerDataOnHistory alloc]init];
    
    ldoh.getLogger=[NSString stringWithFormat:@"%@",[[historyInfo objectAtIndex:indexPath.row] valueForKey:@"logger_name"]];
    ldoh.getDate=[NSString stringWithFormat:@"%@",[[historyInfo objectAtIndex:indexPath.row] valueForKey:@"date"]];
    ldoh.getTime=[NSString stringWithFormat:@"%@",[[historyInfo objectAtIndex:indexPath.row] valueForKey:@"time"]];
    ldoh.getDes=[NSString stringWithFormat:@"%@",[[historyInfo objectAtIndex:indexPath.row] valueForKey:@"description"]];
    ldoh.getDataPath=[NSString stringWithFormat:@"%@",[[historyInfo objectAtIndex:indexPath.row]valueForKey:@"dataPath"]];
    
    [self.navigationController pushViewController:ldoh animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"index path - %d",indexPath.row);
    
    if(editingStyle == UITableViewCellEditingStyleDelete)
    {
        NSString *index=[[historyInfo objectAtIndex:indexPath.row] valueForKey:@"row_id"];
        NSLog(@"index string - %@",index);
        int index_val1=[index intValue];
        
        [historyInfo removeObjectAtIndex:indexPath.row];
        [tableView  deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        
        NSLog(@"Value of the index - %d",index_val1);
        
        [dbc deleteRow:index_val1];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if((UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone))
    {
    return 70.0;
    }
    else
    {
        return 110.0;
    }
}

#pragma mark - Method for control present in navigation and Tabbar

-(IBAction)infoView:(id)sender
{
    InfoView *iv=[[InfoView alloc]init];
    [self.navigationController pushViewController:iv animated:YES];
}


-(IBAction)backToLogger:(id)sender
{
    ScanDevice *sd=[[ScanDevice alloc]init];
    [self.navigationController pushViewController:sd animated:NO];
    
    NSMutableArray *viewcont=[[NSMutableArray alloc]initWithArray:[[self navigationController]viewControllers]];
    
    NSLog(@"Before %@",[[self navigationController]viewControllers]);

    for( int i=0;i<[ viewcont count];i++)
    {
        id obj=[viewcont objectAtIndex:i];
        if([obj isKindOfClass:[HistroyView class]])
        {
            [viewcont removeObjectAtIndex:i];
        }
         NSLog(@"From his %@",self.navigationController.viewControllers);
    }
    self.navigationController.viewControllers=viewcont;
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

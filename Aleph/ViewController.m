//
//  ViewController.m
//  Aleph
//
//  Created by Biranchi on 18/10/2017.
//  Copyright © 2017 Biranchi. All rights reserved.
//

#import "ViewController.h"

#define COLLAPSED_TABLEVIEW_HEIGHT  88
#define EXPANDED_TABLEVIEW_HEIGHT   5*88
#define TABLE_HEADERVIEW_HEIGHT     40
#define TABLE_FOOTERVIEW_HEIGHT     15


typedef NS_ENUM(NSInteger, CellAnimationDirection) {
    CellAnimationDirectionFromLeft,
    CellAnimationDirectionFromRight
};


@interface ViewController () <UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate>

@property (nonatomic, weak) IBOutlet UITableView    *aTableView;
@property (nonatomic, strong) NSMutableArray        *listArr;

@property (nonatomic, strong) UIView                *tableHeaderView;
@property (nonatomic, strong) UIView                *tableFooterView;

@property (nonatomic, assign) CellAnimationDirection cellAnimationDirection;

@end



@implementation ViewController


-(void)initializeArrayList {
    self.listArr = [NSMutableArray array];
    for(int i=0; i < 10; i++){
        [self.listArr addObject:[NSString stringWithFormat:@"Item %d", i + 1]];
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    //------ Initialize the array list ---------
    [self initializeArrayList];
    
    
    CGRect tableViewFrame       = self.aTableView.frame;
    tableViewFrame.size.height  = COLLAPSED_TABLEVIEW_HEIGHT;
    self.aTableView.frame       = tableViewFrame;
    

    [self createTableHeaderView];
    [self createTableFooterView];
    
}




#pragma mark - UITable Header View

-(void)createTableHeaderView {
    

    self.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.aTableView.frame.size.width, TABLE_HEADERVIEW_HEIGHT)];

    //----- Back Button ------
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(5, 10, 25, 20);
    //[backBtn setTitle:@"Back" forState:UIControlStateNormal];
    [backBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [self.tableHeaderView addSubview:backBtn];
    self.tableHeaderView.clipsToBounds = YES;
    [backBtn addTarget:self action:@selector(backBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    


    //----- Title ------
    
    UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(self.tableHeaderView.frame.size.width/2 - 100/2, 5, 100, 30)];
    titleLbl.text = @"Items List";
    titleLbl.textColor = [UIColor whiteColor];
    titleLbl.font = [UIFont boldSystemFontOfSize:16.0];
    [self.tableHeaderView addSubview:titleLbl];

    self.tableHeaderView.backgroundColor = [UIColor lightGrayColor];

    
    CGRect tableHeaderViewFrame         = self.tableHeaderView.frame;
    tableHeaderViewFrame.size.height    = 0;
    self.tableHeaderView.frame          = tableHeaderViewFrame;
    
    self.aTableView.tableHeaderView     = self.tableHeaderView;

}



#pragma mark - UITable Footer View

-(void)createTableFooterView {

    int yPos = self.aTableView.frame.origin.y + self.aTableView.frame.size.height;
    
    self.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, yPos, self.aTableView.frame.size.width, TABLE_FOOTERVIEW_HEIGHT)];
    self.tableFooterView.backgroundColor    = [UIColor clearColor];
    
    
    //------ DownArrow Image -----------
    
    UIImageView *downArrImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.tableFooterView.frame.size.width/2 - 100/2, 0, 100, TABLE_FOOTERVIEW_HEIGHT)];
    downArrImageView.image = [UIImage imageNamed:@"DownArrow"];
    [self.tableFooterView addSubview:downArrImageView];
    
    [self.view addSubview:self.tableFooterView];
    
    
    //-------- Added TapGesture Recognizer ----------
    
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(expandTableView)];
    [self.tableFooterView addGestureRecognizer:gestureRecognizer];
    
    
}





#pragma mark - TableView DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.listArr count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell   = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"Cell"];
    cell.textLabel.text     = [self.listArr objectAtIndex:indexPath.row];
    
    return cell;
}




#pragma mark - TableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}





- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    int xPos = (self.cellAnimationDirection == CellAnimationDirectionFromLeft) ? -300 : 0;
    
    //NSLog(@"xPos : %d", xPos);
    
    CATransform3D animate = CATransform3DTranslate(CATransform3DIdentity, xPos, 0, 0);
    cell.layer.transform = animate;
    
    [UIView animateWithDuration:0.6 animations:^{
        
        if(self.cellAnimationDirection == CellAnimationDirectionFromLeft){
            cell.layer.transform = CATransform3DIdentity;
        } else {
            //cell.layer.transform = CATransform3DIdentity;
            cell.layer.transform = CATransform3DTranslate(CATransform3DIdentity, -tableView.frame.size.width, 0, 0);
        }
        
    }];

    
    
//    CATransition *transition = [CATransition animation];
//    transition.duration = 0.5;
//    
//    transition.type = kCATransitionPush;
//    //transition.type = kCATransitionMoveIn;
//    
//    //transition.type = (self.cellAnimationDirection == CellAnimationDirectionFromLeft)?kCATransitionReveal : kCATransitionFade;
//    transition.subtype = (self.cellAnimationDirection == CellAnimationDirectionFromLeft)?  kCATransitionFromLeft : kCATransitionFromRight;
//    
//    [transition setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
//    [cell.layer addAnimation:transition forKey:nil];
    
}




#pragma mark - Back Button Action

-(void)backBtnAction:(UIButton *)sender{
    
    
    self.cellAnimationDirection = CellAnimationDirectionFromRight;

    
    CGRect tableViewFrame       = self.aTableView.frame;
    tableViewFrame.size.height  =  COLLAPSED_TABLEVIEW_HEIGHT;
    
    
    [UIView animateWithDuration:0.3 animations:^{
        
        self.aTableView.frame               = tableViewFrame;
        
        CGRect tableHeaderViewFrame         = self.tableHeaderView.frame;
        tableHeaderViewFrame.size.height    = 0;
        self.tableHeaderView.frame          = tableHeaderViewFrame;

    } completion:^(BOOL finished) {
        self.tableFooterView.hidden         = NO;
    }];
    
    [self.aTableView reloadData];

}





#pragma mark - Scrollview Delegate


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSLog(@"End : %@", NSStringFromCGPoint(scrollView.contentOffset));
    
    if(scrollView.contentOffset.y == 0){
        
        if(self.aTableView.frame.size.height == COLLAPSED_TABLEVIEW_HEIGHT){

            [self expandTableView];
            
        }
        
    }
    
}



-(void)expandTableView {
    
    self.cellAnimationDirection         = CellAnimationDirectionFromLeft;

    CGRect tableHeaderViewFrame         = self.tableHeaderView.frame;
    tableHeaderViewFrame.size.height    = TABLE_HEADERVIEW_HEIGHT;
    
    CGRect tableViewFrame               = self.aTableView.frame;
    tableViewFrame.size.height          =  EXPANDED_TABLEVIEW_HEIGHT;
    
    [self.aTableView setContentOffset:CGPointMake(0, 0) animated:YES];
    
    [UIView animateWithDuration:0.3 animations:^{
        
        self.tableHeaderView.frame      = tableHeaderViewFrame;
        self.aTableView.frame           = tableViewFrame;

    }];
    
    self.tableFooterView.hidden         = YES;
    [self.aTableView reloadData];

}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

//
//  TenMinViewController.m
//  NewsTwoApp
//
//  Created by 蒙建华 on 15/7/6.
//  Copyright (c) 2015年 meng. All rights reserved.
//

#import "TenMinViewController.h"
#import "VideoDetailController.h"
#import "TenMiniCell.h"
#import "Macro.h"

#define MENUHEIHT 40
#define MENU_BUTTON_WIDTH  320/5
#define MENU_HEIGHT 45

#define _scrollVTag 606
#define _navScrollVTag 808


@interface TenMinViewController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>
{
    //页面滚动
    UIView *_navView;
    UIView *_topNaviV;
    UIScrollView *_scrollV;
    
    //导航滚动
    UIScrollView *_navScrollV;
    UIView *_navBgV;
    
    float _startPointX;
}

@property (nonatomic, strong) NSMutableArray *scrollDataSource;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation TenMinViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = NO;
    self.titleLabel.text = @"10分钟";
    
    [self initNavScrollView];

}


- (void)initNavScrollView
{
    //导航栏（_navView的y位置与_scrollV的y位置关联，设置的时候注意）
    _navView = [[UIImageView alloc] initWithFrame:CGRectMake(0.f, self.titleLabel.frame.size.height, self.view.frame.size.width, 25.f)];
    ((UIImageView *)_navView).backgroundColor = RGBA(33.f,125.f,194.f,1);
    _navView.userInteractionEnabled = YES;
    
    //滚动导航栏
    _topNaviV = [[UIView alloc] initWithFrame:CGRectMake(0, _navView.frame.size.height + _navView.frame.origin.y, self.view.frame.size.width, MENU_HEIGHT)];
    _topNaviV.backgroundColor = RGBA(33.f,125.f,194.f,1);
    [self.view addSubview:_topNaviV];
    
    //滚动页面
    _scrollV = [[UIScrollView alloc] initWithFrame:CGRectMake(0, _topNaviV.frame.origin.y + _topNaviV.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - _topNaviV.frame.origin.y - _topNaviV.frame.size.height )];
    [_scrollV setPagingEnabled:YES];
    [_scrollV setShowsHorizontalScrollIndicator:NO];
    [self.view insertSubview:_scrollV belowSubview:_navView];
    _scrollV.tag = _scrollVTag;
    _scrollV.delegate = self;
    
    [self createScrollBtns];
}

//创建scroll 滚动菜单
- (void)createScrollBtns
{
    _scrollDataSource = [NSMutableArray arrayWithObjects:@"娱乐", @"新闻",@"搞笑",@"游戏",@"科学", nil];
    
    _navScrollV = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, MENU_HEIGHT)];
    _navScrollV.tag = _navScrollVTag;
    [_navScrollV setShowsHorizontalScrollIndicator:NO];
    for (int i = 0; i < [_scrollDataSource count]; i++)
    {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setFrame:CGRectMake(MENU_BUTTON_WIDTH * i, 0, MENU_BUTTON_WIDTH, MENU_HEIGHT)];
        [btn setTitle:[_scrollDataSource objectAtIndex:i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btn.tag = i + 1;
        [btn addTarget:self action:@selector(actionbtn:) forControlEvents:UIControlEventTouchUpInside];
        [_navScrollV addSubview:btn];
    }
    [_navScrollV setContentSize:CGSizeMake(MENU_BUTTON_WIDTH * [_scrollDataSource count], MENU_HEIGHT)];
    [_topNaviV addSubview:_navScrollV];
    
    //滚动栏底部 滚动条
    _navBgV = [[UIView alloc] initWithFrame:CGRectMake(0, MENU_HEIGHT - 4, MENU_BUTTON_WIDTH, 5)];
    [_navBgV setBackgroundColor:[UIColor redColor]];
    [_navScrollV addSubview:_navBgV];
    
    [self addView2Page:_scrollV count:[_scrollDataSource count] frame:CGRectZero];
}

//显示当前选择scroll的btn要显示的内容
- (void)addView2Page:(UIScrollView *)scrollV count:(NSUInteger)pageCount frame:(CGRect)frame
{
    for (int i = 0; i < pageCount; i++)
    {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(scrollV.frame.size.width * i, 0, scrollV.frame.size.width, scrollV.frame.size.height)];
        view.tag = i + 1;
        
        [self creatScrollSubViewsInViews:view];
        
        [scrollV addSubview:view];
    }
    
    [scrollV setContentSize:CGSizeMake(scrollV.frame.size.width * pageCount, scrollV.frame.size.height)];
    
}

-(void)creatScrollSubViewsInViews:(UIView *)View{
    
    for (int i = 0; i < [_scrollDataSource count]; i++)
    {
        if (View.tag == i+1) {
            self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, IS_IPHONE_5?504:(504-88)) style:UITableViewStylePlain];
            self.tableView.tag = View.tag;
            self.tableView.delegate = self;
            self.tableView.dataSource = self;
            [View addSubview:self.tableView];
        }
    }
    
}

- (void)changeView:(float)x
{
    float xx = x * (MENU_BUTTON_WIDTH / self.view.frame.size.width);
    [_navBgV setFrame:CGRectMake(xx, _navBgV.frame.origin.y, _navBgV.frame.size.width, _navBgV.frame.size.height)];
}

#pragma mark - scrollBtn_action
- (void)actionbtn:(UIButton *)btn
{
    [_scrollV scrollRectToVisible:CGRectMake(_scrollV.frame.size.width * (btn.tag - 1), _scrollV.frame.origin.y, _scrollV.frame.size.width, _scrollV.frame.size.height) animated:YES];
    
    float xx = _scrollV.frame.size.width * (btn.tag - 1) * (MENU_BUTTON_WIDTH / self.view.frame.size.width) - MENU_BUTTON_WIDTH;
    [_navScrollV scrollRectToVisible:CGRectMake(xx, 0, _navScrollV.frame.size.width, _navScrollV.frame.size.height) animated:YES];
}


#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (scrollView.tag == _scrollVTag) {
        _startPointX = scrollView.contentOffset.x;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.tag == _scrollVTag) {
        [self changeView:scrollView.contentOffset.x];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView.tag == _scrollVTag) {
        float xx = scrollView.contentOffset.x * (MENU_BUTTON_WIDTH / self.view.frame.size.width) - MENU_BUTTON_WIDTH;
        [_navScrollV scrollRectToVisible:CGRectMake(xx, 0, _navScrollV.frame.size.width, _navScrollV.frame.size.height) animated:YES];
    }
}

#pragma mark -
#pragma mark UITableViewDelegate method

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 205;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *str = @"TenMiniCell";
    TenMiniCell *cell = (TenMiniCell *)[tableView dequeueReusableCellWithIdentifier:str];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"TenMiniCell"
                                                     owner:self options:nil];
        for (id oneObject in nib)
            if ([oneObject isKindOfClass:[TenMiniCell class]])
                cell = (TenMiniCell *)oneObject;
    }
    cell.backgroundColor = RGBA(222, 222, 222, 1);
    
    UIImage *img = [UIImage imageNamed:@"circle_4.png"];
    NSString *movieName = @"郑爽称仍和张翰有关系";
    NSString *movieDescription = @"20次播放";
    NSMutableArray *arry = [NSMutableArray arrayWithObjects:img,movieName,movieDescription, nil];
    
    [cell setCellContence:arry];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self pushVC:[[VideoDetailController alloc] init]];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

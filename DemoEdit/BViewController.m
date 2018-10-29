//
//  BViewController.m
//  DemoEdit
//
//  Created by CHLMA2015 on 2018/10/28.
//  Copyright © 2018年 MACHUNLEI. All rights reserved.
//

#import "BViewController.h"
#import <objc/runtime.h>


#define screen_w UIScreen.mainScreen.bounds.size.width
#define screen_h UIScreen.mainScreen.bounds.size.height

@interface BViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>
{
    UIButton *_btn1;
    UIButton *_btn2;
    UIButton *_btn3;
    UILabel *_lineLabel;

}
@property(nonatomic, strong)UIView *bottmView;

@property(nonatomic, strong) NSMutableSet *mSet;

@end

@implementation BViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [btn setTitle:@"编辑" forState:UIControlStateNormal];
    [btn setTitle:@"取消" forState:UIControlStateSelected];
    [btn addTarget:self action:@selector(editAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
    UIScrollView *sc = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, screen_w, screen_h-64)];
    sc.contentSize = CGSizeMake(screen_w*5, screen_h-64);
    sc.pagingEnabled = YES;
    sc.delegate = self;
    
    [self.view addSubview:sc];
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, screen_h, screen_w, 100)];
    bottomView.backgroundColor = [UIColor redColor];
    self.bottmView = bottomView;
    [self.view addSubview:bottomView];
    
    for (int i= 0; i<5;i++) {
       
        UITableView *table = [[UITableView alloc] initWithFrame:CGRectMake(i*screen_w, 0, screen_w, CGRectGetHeight(sc.frame)) style:UITableViewStylePlain];
        table.delegate = self;
        table.dataSource = self;
        table.tag = 100 + i;
        [sc addSubview:table];
    }
    
    [btn addObserver:self forKeyPath:@"selected" options:NSKeyValueObservingOptionNew context:(__bridge void * _Nullable)(sc)];

    self.mSet = [NSMutableSet new];
    [self.mSet addObject:@(1)];
    [self.mSet addObject:@(2)];
    [self.mSet addObject:@(3)];
    
    
    [self addObserver:self forKeyPath:@"mSet" options:NSKeyValueObservingOptionNew context:nil];
    

    
    [[self mutableSetValueForKeyPath:@"mSet"] addObject:@(4)];
    [[self mutableSetValueForKeyPath:@"mSet"] addObject:@(5)];

    [self btns];
    
}


- (void)btns{
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, screen_w, 100)];
    bgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
    
    UIButton *btn1 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    [btn1 setTitle:@"栏目一" forState:UIControlStateNormal];
    [btn1 sizeToFit];
    
    CGSize size1 = btn1.frame.size;
    btn1.frame = CGRectMake(0, 0, size1.width, size1.height);
    
    
    UIButton *btn2 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    [btn2 setTitle:@"今日说法非常" forState:UIControlStateNormal];
    [btn2 sizeToFit];
    CGSize size2 = btn2.frame.size;
    btn2.frame = CGRectMake(CGRectGetMaxX(btn1.frame)+30, 0, size2.width, size2.height);

    UIButton *btn3 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    [btn3 setTitle:@"新闻" forState:UIControlStateNormal];
    [btn3 sizeToFit];
    CGSize size3 = btn3.frame.size;
    btn3.frame = CGRectMake(CGRectGetMaxX(btn2.frame)+30, 0, size3.width, size3.height);
    
    [bgView addSubview:btn1];
    [bgView addSubview:btn2];
    [bgView addSubview:btn3];

    UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 80, size1.width, 1)];
    lineLabel.backgroundColor = [UIColor redColor];
    lineLabel.center = CGPointMake(btn1.center.x, 80);
    [bgView addSubview:lineLabel];
    
    [self.view addSubview:bgView];
    
    _btn1 = btn1;
    _btn2 = btn2;
    _btn3 = btn3;
    
    _lineLabel = lineLabel;

    
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    
    int index = scrollView.contentOffset.x/screen_w;
    
    if (index == 0) {
        
        [UIView animateWithDuration:0.25 animations:^{
           
            self->_lineLabel.center = CGPointMake( self->_btn1.center.x, 80);
            CGFloat w = CGRectGetWidth(self->_btn1.frame);
            
            self->_lineLabel.frame = CGRectMake(self->_btn1.center.x-w/2, 80, w, 1);
        }];
    }
    
    if (index == 1) {
        
        [UIView animateWithDuration:0.25 animations:^{
            
            self->_lineLabel.center = CGPointMake( self->_btn2.center.x, 80);
            CGFloat w = CGRectGetWidth(self->_btn2.frame);
            
            self->_lineLabel.frame = CGRectMake(self->_btn2.center.x-w/2, 80, w, 1);
        }];
    }
    
    if (index == 2) {
        
        [UIView animateWithDuration:0.25 animations:^{
            
            self->_lineLabel.center = CGPointMake( self->_btn3.center.x, 80);
            
            CGFloat w = CGRectGetWidth(self->_btn3.frame);
            
            self->_lineLabel.frame = CGRectMake(self->_btn3.center.x-w/2, 80, w, 1);
            
        }];
    }
    
    
    
}



- (void)editAction:(UIButton *)sender{
    sender.selected = !sender.selected;
}


-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"selected"]) {
        BOOL res = [change[NSKeyValueChangeNewKey] boolValue];
        UIScrollView *sc = (__bridge UIScrollView *)context;
        sc.scrollEnabled = !res;
        
        int place = sc.contentOffset.x/screen_w;
        
        UITableView *tab = [sc viewWithTag:place+100];
        
        if (res) {
            
            [UIView animateWithDuration:0.25 animations:^{
                tab.frame = CGRectMake(tab.frame.origin.x, 0, screen_w, screen_h - 64 - 100);
                self.bottmView.frame = CGRectMake(0, screen_h-100, screen_w, 100);
            }];
            
        }else{

            [UIView animateWithDuration:0.25 animations:^{
                tab.frame = CGRectMake(tab.frame.origin.x, 0, screen_w, screen_h - 64);
                self.bottmView.frame = CGRectMake(0, screen_h, screen_w, 0);
            }];
            
        }
    }
    
    if ([keyPath isEqualToString:@"mSet"]) {
        
        
        NSLog(@"count = %d",self.mSet.count);
        
        
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" ];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    
    cell.backgroundColor = [UIColor colorWithRed:arc4random()%256/255.0 green:arc4random()%256/255.0 blue:arc4random()%256/255.0 alpha:1];
    cell.textLabel.text = @(indexPath.row).stringValue;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [[self mutableSetValueForKeyPath:@"mSet"] removeObject:@(indexPath.row)];
    
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

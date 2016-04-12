//
//  ViewController.m
//  HHOC-JS
//
//  Created by Hong on 16/1/29.
//  Copyright © 2016年 Hong. All rights reserved.
//

#import "ViewController.h"
#import "SimpleViewController.h"
#import "YoutubeViewController.h"
#import "JSCViewController.h"

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSArray *dataArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    
    _dataArray = @[
                   @"simple",
                   @"youtube",
                   @"JavaScriptCore"
                   ];
}

#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.textLabel.text = [self.dataArray objectAtIndex:indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
        {
            SimpleViewController *vc = [[SimpleViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 1:
        {
            YoutubeViewController *vc = [[YoutubeViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 2:
        {
            JSCViewController *vc = [[JSCViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

//
//  MasterViewController.m
//  ios-js-example
//
//  Created by hong-drmk on 2017/9/29.
//  Copyright © 2017年 hong-drmk. All rights reserved.
//

#import "MasterViewController.h"
#import "SimpleViewController.h"
#import "JSCoreViewController.h"
#import "WKWebViewViewController.h"

@interface MasterViewController ()

@property NSArray *objects;
@end

@implementation MasterViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view, typically from a nib.
  self.navigationItem.leftBarButtonItem = self.editButtonItem;
  
  self.objects = @[
                   @"simple use JS",
                   @"use JS by JavaScriptCore",
                   @"use JS by WKWebView"
                   ];
}


- (void)viewWillAppear:(BOOL)animated {
  self.clearsSelectionOnViewWillAppear = self.splitViewController.isCollapsed;
  [super viewWillAppear:animated];
}


- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return self.objects.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
  NSDate *object = self.objects[indexPath.row];
  cell.textLabel.text = [object description];
  return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIViewController *viewController = nil;
    switch (indexPath.row) {
        case 0:
        {
            viewController = [[SimpleViewController alloc] init];
        }
            break;
        case 1:
        {
            viewController = [[JSCoreViewController alloc] init];
        }
            break;
        case 2:
        {
            viewController = [[WKWebViewViewController alloc] init];
        }
            break;
        default:
            break;
    }
  
    if (viewController) {
        UINavigationController *navigationVC = [[UINavigationController alloc] initWithRootViewController:viewController];
        viewController.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
        viewController.navigationItem.leftItemsSupplementBackButton = YES;
        [self.splitViewController showDetailViewController:navigationVC sender:nil];
    }
}


@end

//
//  MMBarricadeViewController.m
//
// Copyright (c) 2015 Mutual Mobile (http://www.mutualmobile.com/)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "MMBarricadeViewController.h"
#import "MMBarricade.h"
#import "MMBarricadeResponseSetViewController.h"


@interface MMBarricadeViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@end


@implementation MMBarricadeViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"MMBarricade", nil);
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Reset" style:UIBarButtonItemStylePlain target:self action:@selector(resetPressed:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(donePressed:)];

    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
    self.tableView.frame = self.view.bounds;
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.tableView deselectRowAtIndexPath:self.tableView.indexPathForSelectedRow animated:animated];
    [self.tableView reloadData];
}


#pragma mark - Actions

- (void)resetPressed:(id)sender {
    id<MMBarricadeResponseStore> responseStore = [MMBarricade responseStore];
    [responseStore resetResponseSelections];
    [self.tableView reloadData];
}

- (void)donePressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    id<MMBarricadeResponseStore> responseStore = [MMBarricade responseStore];
    return responseStore.allResponseSets.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"IDENTIFIER"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"IDENTIFIER"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }

    id<MMBarricadeResponseStore> responseStore = [MMBarricade responseStore];
    MMBarricadeResponseSet *responseSet = responseStore.allResponseSets[indexPath.row];
    cell.textLabel.text = responseSet.requestName;
    
    id<MMBarricadeResponse> selectedResponse = [responseStore currentResponseForResponseSet:responseSet];
    cell.detailTextLabel.text = selectedResponse.name;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    id<MMBarricadeResponseStore> responseStore = [MMBarricade responseStore];
    MMBarricadeResponseSet *responseSet = responseStore.allResponseSets[indexPath.row];
    MMBarricadeResponseSetViewController *viewController = [[MMBarricadeResponseSetViewController alloc] initWithResponseSet:responseSet];
    [self.navigationController pushViewController:viewController animated:YES];
}

@end

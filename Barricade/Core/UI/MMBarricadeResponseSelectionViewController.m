//
//  MMBarricadeResponseSelectionViewController.m
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

#import "MMBarricadeResponseSelectionViewController.h"
#import "MMBarricade.h"


static NSString * const kTableCellIdentifier = @"BasicTableCell";


@interface MMBarricadeResponseSelectionViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) MMBarricadeResponseSet *responseSet;
@property (nonatomic, strong) UITableView *tableView;

@end


@implementation MMBarricadeResponseSelectionViewController

- (instancetype)initWithResponseSet:(MMBarricadeResponseSet *)responseSet {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _responseSet = responseSet;
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = self.responseSet.requestName;
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
    self.tableView.frame = self.view.bounds;
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kTableCellIdentifier];
}


#pragma mark - UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.responseSet.allResponses.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kTableCellIdentifier];
    
    id<MMBarricadeResponse> response = self.responseSet.allResponses[indexPath.row];
    cell.textLabel.text = response.name;
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    id<MMBarricadeResponseStore> responseStore = [MMBarricade responseStore];
    id<MMBarricadeResponse> selectedResponse = [responseStore currentResponseForResponseSet:self.responseSet];
    if ([response isEqual:selectedResponse]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    id<MMBarricadeResponse> response = self.responseSet.allResponses[indexPath.row];
    [MMBarricade selectResponseForRequest:self.responseSet.requestName withName:response.name];
    [self.navigationController popViewControllerAnimated:YES];
}

@end

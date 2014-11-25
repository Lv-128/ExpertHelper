//
//  CLExternalViewController.m
//  firstCalendarFrom
//
//  Created by alena on 10/30/14.
//  Copyright (c) 2014 alenka. All rights reserved.
//

#import "EHExternalViewController.h"
#import "EHExternalCell.h"

@interface EHExternalViewController () <UITableViewDelegate, UITableViewDataSource>

@property (copy, nonatomic) NSArray *array;

@end

@implementation EHExternalViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.array = @[@"Programming languages", @"Libraries, frameworks", @"Technology Domains", @"Methidilogies", @"Code review tools", @"Build automation tools", @"RDBMS", @"Platform Specific Deelopment"];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_array count];
}

- (EHExternalCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EHExternalCell *cell = [[EHExternalCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ExternalCell"];
    cell.textLabel.text = _array[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"GoToP" sender:[tableView dequeueReusableCellWithIdentifier:@"ExternalCell" forIndexPath:indexPath]];
}

@end
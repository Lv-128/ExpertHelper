//
//  CLPopoverViewController.m
//  Interview Assistant
//
//  Created by nvlizlo on 07.11.14.
//  Copyright (c) 2014 Katolyk S. All rights reserved.
//

#import "EHFacebookPopoverViewController.h"
#import "EHLinkCell.h"
#import <FacebookSDK/FacebookSDK.h>

NSString *fbScheme = @"fb://";
NSString *htppScheme = @"https://";
NSString *linkedInScheme = @"linkedin://";
NSError *error = nil;

@interface EHFacebookPopoverViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *links;
@property (nonatomic, strong) NSMutableArray *pictures;
@property (nonatomic, strong) NSMutableArray *ids;
@property (nonatomic, copy) NSString *mainURL;
@property (weak, nonatomic) IBOutlet UITableView *tablewView;


@end

@implementation EHFacebookPopoverViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [self searchUser];
    [super viewDidLoad];
    
    NSString *s =  [[[FBSession activeSession] accessTokenData] accessToken];
    NSString *accessToken = [NSString stringWithContentsOfURL:[NSURL URLWithString:s] encoding:NSUTF8StringEncoding error:nil];
    NSLog(@"%@", accessToken);
    // Do any additional setup after loading the view from its nib.access_token=401991143287460|F9_QPA6FmcSn1w5tepwysA5SkOQ
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //[self searchUser];
    return [self.links count];
}

- (void)searchUser
{
    [FBRequestConnection startWithGraphPath:[NSString stringWithFormat:@"/search?q=%@+%@&type=user", _firstName, _lastName]
                          completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if (error)
            NSLog(@"%@", [error description]);
        else
        {
            self.links = result[@"data"];
            [self tableView:self.tablewView numberOfRowsInSection:1];
            [[self tablewView] reloadData];
        }
    }];
    
}

- (EHLinkCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EHLinkCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell)
        cell = [[EHLinkCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    cell.textLabel.text = _links[indexPath.row][@"name"];
    cell.imageView.image = [self profilePictureFromID:_links[indexPath.row][@"id"]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UIApplication *application = [UIApplication sharedApplication];
    
    if ([application canOpenURL:[NSURL URLWithString:[NSString stringWithFormat:@"fb://%@", _links[indexPath.row][@"id"]]]])
        [application openURL:[NSURL URLWithString:[NSString stringWithFormat:@"fb://%@", _links[indexPath.row][@"id"]]]];
    else
        [application openURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://facebook.com/%@", _links[indexPath.row][@"id"]]]];
    
}

- (NSDictionary *)dictionaryFromUrl:(NSString *)urlString
{
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlString]];
    
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    return dictionary;
}

- (UIImage *)profilePictureFromID:(NSString *)ID
{
     UIImage *image;
    
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:
                                           [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?redirect=false", ID]]];
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    //    [FBRequestConnection startWithGraphPath:[NSString stringWithFormat:@"/%@/picture?redirect=false", ID] completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
            NSURL *imageUrl = [NSURL URLWithString:dictionary[@"data"][@"url"]];
            NSData *imageData = [NSData dataWithContentsOfURL:imageUrl];
            image = [UIImage imageWithData:imageData];
             return image;
        //}];
   // return image;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

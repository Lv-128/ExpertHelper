//
//  EHAddRecruiterController.m
//  ExpertHelper
//
//  Created by alena on 12/9/14.
//  Copyright (c) 2014 Katolyk S. All rights reserved.
//

#import "EHAddRecruiterController.h"
#import "EHAppDelegate.h"
@interface EHAddRecruiterController ()
@property (weak, nonatomic) IBOutlet UITextField *labelFirstName;
@property (weak, nonatomic) IBOutlet UITextField *labelLastName;
@property (weak, nonatomic) IBOutlet UITextField *labelEmail;

@end

@implementation EHAddRecruiterController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (IBAction)addRecruiter:(id)sender {
    
    EHAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    
    Recruiter *recruiter = [NSEntityDescription
                            insertNewObjectForEntityForName:[Recruiter entityName]
                            inManagedObjectContext:context];
    recruiter.firstName = _labelFirstName.text;
    recruiter.lastName = _labelLastName.text;
    recruiter.email = _labelEmail.text;
    recruiter.skypeAccount = @"echo";
    
    


    NSString * urlString = [self callToWebAndGetPictureOfRecruiterWithName:recruiter.firstName andLastName:recruiter.lastName];
    if (urlString != nil)
    {
        recruiter.photoUrl = urlString;
    }
    
    
    NSError *error;
    if (![context save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    }
    // Test listing all FailedBankInfos from the store
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Recruiter"
                                              inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    for (Recruiter *info in fetchedObjects) {
        NSLog(@"Name: %@", info.firstName);
        NSLog(@"Last Name: %@", info.lastName);
        
    }
    

    
    
}

- (NSString *) callToWebAndGetPictureOfRecruiterWithName: (NSString*)firstName andLastName:(NSString*)lastName
{
    NSError *error;
    
    
    NSString *patternLastnameFirst = [NSString stringWithFormat:@"(<img src(.)*softserve(.)*%@-%@(.)*png.>)|",lastName,firstName];
    NSString *patternFirstnameFirst =[NSString stringWithFormat:@"(<img src(.)*softserve.ua(.)*%@-%@(.)*png.>)",firstName,lastName];
    NSString *pattern = [patternLastnameFirst stringByAppendingString:patternFirstnameFirst];
    
    
    NSString *getWebInfo = @"https://softserve.ua/ru/vacancies/recruiters/?tax-directions=0&tax-country=117"; /// softserve.ua all recruiters from ukraine
    NSString *getWebInfo2 = @"https://softserve.ua/ru/vacancies/recruiters/page/2/?tax-directions=0&tax-country=117";
    
    NSURL *webUnFormatted = [NSURL URLWithString:getWebInfo];
    NSURL *webUnFormatted2 = [NSURL URLWithString:getWebInfo2];
    // //  NSString *pattern = "<img src="https://softserve.ua/wp-content/uploads/2014/01/Tetyana-Klyuk11-150x150.png">" /// example of content with image link     
    NSString * webFormatted;
    NSString * webFormatted2;
    @try
    {
            webFormatted = [NSString stringWithContentsOfURL:webUnFormatted encoding:NSASCIIStringEncoding error:&error];
            webFormatted2 = [NSString stringWithContentsOfURL:webUnFormatted2 encoding:NSASCIIStringEncoding error:&error];
    }
    @catch (NSException *exception)
    {
        NSLog(@"%@", exception);
    }
    
    
    if (webFormatted !=nil && webFormatted != nil)
    {
        NSString *webContent = [NSString stringWithFormat:@"%@",webFormatted]; // web page content
        webContent = [webContent stringByAppendingString:[NSString stringWithFormat:@" %@",webFormatted2]]; // web page content
        NSRange range = NSMakeRange(0, webContent.length);
        
        NSRegularExpressionOptions regexOptions = NSRegularExpressionCaseInsensitive;
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:regexOptions error:&error];
        NSArray *matches = [regex matchesInString:webContent options:(NSMatchingOptions)regexOptions range:range];
        
        NSString * neededString;
        NSMutableArray *results = [[NSMutableArray alloc]init];
        if ([matches count] > 0)
        {
            for (NSTextCheckingResult *match in matches)
            {
                NSRange matchRange = match.range;
                matchRange.length -= 1;
                [results addObject:[webContent substringWithRange:matchRange]];
            }
            
            NSArray* parseWithSpaces = [results[0] componentsSeparatedByString: @"\""]; // separation  with  "
            neededString = parseWithSpaces[0];
            for (int i = 0; i < parseWithSpaces.count;i++)
            {
                if (neededString.length < [parseWithSpaces[i] length])
                {
                    neededString = parseWithSpaces[i]; // the url of picture
                }
            }
            
            
            return neededString;
        }
        else
        {
            return  nil;
        }
        
    }
    
    else
    {
        return  nil;
    }
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

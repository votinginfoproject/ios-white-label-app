//
//  VIPTableViewController.m
//  VotingInformationProject
//
//  Created by Andrew Fink on 3/18/14.
//

#import "VIPTableViewController.h"
#import "ScreenMacros.h"
#import "VIPColor.h"
#import "VIPFeedbackView.h"
#import "GAI.h"
#import "GAIDictionaryBuilder.h"
#import "GAIFields.h"

@interface VIPTableViewController ()

@property (strong, nonatomic) UIImageView *wallpaper;
@property (strong, nonatomic) UIImageView *banner;
@property (nonatomic) bool backgroundLayoutComplete;

@end

@implementation VIPTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    _wallpaper = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background"]];
    _banner = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"stars"]];
    _backgroundLayoutComplete = NO;

    self.navigationController.navigationBar.translucent = NO;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self sendGAScreenHit];
}

-(void)viewWillLayoutSubviews
{
  [self addBackground];
}

- (void)addBackground
{
  if (_backgroundLayoutComplete) { return; }
  
  CGSize framesize = self.view.frame.size;
  CGRect frame = CGRectMake(0,0, framesize.width, framesize.height);
  _wallpaper.frame = frame;
  
  // The banner height is 1/2 its width
  frame = CGRectMake(0,  framesize.height - framesize.width / 2, framesize.width, framesize.width / 2);
  _banner.frame = frame;
  
  [_wallpaper addSubview:_banner];
  self.tableView.backgroundView = _wallpaper;
  
  _backgroundLayoutComplete = YES;
}

- (void)sendGAScreenHit
{
    if ([self.screenName length] > 0) {
        id tracker = [[GAI sharedInstance] defaultTracker];
        // This screen name value will remain set on the tracker and sent with
        // hits until it is set to a new value or to nil.
        [tracker set:kGAIScreenName
               value:self.screenName];
        
        [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
    }
}

@end

//
//  AboutViewController.m
//  VotingInformationProject
//
//  Created by Andrew Fink on 2/19/14.
//

#import "AboutViewController.h"
#import "ContactsSearchViewController.h"
#import "VIPTabBarController.h"
#import "AppSettings.h"
#import "VIPColor.h"

@interface AboutViewController ()

@property (strong, nonatomic) NSArray *text;
@property (weak, nonatomic) IBOutlet UILabel *termsLabel;
@property (weak, nonatomic) IBOutlet UILabel *privacyLabel;
@property (weak, nonatomic) IBOutlet UILabel *aboutLabel;

@end

@implementation AboutViewController

- (NSArray*)text
{
    if (!_text) {
        _text = @[
                  NSLocalizedString(@"AboutAppText", @"'About' section in 'About this app'"),
                  NSLocalizedString(@"TermsOfUseText", @"'Terms of use' section in 'About this app'"),
                  NSLocalizedString(@"PrivacyPolicyText", @"'Privacy policy' section in 'About this app'")];
    }
    return _text;
}

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

    self.screenName = @"About App Screen";

    self.aboutLabel.text = self.text[0];
    self.termsLabel.text = self.text[1];
    self.privacyLabel.text = self.text[2];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static CGFloat heightPadding = 20;
    NSString *str = self.text[indexPath.section];
    CGSize maximumSize = CGSizeMake(self.view.frame.size.width - 40, CGFLOAT_MAX);
    NSDictionary *strAttributes = @{ NSFontAttributeName : [UIFont systemFontOfSize:15] };
    CGRect strSize = [str boundingRectWithSize:maximumSize
                                       options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                    attributes:strAttributes
                                       context:nil];
    return 2 * heightPadding + ceilf(strSize.size.height);
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    UIColor *textColor = [VIPColor primaryTextColor];
    [[((UITableViewHeaderFooterView*) view) textLabel] setTextColor: textColor];
    view.backgroundColor = [VIPColor color:textColor withAlpha:0.5];
}

- (IBAction)close:(id)sender {
    [self.delegate aboutViewControllerDidClose:self];
}

@end

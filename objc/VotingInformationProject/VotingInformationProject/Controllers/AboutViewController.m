//
//  AboutViewController.m
//  VotingInformationProject
//
//  Created by Andrew Fink on 2/19/14.
//

#import "AboutViewController.h"

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
                  NSLocalizedString(@"Plaid Neutra shabby chic, lomo deep v pop-up irony cornhole. Selvage YOLO single-origin coffee Neutra skateboard you probably haven't heard of them. Portland Intelligentsia distillery Marfa pickled authentic.", nil),
                  NSLocalizedString(@"Fashion axe blog before they sold out art party, Austin selfies Shoreditch ugh photo booth. Kale chips messenger bag Neutra, leggings Helvetica yr paleo keffiyeh tote bag sartorial biodiesel pour-over Truffaut mixtape meggings.", nil),
                  NSLocalizedString(@"Bacon ipsum dolor sit amet kielbasa strip steak bacon, salami prosciutto filet mignon tail drumstick spare ribs short ribs pork biltong beef ribs shankle turkey. Fatback jowl pork belly short ribs, andouille t-bone rump leberkas turducken tongue sirloin corned beef.", nil)];
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
    CGSize maximumSize = CGSizeMake(280, CGFLOAT_MAX);
    NSDictionary *strAttributes = @{ NSFontAttributeName : [UIFont systemFontOfSize:15] };
    CGRect strSize = [str boundingRectWithSize:maximumSize
                                       options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                    attributes:strAttributes
                                       context:nil];
    return 2 * heightPadding + ceilf(strSize.size.height);
}

@end

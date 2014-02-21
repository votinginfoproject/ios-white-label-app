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
                  NSLocalizedString(@"Lorem ipsum dolor sit amet, consectetur adipiscing elit. Morbi scelerisque semper nibh, nec tincidunt justo suscipit ac. Nunc quis nunc sit amet nunc blandit facilisis. Pellentesque lobortis felis vitae quam ultrices posuere. Nullam tristique neque vitae porttitor tempor. Aliquam erat volutpat. Sed mattis elit in elementum sollicitudin. Aenean ultricies, libero quis feugiat fringilla, magna justo suscipit nunc, in sodales dolor purus in lacus.", nil),
                  NSLocalizedString(@"Proin viverra est dignissim sem ornare ultricies. Fusce leo sapien, bibendum nec ante non, lacinia porta massa. Ut eros urna, molestie et hendrerit ac, accumsan sit amet lectus. Vivamus pulvinar, lacus quis aliquet semper, ipsum nisi commodo leo, sed lobortis arcu urna eu erat.", nil),
                  NSLocalizedString(@"Proin viverra est dignissim sem ornare ultricies. Fusce leo sapien, bibendum nec ante non, lacinia porta massa. Ut eros urna, molestie et hendrerit ac, accumsan sit amet lectus. Vivamus pulvinar, lacus quis aliquet semper, ipsum nisi commodo leo, sed lobortis arcu urna eu erat.", nil)];
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

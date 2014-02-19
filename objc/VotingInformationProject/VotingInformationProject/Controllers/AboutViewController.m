//
//  AboutViewController.m
//  VotingInformationProject
//
//  Created by Andrew Fink on 2/19/14.
//  Copyright (c) 2014 Bennet Huber. All rights reserved.
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
                  @"About this app. It is pretty cool and was built as a collaboration between VIP and Azavea. More hipster ipsum here: Plaid Neutra shabby chic, lomo deep v pop-up irony cornhole. Selvage YOLO single-origin coffee Neutra skateboard you probably haven't heard of them. Portland Intelligentsia distillery Marfa pickled authentic.",
                  @"Terms of use: Share it with the whole friggin world!",
                  @"Privacy policy: Be cool and don't steal stuff!"];
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
    return heightPadding + ceilf(strSize.size.height) + heightPadding;
}

@end

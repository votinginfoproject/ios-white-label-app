//
//  VIPFeedbackView.m
//  VotingInformationProject
//
//  Created by Andrew Fink on 11/18/14.
//

#import "VIPFeedbackView.h"

#import "VIPColor.h"

@implementation VIPFeedbackView

+(instancetype)inView:(UIView *)view withDelegate:(id)delegate
{
    CGRect footerFrame = CGRectMake(0, 0, view.frame.size.width, VIP_FEEDBACK_VIEW_HEIGHT);
    VIPFeedbackView *feedbackView = [[self alloc] initWithFrame:footerFrame];
    feedbackView.delegate = delegate;
    return feedbackView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        NSUInteger width = self.frame.size.width;
        NSUInteger height = self.frame.size.height;
        NSUInteger xPadding = 6;
        NSUInteger yPadding = 10;
        UIFont *titleFont = [UIFont systemFontOfSize:15];
        CGRect buttonFrame = CGRectMake(xPadding, yPadding,
                                        width - 2 * xPadding, height - 2 * yPadding);
        UIColor *buttonColor = [VIPColor primaryTextColor];
        UIButton *feedbackButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        feedbackButton.frame = buttonFrame;
        feedbackButton.titleLabel.font = titleFont;
        [feedbackButton setTitle:NSLocalizedString(@"Report an Error", @"Text for error reporting button")
                          forState:UIControlStateNormal];
        [feedbackButton setImage:[UIImage imageNamed:@"Report_issue"]
                        forState:UIControlStateNormal];
        [feedbackButton addTarget:self
                           action:@selector(didTapFeedbackButton:)
                 forControlEvents:UIControlEventTouchUpInside];
        feedbackButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        feedbackButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, xPadding);
        feedbackButton.tintColor = buttonColor;
        [self setBackgroundColor:[UIColor clearColor]];
        [self addSubview:feedbackButton];
    }
    return self;
}

- (IBAction)didTapFeedbackButton:(id)sender
{
    if([self.delegate respondsToSelector:@selector(sendFeedback:)]) {
        [self.delegate sendFeedback:self];
    }
}

@end

//
//  PollingInfoWindowView.m
//  VotingInformationProject
//
//  Created by Andrew Fink on 7/10/14.
//

#import "PollingInfoWindowView.h"

#import "VIPColor.h"

@interface PollingInfoWindowView()

@property (strong, nonatomic) PollingLocationWrapper *plWrapper;

@end

@implementation PollingInfoWindowView

- (instancetype)initWithFrame:(CGRect)frame
    andPollingLocationWrapper:(PollingLocationWrapper *)plWrapper
{
    self = [super initWithFrame:frame];
    if (self) {
        self.plWrapper = plWrapper;
        NSUInteger infoWindowWidth = self.frame.size.width;
        NSUInteger infoWindowMaxHeight = self.frame.size.height;
        NSUInteger xPadding = 10;
        NSUInteger yPadding = 5;
        NSUInteger labelWidth = infoWindowWidth - 2 * xPadding;
        NSUInteger titleLabelHeight = 20;
        NSUInteger directionsButtonHeight = 30;
        NSUInteger availableHeightForSnippet = infoWindowMaxHeight - (2 * yPadding + titleLabelHeight + directionsButtonHeight);
        CGSize maxSize = CGSizeMake(labelWidth, availableHeightForSnippet);
        UIFont *titleFont = [UIFont systemFontOfSize:12];
        UIFont *pollingHoursFont = [UIFont systemFontOfSize:10];

        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(xPadding, yPadding, labelWidth, titleLabelHeight)];
        titleLabel.text = [self.plWrapper.name capitalizedString];
        titleLabel.font = titleFont;

        NSString *snippet = self.plWrapper.location.pollingHours;
        if ([snippet length] == 0) {
            snippet = NSLocalizedString(@"No Polling Hours Available",
                                        @"Text on Map InfoWindow if the Polling Location does not indicate hours of availability");
        }
        CGRect snippetRect = [snippet boundingRectWithSize:maxSize
                                                   options:NSStringDrawingUsesLineFragmentOrigin
                                                attributes:@{NSFontAttributeName:pollingHoursFont} context:nil];
        snippetRect.size.height = ceil(snippetRect.size.height);
        snippetRect.size.width = ceil(snippetRect.size.width);

        snippetRect.origin.x = xPadding;
        snippetRect.origin.y = yPadding + titleLabelHeight;

        UILabel *snippetLabel = [[UILabel alloc] initWithFrame:snippetRect];
        snippetLabel.lineBreakMode = NSLineBreakByWordWrapping;
        snippetLabel.numberOfLines = 0;
        snippetLabel.font = [UIFont systemFontOfSize:10];
        snippetLabel.text = snippet;

        NSUInteger directionsButtonY = yPadding + titleLabelHeight + snippetRect.size.height;
        CGRect buttonFrame = CGRectMake(xPadding, directionsButtonY, labelWidth, directionsButtonHeight);
        UIButton *directionsButton = [UIButton buttonWithType:UIButtonTypeSystem];
        directionsButton.frame = buttonFrame;
        directionsButton.titleLabel.font = titleFont;
        [directionsButton setTitle:NSLocalizedString(@"Get Directions", nil)
                          forState:UIControlStateNormal];

        NSUInteger infoWindowHeight = yPadding + titleLabelHeight + snippetRect.size.height + directionsButtonHeight;
        self.frame = CGRectMake(0, 0, infoWindowWidth, infoWindowHeight);
        self.autoresizesSubviews = UIViewAutoresizingFlexibleHeight;
        self.opaque = YES;
        [self setBackgroundColor:[UIColor whiteColor]];
        self.layer.cornerRadius = 5.f;
        self.layer.borderColor = [VIPColor navBarBackgroundColor].CGColor;
        self.layer.borderWidth = 1.f;

        [self addSubview:titleLabel];
        [self addSubview:snippetLabel];
        [self addSubview:directionsButton];
    }
    return self;
}

@end

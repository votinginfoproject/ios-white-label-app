//
//  PollingInfoWindowView.m
//  VotingInformationProject
//
//  Created by Andrew Fink on 7/10/14.
//

#import "PollingInfoWindowView.h"

@interface PollingInfoWindowView()

@property (strong, nonatomic) PollingLocationWrapper *plWrapper;

@end

@implementation PollingInfoWindowView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
    andPollingLocationWrapper:(PollingLocationWrapper *)plWrapper
{
    self.plWrapper = plWrapper;
    return [self initWithFrame:frame];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end

//
//  PollingLocationCell.m
//  VotingInformationProject
//
//  Created by Bennet Huber on 3/10/14.
//

#import "PollingLocationCell.h"
#import "VIPAddress.h"
#import "VIPAddress+API.h"

@implementation PollingLocationCell {
    CLLocationCoordinate2D _mapOrigin;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
    if (self.onRowSelected) {
        self.onRowSelected(self);
    }
}

@end

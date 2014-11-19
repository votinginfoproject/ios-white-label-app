//
//  VIPFeedbackView.h
//  VotingInformationProject
//
//  Created by Andrew Fink on 11/18/14.
//

#import <UIKit/UIKit.h>

#define VIP_FEEDBACK_VIEW_HEIGHT 50
#define VIP_FEEDBACK_SEGUE @"FeedbackSegue"

@class VIPFeedbackView;

@protocol VIPFeedbackViewDelegate <NSObject>

-(void)sendFeedback:(VIPFeedbackView*)view;

@end

@interface VIPFeedbackView : UIView

@property (nonatomic, weak) id <VIPFeedbackViewDelegate> delegate;

+(instancetype)inView:(UIView *)view withDelegate:(id)delegate;

@end

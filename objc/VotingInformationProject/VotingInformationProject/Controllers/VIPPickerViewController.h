//
//  VIPPickerViewController.h
//  VotingInformationProject
//
//  Created by Tom Nelson on 3/7/16.
//  Copyright © 2016 The Pew Charitable Trusts. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VIPPickerViewController : UIViewController

@property (nonatomic, strong) UITextField *textField;

/**
 Creates a UIPickerViewController with the backing data, initial index, converter block if needed to extract a string for display 
 and a completion block for when the selection changes
 
 @param data The backing data for the picker
 
 @param index The index of the initial selection in the picker
 
 @param converter A block to convert the array element to a string, use nil if the data array is already strings
 
 @param completion A block to update the UI when the selection changes
 */

- (id) initWithData:(NSArray*)data
           selected:(NSInteger)index
          converter:(NSString *(^)(id object))converter
         completion:(void(^)(id))completion;
@end

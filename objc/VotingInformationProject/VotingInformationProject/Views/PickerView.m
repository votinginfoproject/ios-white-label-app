//
//  PickerView.m
//  VotingInformationProject
//
//  Created by Tom Nelson on 3/7/16.
//  Copyright © 2016 The Pew Charitable Trusts. All rights reserved.
//

#import "PickerView.h"

@interface PickerView() <
    UIPickerViewDelegate,
    UIPickerViewDataSource,
    UIGestureRecognizerDelegate
>

@property (nonatomic, weak) UIView *view;
@property (nonatomic, strong) NSArray *data;
@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic, strong) UIView *glassPane;
@property (nonatomic, strong) UITapGestureRecognizer *gestureRecognizer;
@property (copy) void (^onCompletion)(NSString *);
@property (copy) NSString *(^converter)(id object);

@end

@implementation PickerView
+ (id) initWithView:(UIView *)view
               data:(NSArray *)data
           selected:(NSInteger*)index
          converter:(NSString *(^)(id object))converter
         completion:(void(^)(id))completion
{
    PickerView *pickerView = [[PickerView alloc] init];
  
    pickerView.view = view;
    pickerView.data = data;
    pickerView.onCompletion = completion;
    pickerView.converter = converter;
  
    [pickerView initGlassPane];
    [pickerView initTextField];
    [pickerView initPicker:index];
    [pickerView.textField becomeFirstResponder];
  
    return pickerView;
}

- (void) initGlassPane {
    CGSize frameSize = _view.frame.size;
    _glassPane = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frameSize.width, frameSize.height)];
  
    _gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissPicker)];
    [_glassPane addGestureRecognizer:_gestureRecognizer];
    _gestureRecognizer.delegate = self;
  
    [self.view addSubview:self.glassPane];
}

- (void) initTextField {
    _textField = [[UITextField alloc] initWithFrame:CGRectZero];
    [_glassPane addSubview:_textField];
}

- (void) initPicker:(NSInteger*)index {
    _pickerView = [[UIPickerView alloc] init];
    _pickerView.delegate = self;
    _pickerView.dataSource = self;
  
    if (index!= nil && *index < [_data count]) {
        [_pickerView selectRow:*index inComponent:0 animated:YES];
    } else {
        [_pickerView selectRow:0 inComponent:0 animated:YES];
    }
  
    _textField.inputView = _pickerView;
}

- (void) dismissPicker {
    [_textField resignFirstResponder];
    [_glassPane removeFromSuperview];
}

// MARK:- PickerView delegates

- (NSInteger)numberOfComponentsInPickerView: (UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component {
    return [_data count];
}

- (void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    _onCompletion ([_data objectAtIndex:row]);
}

- (NSString *)pickerView: (UIPickerView *)pickerView
             titleForRow: (NSInteger)row
            forComponent: (NSInteger)component {
  
    if (_converter == nil){
        return [_data objectAtIndex:row];
    } else{
        return _converter ([_data objectAtIndex:row]);
    }
}
@end

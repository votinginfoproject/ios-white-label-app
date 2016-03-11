//
//  VIPPickerViewController.m
//  VotingInformationProject
//
//  Created by Tom Nelson on 3/7/16.
//  Copyright © 2016 The Pew Charitable Trusts. All rights reserved.
//

#import "VIPPickerViewController.h"

@interface VIPPickerViewController() <
    UIPickerViewDelegate,
    UIPickerViewDataSource,
    UIGestureRecognizerDelegate
>

@property (nonatomic, strong) NSArray *data;
@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic, strong) UIView *glassPane;
@property (nonatomic, strong) UITapGestureRecognizer *gestureRecognizer;
@property (nonatomic) NSInteger selectedIndex;
@property (copy) void (^onCompletion)(NSString *);
@property (copy) NSString *(^converter)(id object);

@end

@implementation VIPPickerViewController
+ (id) initWithData:(NSArray *)data
           selected:(NSInteger)index
          converter:(NSString *(^)(id object))converter
         completion:(void(^)(id))completion
{
    VIPPickerViewController *picker = [[VIPPickerViewController alloc] init];
    picker.data = data;
    picker.onCompletion = completion;
    picker.converter = converter;
    picker.selectedIndex = index;
  
    return picker;
}

- (void) viewDidLoad {
  [self initGlassPane];
  [self initTextField];
  [self initPicker:_selectedIndex];
}

- (void) initGlassPane
{
    _glassPane = [[UIView alloc] initWithFrame:self.view.bounds];
    _gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissPicker)];
    [_glassPane addGestureRecognizer:_gestureRecognizer];
    _gestureRecognizer.delegate = self;
  
    [self.view addSubview:self.glassPane];
}

- (void) initTextField
{
    [_glassPane addSubview:_textField];
}

- (void) initPicker:(NSInteger)index
{
    _pickerView = [[UIPickerView alloc] init];
  
    CGSize viewSize = self.view.bounds.size;
    CGFloat pickerHeight = _pickerView.bounds.size.height;
    CGRect pickerframe = CGRectMake(0, viewSize.height - pickerHeight, viewSize.width, pickerHeight);
  
    _pickerView.frame = pickerframe;
    _pickerView.backgroundColor = UIColor.whiteColor;
    _pickerView.delegate = self;
    _pickerView.dataSource = self;
  
    if (index < [_data count]) {
        [_pickerView selectRow:index inComponent:0 animated:YES];
    } else {
        [_pickerView selectRow:0 inComponent:0 animated:YES];
    }
  
    [_glassPane addSubview:(_pickerView)];
}

- (void) dismissPicker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

// MARK:- PickerView delegates

- (NSInteger)numberOfComponentsInPickerView: (UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component
{
    return [_data count];
}

- (void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    _onCompletion ([_data objectAtIndex:row]);
}

- (NSString *)pickerView: (UIPickerView *)pickerView
             titleForRow: (NSInteger)row
            forComponent: (NSInteger)component
{  
    if (_converter == nil){
        return [_data objectAtIndex:row];
    } else{
        return _converter ([_data objectAtIndex:row]);
    }
}

@end

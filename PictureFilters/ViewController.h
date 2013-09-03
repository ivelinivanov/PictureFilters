//
//  ViewController.h
//  PictureFilters
//
//  Created by Ivelin Ivanov on 9/2/13.
//  Copyright (c) 2013 MentorMate. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationBarDelegate, UIActionSheetDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) UIImage *originalImage;
@property (weak, nonatomic) IBOutlet UIButton *revertButton;

- (IBAction)revertToOriginal:(id)sender;

@end

//
//  ViewController.m
//  PictureFilters
//
//  Created by Ivelin Ivanov on 9/2/13.
//  Copyright (c) 2013 MentorMate. All rights reserved.
//

#import "ViewController.h"
#import "UIImage+Filters.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"Picture";
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithTitle:@"Add"
                                                                  style:UIBarButtonItemStylePlain
                                                                 target:self
                                                                 action:@selector(addButtonPressed)];
    
    UIBarButtonItem *filterButton = [[UIBarButtonItem alloc] initWithTitle:@"Apply filter"
                                                                     style:UIBarButtonItemStylePlain
                                                                    target:self
                                                                    action:@selector(applyFilter)];
    
    UIBarButtonItem *shareButton = [[UIBarButtonItem alloc] initWithTitle:@"Share"
                                                                    style:UIBarButtonItemStylePlain
                                                                   target:self
                                                                   action:@selector(shareButtonPressed)];
    
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:filterButton, nil];
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:addButton, shareButton, nil];
    
    
}

- (IBAction)addButtonPressed
{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    
    imagePicker.delegate = self;
    imagePicker.allowsEditing = YES;
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:imagePicker animated:YES completion:nil];
}

-(void)applyFilter
{
    if (self.imageView.image != nil)
    {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Filters"
                                                                 delegate:self
                                                        cancelButtonTitle:@"Cancel"
                                                   destructiveButtonTitle:nil
                                                        otherButtonTitles:@"Sepia", @"Monochrome", @"Invert", @"Posterize", @"Black 'n' White", nil];
        
        [actionSheet showFromBarButtonItem:self.navigationItem.rightBarButtonItem animated:YES];

    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning"
                                                        message:@"Can't apply a filter before you select an image."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles: nil];
    
        [alert show];
    }
}


- (IBAction)revertToOriginal:(id)sender
{
    self.imageView.image = self.originalImage;
}

-(IBAction)shareButtonPressed
{
    if (self.imageView.image != nil)
    {
        NSArray *activityItems = @[self.imageView.image];
        UIActivityViewController *activityController = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
        [self presentViewController:activityController animated:YES completion:nil];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning"
                                                        message:@"Can't share before you select an image."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles: nil];
        
        [alert show];
    }

}

#pragma mark - UIImagePicker delegate methods

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    
    self.imageView.image = image;
    self.originalImage = image;
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    self.revertButton.hidden = NO;
}

#pragma mark - UIactionSheet Delegate Methods

-(void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    
    switch (buttonIndex)
    {
        case 0:
            self.imageView.image = [self.originalImage applySepia];
            break;
        case 1:
            self.imageView.image = [self.originalImage applyMonochrome];
            break;
        case 2:
            self.imageView.image = [self.originalImage applyInvert];
            break;
        case 3:
            self.imageView.image = [self.originalImage applyPosterize];
            break;
        case 4:
            self.imageView.image = [self.originalImage applyBlackAndWhite];
            break;
        default:
            break;
    }
}

@end

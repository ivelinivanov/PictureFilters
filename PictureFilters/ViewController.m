//
//  ViewController.m
//  PictureFilters
//
//  Created by Ivelin Ivanov on 9/2/13.
//  Copyright (c) 2013 MentorMate. All rights reserved.
//

#import "ViewController.h"

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

#pragma mark - Filter applying methods

-(void)applySepia
{
    CIImage *beginImage = [CIImage imageWithData:UIImagePNGRepresentation(self.originalImage)];
    CIContext *context = [CIContext contextWithOptions:nil];
    
    CIFilter *filter = [CIFilter filterWithName:@"CISepiaTone" keysAndValues: kCIInputImageKey, beginImage, @"inputIntensity", [NSNumber numberWithFloat:0.8], nil];
    
    CIImage *outputImage = [filter outputImage];
    
    CGImageRef cgimg = [context createCGImage:outputImage fromRect:[outputImage extent]];
    UIImage *newImg = [UIImage imageWithCGImage:cgimg];
    
    self.imageView.image = newImg;
    
    CGImageRelease(cgimg);
}


-(void)applyMonochrome
{
    CIImage *beginImage = [CIImage imageWithData:UIImagePNGRepresentation(self.originalImage)];
    CIContext *context = [CIContext contextWithOptions:nil];
    
    CIFilter *filter = [CIFilter filterWithName:@"CIColorMonochrome" keysAndValues: kCIInputImageKey, beginImage, @"inputIntensity", [NSNumber numberWithFloat:0.8], nil];
    
    CIImage *outputImage = [filter outputImage];
    
    CGImageRef cgimg = [context createCGImage:outputImage fromRect:[outputImage extent]];
    UIImage *newImg = [UIImage imageWithCGImage:cgimg];
    
    self.imageView.image = newImg;
    
    CGImageRelease(cgimg);
}

-(void)applyInvert
{
    CIImage *ciImage = [CIImage imageWithData:UIImagePNGRepresentation(self.originalImage)];
    
    CIContext *context = [CIContext contextWithOptions:nil];
    
    CIFilter *filter = [CIFilter filterWithName:@"CIColorInvert"];
    
    [filter setDefaults];
    [filter setValue:ciImage forKey:@"inputImage"];
    CIImage *output = [filter valueForKey:@"outputImage"];
    
    CGImageRef cgimg = [context createCGImage:output fromRect:[output extent]];
    UIImage *newImg = [UIImage imageWithCGImage:cgimg];
    
    self.imageView.image = newImg;
    
    CGImageRelease(cgimg);
}

-(void)applyPosterize
{
    CIImage *beginImage = [CIImage imageWithData:UIImagePNGRepresentation(self.originalImage)];
    
    CIContext *context = [CIContext contextWithOptions:nil];
    
    CIFilter* posterize = [CIFilter filterWithName:@"CIColorPosterize"];
    [posterize setDefaults];
    [posterize setValue:[NSNumber numberWithDouble:8.0] forKey:@"inputLevels"];
    [posterize setValue:beginImage forKey:@"inputImage"];
    
    CIImage *outputImage = [posterize outputImage];
    
    CGImageRef cgimg = [context createCGImage:outputImage fromRect:[outputImage extent]];
    UIImage *newImg = [UIImage imageWithCGImage:cgimg];
    
    self.imageView.image = newImg;
    
    CGImageRelease(cgimg);
}


-(void)applyBlackAndWhite
{
    CGColorSpaceRef colorSapce = CGColorSpaceCreateDeviceGray();
    CGContextRef context = CGBitmapContextCreate(nil, self.originalImage.size.width, self.originalImage.size.height, 8, self.originalImage.size.width, colorSapce, kCGImageAlphaNone);
    
    CGContextSetInterpolationQuality(context, kCGInterpolationHigh);
    CGContextSetShouldAntialias(context, NO);
    CGContextDrawImage(context, CGRectMake(0, 0, self.originalImage.size.width, self.originalImage.size.height), [self.originalImage CGImage]);
    
    CGImageRef bwImage = CGBitmapContextCreateImage(context);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSapce);
    
    UIImage *resultImage = [UIImage imageWithCGImage:bwImage]; // This is result B/W image.
    
    self.imageView.image = resultImage;

    CGImageRelease(bwImage);
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
            [self applySepia];
            break;
        case 1:
            [self applyMonochrome];
            break;
        case 2:
            [self applyInvert];
            break;
        case 3:
            [self applyPosterize];
            break;
        case 4:
            [self applyBlackAndWhite];
            break;
        default:
            break;
    }
}

@end

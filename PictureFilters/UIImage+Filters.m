//
//  UIImage+Filters.m
//  PictureFilters
//
//  Created by Ivelin Ivanov on 9/4/13.
//  Copyright (c) 2013 MentorMate. All rights reserved.
//

#import "UIImage+Filters.h"

@implementation UIImage (Filters)

#pragma mark - Filter applying methods

-(UIImage *)applySepia
{
    CIImage *beginImage = [CIImage imageWithData:UIImagePNGRepresentation(self)];
    CIContext *context = [CIContext contextWithOptions:nil];
    
    CIFilter *filter = [CIFilter filterWithName:@"CISepiaTone" keysAndValues: kCIInputImageKey, beginImage, @"inputIntensity", [NSNumber numberWithFloat:0.8], nil];
    
    CIImage *outputImage = [filter outputImage];
    
    CGImageRef cgimg = [context createCGImage:outputImage fromRect:[outputImage extent]];
    UIImage *newImg = [UIImage imageWithCGImage:cgimg];
    
    CGImageRelease(cgimg);
    
    return newImg;
}


-(UIImage *)applyMonochrome
{
    CIImage *beginImage = [CIImage imageWithData:UIImagePNGRepresentation(self)];
    CIContext *context = [CIContext contextWithOptions:nil];
    
    CIFilter *filter = [CIFilter filterWithName:@"CIColorMonochrome" keysAndValues: kCIInputImageKey, beginImage, @"inputIntensity", [NSNumber numberWithFloat:0.8], nil];
    
    CIImage *outputImage = [filter outputImage];
    
    CGImageRef cgimg = [context createCGImage:outputImage fromRect:[outputImage extent]];
    UIImage *newImg = [UIImage imageWithCGImage:cgimg];
    
    CGImageRelease(cgimg);
    
    return newImg;
}

-(UIImage *)applyInvert
{
    CIImage *ciImage = [CIImage imageWithData:UIImagePNGRepresentation(self)];
    
    CIContext *context = [CIContext contextWithOptions:nil];
    
    CIFilter *filter = [CIFilter filterWithName:@"CIColorInvert"];
    
    [filter setDefaults];
    [filter setValue:ciImage forKey:@"inputImage"];
    CIImage *output = [filter valueForKey:@"outputImage"];
    
    CGImageRef cgimg = [context createCGImage:output fromRect:[output extent]];
    UIImage *newImg = [UIImage imageWithCGImage:cgimg];
    
    CGImageRelease(cgimg);
    
    return newImg;
}

-(UIImage *)applyPosterize
{
    CIImage *beginImage = [CIImage imageWithData:UIImagePNGRepresentation(self)];
    
    CIContext *context = [CIContext contextWithOptions:nil];
    
    CIFilter* posterize = [CIFilter filterWithName:@"CIColorPosterize"];
    [posterize setDefaults];
    [posterize setValue:[NSNumber numberWithDouble:8.0] forKey:@"inputLevels"];
    [posterize setValue:beginImage forKey:@"inputImage"];
    
    CIImage *outputImage = [posterize outputImage];
    
    CGImageRef cgimg = [context createCGImage:outputImage fromRect:[outputImage extent]];
    UIImage *newImg = [UIImage imageWithCGImage:cgimg];
    
    CGImageRelease(cgimg);
    
    return newImg;
}


-(UIImage *)applyBlackAndWhite
{
    CGColorSpaceRef colorSapce = CGColorSpaceCreateDeviceGray();
    CGContextRef context = CGBitmapContextCreate(nil, self.size.width, self.size.height, 8, self.size.width, colorSapce, kCGImageAlphaNone);
    
    CGContextSetInterpolationQuality(context, kCGInterpolationHigh);
    CGContextSetShouldAntialias(context, NO);
    CGContextDrawImage(context, CGRectMake(0, 0, self.size.width, self.size.height), [self CGImage]);
    
    CGImageRef bwImage = CGBitmapContextCreateImage(context);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSapce);
    
    UIImage *resultImage = [UIImage imageWithCGImage:bwImage]; // This is result B/W image.
    
    CGImageRelease(bwImage);
    
    return resultImage;
}


@end

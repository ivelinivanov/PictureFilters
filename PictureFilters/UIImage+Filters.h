//
//  UIImage+Filters.h
//  PictureFilters
//
//  Created by Ivelin Ivanov on 9/4/13.
//  Copyright (c) 2013 MentorMate. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Filters)

-(UIImage *)applySepia;
-(UIImage *)applyMonochrome;
-(UIImage *)applyInvert;
-(UIImage *)applyPosterize;
-(UIImage *)applyBlackAndWhite;

@end

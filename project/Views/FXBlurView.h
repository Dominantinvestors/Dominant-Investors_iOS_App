//
//  DMViewController.swift
//  Dominant Investors
//
//  Created by Nekit on 18.02.17.
//  Copyright © 2017 Dominant. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <Accelerate/Accelerate.h>

@interface UIImage (FXBlurView)

- (UIImage *)blurredImageWithRadius:(CGFloat)radius iterations:(NSUInteger)iterations tintColor:(UIColor *)tintColor;

@end


@interface FXBlurView : UIView

+ (void)setBlurEnabled:(BOOL)blurEnabled;
+ (void)setUpdatesEnabled;
+ (void)setUpdatesDisabled;

@property (nonatomic, getter = isBlurEnabled) BOOL blurEnabled;
@property (nonatomic, getter = isDynamic) BOOL dynamic;
@property (nonatomic, assign) NSUInteger iterations;
@property (nonatomic, assign) NSTimeInterval updateInterval;
@property (nonatomic, assign) CGFloat blurRadius;
@property (nonatomic, strong) UIColor *tintColor;
@property (nonatomic, weak) IBOutlet UIView *underlyingView;

- (void)updateAsynchronously:(BOOL)async completion:(void (^)(void))completion;

- (void)clearImage;

@end


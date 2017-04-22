//
//  DraggableView.m
//  DraggableView
//
//  Created by Anshad on 4/22/17.
//  Copyright © 2017 ANSHAD. All rights reserved.
//

#import "DraggableView.h"

@interface DraggableView ()

@property(nonatomic, strong) UIPanGestureRecognizer *panGestureRecognizer;
@property(nonatomic) CGPoint originPoint;

@end

@implementation DraggableView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self) return nil;
    
    self.panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(swipped:)];
    [self addGestureRecognizer:self.panGestureRecognizer];
    
    [self setupView];
    
    
    return self;
}


- (void)setupView
{
    
    self.backgroundColor = [UIColor redColor];
    self.layer.cornerRadius = 5;
    self.layer.shadowOffset = CGSizeMake(7, 7);
    self.layer.shadowRadius = 5;
    self.layer.shadowOpacity = 0.5;
}

- (void)swipped:(UIPanGestureRecognizer *)gestureRecognizer
{
    CGFloat xDistance = [gestureRecognizer translationInView:self].x;
    CGFloat yDistance = [gestureRecognizer translationInView:self].y;
    
    switch (gestureRecognizer.state) {
            
        case UIGestureRecognizerStateBegan:{
            self.originPoint = self.center;
            break;
        };
        case UIGestureRecognizerStateChanged:{
            CGFloat rotationStrength = MIN(xDistance / 320, 1);
            CGFloat rotationAngle = (CGFloat) (2*M_PI/16 * rotationStrength);
            CGFloat scaleStrength = 1 - fabs(rotationStrength) / 4;
            CGFloat scale = MAX(scaleStrength, 0.93);
            CGAffineTransform transform = CGAffineTransformMakeRotation(rotationAngle);
            CGAffineTransform scaleTransform = CGAffineTransformScale(transform, scale, scale);
            self.transform = scaleTransform;
            self.center = CGPointMake(self.originPoint.x + xDistance, self.originPoint.y + yDistance);
            
            break;
        };
        case UIGestureRecognizerStateEnded: {
            if (fabs(xDistance)>self.frame.size.width/2 ||fabs(yDistance)>self.frame.size.height) {
                [self removeDraggableView];
                
            }
            else{
                
                [self resetViewPositionAndTransformations];
            }
            break;
        };
        case UIGestureRecognizerStatePossible:break;
        case UIGestureRecognizerStateCancelled:break;
        case UIGestureRecognizerStateFailed:break;
    }
}


-(void)moveViewToRight{
    CGFloat xDistanceToMove = [UIScreen mainScreen].bounds.size.width;
    
    [UIView animateWithDuration:0.8 animations:^{
        self.center = CGPointMake(xDistanceToMove,self.originPoint.y );
        self.transform = CGAffineTransformMakeRotation(0);
    } completion:^(BOOL finished) {
        [self removeDraggableView];
    }];

}
-(void)moveViewToLeft{
    
    CGFloat xDistanceToMove = [UIScreen mainScreen].bounds.size.width;
    
    [UIView animateWithDuration:0.8 animations:^{
        self.center = CGPointMake(-xDistanceToMove,self.originPoint.y );
        self.transform = CGAffineTransformMakeRotation(0);
    } completion:^(BOOL finished) {
          [self removeDraggableView];
    }];
}

-(void)removeDraggableView{
    [self removeFromSuperview];
    [self.delegate didSwipeEnd];
}

- (void)resetViewPositionAndTransformations
{
    [UIView animateWithDuration:0.2
                     animations:^{
                         self.center = self.originPoint;
                         self.transform = CGAffineTransformMakeRotation(0);
                     }];
}

- (void)dealloc
{
    [self removeGestureRecognizer:self.panGestureRecognizer];
}


@end

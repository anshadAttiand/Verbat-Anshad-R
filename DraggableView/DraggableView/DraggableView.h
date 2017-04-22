//
//  DraggableView.h
//  DraggableView
//
//  Created by Anshad on 4/22/17.
//  Copyright © 2017 ANSHAD. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DraggableViewDelegates <NSObject>
-(void)didSwipeEnd;
@end

@interface DraggableView : UIView
-(void)moveViewToRight;
-(void)moveViewToLeft;
@property(weak,nonatomic)id<DraggableViewDelegates>delegate;

@end

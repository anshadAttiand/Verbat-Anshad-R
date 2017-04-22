//
//  ViewController.m
//  DraggableView
//
//  Created by Anshad on 4/21/17.
//  Copyright © 2017 ANSHAD. All rights reserved.
//

#import "ViewController.h"
#import "DraggableView.h"
@interface ViewController ()<DraggableViewDelegates>
@property (weak, nonatomic) IBOutlet UIView *draggableView;
@property (weak,nonatomic) DraggableView *topCard;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addCardsWithCount:5];
     self.topCard =  (DraggableView*)[[self.draggableView subviews]lastObject];

}


// adding cards to view
-(void)addCardsWithCount:(int)numberOfCards{
    DraggableView* cardView;
    int i=0;
    while (i<numberOfCards) {
      cardView   = [[DraggableView alloc]initWithFrame:CGRectMake(0, 0, self.draggableView.frame.size.width, self.draggableView.frame.size.height)];
        cardView.delegate = self;
        [self.draggableView addSubview:cardView];
        i++;
    }
    
    
}

#pragma mark - Button Actions

- (IBAction)swipeRightBtnClicked:(id)sender {
    
    [self.topCard moveViewToRight];
   
}
- (IBAction)swipeLeftBtnClicked:(id)sender {
    [self.topCard moveViewToLeft];
   
    
}

#pragma mark - DraggableView Delagate

-(void)didSwipeEnd{
    self.topCard =  (DraggableView*)[[self.draggableView subviews]lastObject];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end

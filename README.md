# Verbat-Anshad-R

Created a custom view named DraggableView for card like swipable views 

In DraggableView.h file added two methods for forcefull animations to left and right

-(void)moveViewToRight

-(void)moveViewToLeft

also added a custom delegate with a protocol method didSwipeEnd to notify controller about the card removel from superview

Gesture Handling
----------------

Added a UIPanGestureRecognizer to DraggableView with a selector method - (void)swipped:(UIPanGestureRecognizer *)gestureRecognizer

In - (void)swipped:(UIPanGestureRecognizer *)gestureRecognizer method 

calculated the translation distance using 

                 CGFloat xDistance = [gestureRecognizer translationInView:self].x;
                  CGFloat yDistance = [gestureRecognizer translationInView:self].y;
                  
Checked the UIPanGestureRecognizer.state using a switch case

 case UIGestureRecognizerStateBegan 
 
 keep the current center point of view in variable for further use
 
                    self.originPoint = self.center;
                    
 case UIGestureRecognizerStateChanged 
 
 calculated roation angle and scale factor using
 
                        CGFloat rotationStrength = MIN(xDistance / 320, 1);
                       CGFloat rotationAngle = (CGFloat) (2*M_PI/16 * rotationStrength);
                       CGFloat scaleStrength = 1 - fabs(rotationStrength) / 4;
                       CGFloat scale = MAX(scaleStrength, 0.93);
                       
   CGAffineTransform rotation and scaling applied using this values and change the view's center point
   
               self.center = CGPointMake(self.originPoint.x + xDistance, self.originPoint.y + yDistance);
               
case UIGestureRecognizerStateEnded

  Did a check for is gesture moved the card sufficient distance to remove it from  its superview if so removed it else reset the poitions back to center
  
       case UIGestureRecognizerStateEnded: {
            if (fabs(xDistance)>self.frame.size.width/2 ||fabs(yDistance)>self.frame.size.height) {
                [self removeDraggableView];
                
            }
            else{
                
                [self resetViewPositionAndTransformations];
            }
            break;
        };
    
 ButtonClick Handling
 ---------------------
 
 Added two methods for both swipe left and right 
 
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

 
 Other Methods 
 -------------
 
 1 removeDraggableView: method to remove view from its superview and notify this to viewcontroller using a delegate call
 
   
     -(void)removeDraggableView{
     [self removeFromSuperview];
     [self.delegate didSwipeEnd];
     }
 
2 resetViewPositionAndTransformations: Method to Reset the view back to center with an animation

     -(void)resetViewPositionAndTransformations
        {
        [UIView animateWithDuration:0.2
        animations:^{
        self.center = self.originPoint;
        self.transform = CGAffineTransformMakeRotation(0);
        }];
       }

UIPanGestureRecognizer also removed from view in dealloc method
 
 
 In Viewcontroller 
 
 Outlet for ParentView ,object of DraggableView named topCard are  added also make it conforms to DraggableViewDelegates
 
      @property (weak, nonatomic) IBOutlet UIView *draggableView;
      @property (weak,nonatomic) DraggableView *topCard;
 
  ViewDidLoad added the required cards by calling methos -(void)addCardsWithCount:(int)numberOfCards and find the topcard object from subviews array of parentview
    
      -(void)viewDidLoad {
        [super viewDidLoad];
        [self addCardsWithCount:5];
      self.topCard =  (DraggableView*)[[self.draggableView subviews]lastObject];
      }

 
 To add enough number of cards to view 
 
      -(void)addCardsWithCount:(int)numberOfCards{
       DraggableView* cardView;
     int i=0;
     while (i<numberOfCards) {
     cardView   = [[DraggableView alloc]initWithFrame:CGRectMake(0, 0, self.draggableView.frame.size.width,                 self.draggableView.frame.size.height)];
        cardView.delegate = self;
        [self.draggableView addSubview:cardView];
        i++;
     }
    
    
}
 
 Implimented the delegate and updated the topcard
 
     -(void)didSwipeEnd{
     self.topCard =  (DraggableView*)[[self.draggableView subviews]lastObject];
     }
 
 Button Actions
 
 called the appropriate methods of topCard object
 
       -(IBAction)swipeRightBtnClicked:(id)sender { 
        [self.topCard moveViewToRight];
        }
   
      -(IBAction)swipeLeftBtnClicked:(id)sender {
         [self.topCard moveViewToLeft];
          }
 
 
 
 
 
 
 
 
 
 
 
     

#import <UIKit/UIKit.h>

@class EHRevealViewController;
@protocol EHRevealViewControllerDelegate;

#pragma mark - EHRevealViewController Class

// Enum values for setFrontViewPosition:animated:
typedef enum
{
    // Front controller is removed from view. Animated transitioning from this state will cause the same
    // effect than animating from FrontViewPositionLeftSideMost. Use this instead of FrontViewPositionLeftSideMost when
    // you want to remove the front view controller view from the view hierarchy.
    FrontViewPositionLeftSideMostRemoved,
    
    // Left most position, front view is presented left-offseted by rightViewRevealWidth+rigthViewRevealOverdraw
    FrontViewPositionLeftSideMost,
    
    // Left position, front view is presented left-offseted by rightViewRevealWidth
    FrontViewPositionLeftSide,

    // Center position, rear view is hidden behind front controller
	FrontViewPositionLeft,
    
    // Right possition, front view is presented right-offseted by rearViewRevealWidth
	FrontViewPositionRight,
    
    // Right most possition, front view is presented right-offseted by rearViewRevealWidth+rearViewRevealOverdraw
	FrontViewPositionRightMost,
    
    // Front controller is removed from view. Animated transitioning from this state will cause the same
    // effect than animating from FrontViewPositionRightMost. Use this instead of FrontViewPositionRightMost when
    // you intent to remove the front controller view from the view hierarchy.
    FrontViewPositionRightMostRemoved,
    
} FrontViewPosition;


@interface EHRevealViewController : UIViewController

// Object instance init and rear view setting
- (id)initWithRearViewController:(UIViewController *)rearViewController frontViewController:(UIViewController *)frontViewController;

// Rear view controller, can be nil if not used
@property (nonatomic) UIViewController *rearViewController;
- (void)setRearViewController:(UIViewController *)rearViewController animated:(BOOL)animated;

// Optional right view controller, can be nil if not used
@property (nonatomic) UIViewController *rightViewController;
- (void)setRightViewController:(UIViewController *)rightViewController animated:(BOOL)animated;

// Front view controller, can be nil on initialization but must be supplied by the time the view is loaded
@property (nonatomic) UIViewController *frontViewController;
- (void)setFrontViewController:(UIViewController *)frontViewController animated:(BOOL)animated;

// Sets the frontViewController using a default set of chained animations consisting on moving the
// presented frontViewController to the right most possition, replacing it, and moving it back to the left position
- (void)pushFrontViewController:(UIViewController *)frontViewController animated:(BOOL)animated;

// Front view position, use this to set a particular position state on the controller
// On initialization it is set to FrontViewPositionLeft
@property (nonatomic) FrontViewPosition frontViewPosition;

// Chained animation of the frontViewController position. You can call it several times in a row to achieve
// any set of animations you wish. Animations will be chained and performed one after the other.
- (void)setFrontViewPosition:(FrontViewPosition)frontViewPosition animated:(BOOL)animated;

// Toogles the current state of the front controller between Left or Right and fully visible
// Use setFrontViewPosition to set a particular position
- (void)revealToggleAnimated:(BOOL)animated;
- (void)rightRevealToggleAnimated:(BOOL)animated; // <-- simetric implementation of the above for the rightViewController

// The following methods are meant to be directly connected to the action method of a button
// to perform user triggered postion change of the controller views. This is ussually added to a
// button on top left or right of the frontViewController
- (IBAction)revealToggle:(id)sender;
- (IBAction)rightRevealToggle:(id)sender; // <-- simetric implementation of the above for the rightViewController

// The following method will provide a panGestureRecognizer suitable to be added to any view
// in order to perform usual drag and swipe gestures to reveal the rear views. This is usually added to the top bar
// of a front controller, but it can be added to your frontViewController view or to the reveal controller view to provide full screen panning.
// By default, the panGestureRecognizer is added to the view containing the front controller view. To keep this default behavior
// you still need to call this method, just don't add it to any of your views. The default setup allows you to dissable
// user interactions on your controller views without affecting the recognizer.
- (UIPanGestureRecognizer*)panGestureRecognizer;

// The following method will provide a tapGestureRecognizer suitable to be added to any view on the frontController
// for concealing the rear views. By default no tap recognizer is created or added to any view, however if you call this method after
// the controller's view has been loaded the recognizer is added to the reveal controller's front container view.
// Thus, you can disable user interactions on your frontViewController view without affecting the tap recognizer.
- (UITapGestureRecognizer*)tapGestureRecognizer;

// The following properties are provided for further customization, they are set to default values on initialization,
// you should not generally have to set them

// Defines how much of the rear or right view is shown, default is 260. A negative value indicates that the reveal width should be
// computed by substracting the full front view width, so the revealed frontView width is constant.
@property (nonatomic) CGFloat rearViewRevealWidth;
@property (nonatomic) CGFloat rightViewRevealWidth; // <-- simetric implementation of the above for the rightViewController

// Defines how much of an overdraw can occur when dragging further than 'rearViewRevealWidth', default is 60.
@property (nonatomic) CGFloat rearViewRevealOverdraw;
@property (nonatomic) CGFloat rightViewRevealOverdraw;   // <-- simetric implementation of the above for the rightViewController

// Defines how much displacement is applied to the rear view when animating or dragging the front view, default is 40.
@property (nonatomic) CGFloat rearViewRevealDisplacement;
@property (nonatomic) CGFloat rightViewRevealDisplacement;

// Defines a width on the border of the view attached to the panGesturRecognizer where the gesture is allowed,
// default is 0 which means no restriction.
@property (nonatomic) CGFloat draggableBorderWidth;

// If YES (the default) the controller will bounce to the Left position when dragging further than 'rearViewRevealWidth'
@property (nonatomic) BOOL bounceBackOnOverdraw;
@property (nonatomic) BOOL bounceBackOnLeftOverdraw;

// If YES (default is NO) the controller will allow permanent dragging up to the rightMostPosition
@property (nonatomic) BOOL stableDragOnOverdraw;
@property (nonatomic) BOOL stableDragOnLeftOverdraw; // <-- simetric implementation of the above for the rightViewController

// If YES (default is NO) the front view controller will be ofsseted vertically by the height of a navigation bar.
// Use this on iOS7 when you add an instance of RevealViewController as a child of a UINavigationController (or another EHRevealViewController)
// and you want the front view controller to be presented below the navigation bar of its UINavigationController grand parent .
// The rearViewController will still appear full size and blurred behind the navigation bar of its UINavigationController grand parent
@property (nonatomic) BOOL presentFrontViewHierarchically;

// Velocity required for the controller to toggle its state based on a swipe movement, default is 300
@property (nonatomic) CGFloat quickFlickVelocity;

// Duration for the revealToggle animation, default is 0.25
@property (nonatomic) NSTimeInterval toggleAnimationDuration;

// Duration for animated replacement of view controllers
@property (nonatomic) NSTimeInterval replaceViewAnimationDuration;

// Defines the radius of the front view's shadow, default is 2.5f
@property (nonatomic) CGFloat frontViewShadowRadius;

// Defines the radius of the front view's shadow offset default is {0.0f,2.5f}
@property (nonatomic) CGSize frontViewShadowOffset;

//Defines the front view's shadow opacity, default is 1.0f
@property (nonatomic) CGFloat frontViewShadowOpacity;

// The class properly handles all the relevant calls to appearance methods on the contained controllers.
// Moreover you can assign a delegate to let the class inform you on positions and animation activity.

// Delegate
@property (nonatomic,weak) id<EHRevealViewControllerDelegate> delegate;

@end

#pragma mark - EHRevealViewControllerDelegate Protocol
typedef enum
{
    EHRevealControllerOperationReplaceRearController,
    EHRevealControllerOperationReplaceFrontController,
    EHRevealControllerOperationReplaceRightController,
    
} EHRevealControllerOperation;


@protocol EHRevealViewControllerDelegate<NSObject>

@optional

// The following delegate methods will be called before and after the front view moves to a position
- (void)revealController:(EHRevealViewController *)revealController willMoveToPosition:(FrontViewPosition)position;
- (void)revealController:(EHRevealViewController *)revealController didMoveToPosition:(FrontViewPosition)position;

// This will be called inside the reveal animation, thus you can use it to place your own code that will be animated in sync
- (void)revealController:(EHRevealViewController *)revealController animateToPosition:(FrontViewPosition)position;

// Implement this to return NO when you want the pan gesture recognizer to be ignored
- (BOOL)revealControllerPanGestureShouldBegin:(EHRevealViewController *)revealController;

// Implement this to return NO when you want the tap gesture recognizer to be ignored
- (BOOL)revealControllerTapGestureShouldBegin:(EHRevealViewController *)revealController;

// Implement this to return YES if you want this gesture recognizer to share touch events with the pan gesture
- (BOOL)revealController:(EHRevealViewController *)revealController
    panGestureRecognizerShouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer;

// Implement this to return YES if you want this gesture recognizer to share touch events with the tap gesture
- (BOOL)revealController:(EHRevealViewController *)revealController
    tapGestureRecognizerShouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer;

// Called when the gestureRecognizer began and ended
- (void)revealControllerPanGestureBegan:(EHRevealViewController *)revealController;
- (void)revealControllerPanGestureEnded:(EHRevealViewController *)revealController;

// The following methods provide a means to track the evolution of the gesture recognizer.
// The 'location' parameter is the X origin coordinate of the front view as the user drags it
// The 'progress' parameter is a positive value from 0 to 1 indicating the front view location relative to the
// rearRevealWidth or rightRevealWidth. 1 is fully revealed, dragging ocurring in the overDraw region will result in values above 1.
- (void)revealController:(EHRevealViewController *)revealController panGestureBeganFromLocation:(CGFloat)location progress:(CGFloat)progress;
- (void)revealController:(EHRevealViewController *)revealController panGestureMovedToLocation:(CGFloat)location progress:(CGFloat)progress;
- (void)revealController:(EHRevealViewController *)revealController panGestureEndedToLocation:(CGFloat)location progress:(CGFloat)progress;

// Notification of child controller replacement
- (void)revealController:(EHRevealViewController *)revealController willAddViewController:(UIViewController *)viewController
    forOperation:(EHRevealControllerOperation)operation animated:(BOOL)animated;
- (void)revealController:(EHRevealViewController *)revealController didAddViewController:(UIViewController *)viewController
    forOperation:(EHRevealControllerOperation)operation animated:(BOOL)animated;

// Support for custom transition animations while replacing child controllers
- (id<UIViewControllerAnimatedTransitioning>)revealController:(EHRevealViewController *)revealController
    animationControllerForOperation:(EHRevealControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC;


@end


#pragma mark - UIViewController(EHRevealViewController) Category

// We add a category of UIViewController to let childViewControllers easily access their parent EHRevealViewController
@interface UIViewController(EHRevealViewController)

- (EHRevealViewController*)revealViewController;

@end


// String identifiers to be applied to segues on a storyboard
extern NSString* const SWSegueRearIdentifier;
extern NSString* const SWSegueFrontIdentifier;
extern NSString* const SWSegueRightIdentifier;


// This will allow the class to be defined on a storyboard
#pragma mark - EHRevealViewControllerSegueSetController Classes

// Use this along with one of the segue identifiers to segue to the initial state
@interface EHRevealViewControllerSegueSetController : UIStoryboardSegue
@end


#pragma mark - EHRevealViewControllerSeguePushController Classes

// Use this to push a view controller
@interface EHRevealViewControllerSeguePushController : UIStoryboardSegue
@end


#pragma mark - EHRevealViewControllerSegue (Deprecated)

@interface EHRevealViewControllerSegue : UIStoryboardSegue     // DEPRECATED: USE EHRevealViewControllerSegueSetController instead
@property (nonatomic, strong) void(^performBlock)( EHRevealViewControllerSegue* segue, UIViewController* svc, UIViewController* dvc );
@end
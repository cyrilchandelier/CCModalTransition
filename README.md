CCModalTransition
=================

Extensible &amp; easy to use modal transitioning using UIViewControllerAnimatedTransitioning API

##Installation

There are two ways to use the library in your project:

1) Manually add the library files to your project

2) Using CocoaPods (this is not yet possible but will be)

```Ruby
pod 'CCModalTransition'
```

Import ```UIViewController+ModalTransition.h``` file in your project, .pch file is a good place if you want it to be available in all your projects.

##Usage

In the initializer of the view controller to be displayed modally, configure the modal transition style using a registered ModalTransitionType.

```
#pragma mark - Constructor
- (id)init
{
    if (self = [super initWithNibName:@"PopupViewController" bundle:nil])
    {
        /**
         * Here, you just need to use a CCModalTransition type
         * to be used when the view controller is displayed 
         * modally
         */
        self.modalTransitionStyle = ModalTransitionTypePopup;
    }
    
    return self;
}
```

Built-in types are :
- ModalTransitionTypePopup
- ModalTransitionTypeTopSliding

You can extend this list by registering new transition types (see "Register your own transition types" section)

##Register your own transition types
You can easily create custom transition types to extends this component capabilities in your project. To do that, you will need to create a new class extending ```CCModalTransition``` and implement the following methods :
```
- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext;
- (void)presentViewControllerWithContext:(id <UIViewControllerContextTransitioning>)transitionContext animated:(BOOL)animated;
- (void)dismissViewControllerWithContext:(id <UIViewControllerContextTransitioning>)transitionContext animated:(BOOL)animated;
```

Do not forget to declare an unique, integer typed, identifier, for instance using a macro:
```
#define MyCustomModalTransitionIdentifier   54321
```

You can then register the transition by using ```UIViewController+ModalTransition``` methods :
```
- (void)registerClass:(Class)transitionClass forTransitionType:(NSInteger)transitionType;
- (void)unregisterClassForTransitionType:(NSInteger)transitionType;
```

For example, in your **presenting** view controller (not *presented*!):
```
// Register transition
[self registerClass:[MyCustomModalTransition class] forType:MyCustomModalTransitionIdentifier];
```

The declared ```transitionType``` should be used when declaring modal transition style of your **presented** view controller:
```
self.modalTransitionStyle = MyCustomModalTransitionIdentifier;
```
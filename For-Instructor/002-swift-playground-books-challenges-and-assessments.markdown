## Swift Playground Books: Challenges and Assessments

Hey what's up everybody, this is Ray. In today's screencast, I'm going to show you how to add challenges for the user to complete into your playgrounds, and how to use assessments to check if they passed or failed. 

## Demo

I'm working on converting a chapter from iOS Animations by Tutorials into a Playground Book. So far, I have written the first page, which introduces the reader to the sample project, and displays that in a live view.

Now, I want to add a second page to the book, that gives readers a challenge: create their first animation. To do this, they'll move the label and text fields offscreen to the left, and then run an animation to make them animate to their current position.

Let's start with the code that moves the label and text fields offscreen to the left. Inside the view controller, we'll add a hook so we can call the user's code from the playground in the proper time in the view controller's lifecycle.

We'll define a closure we can call called SetupViews. It takes the main view, label, and text fields as parameters, and returns nothing. We'll then create a variable so the playground can set this to its own code.

```
public typealias SetupViews = (UIView, UILabel, UITextField, UITextField) -> Void
public var setupViews: SetupViews?
```

Next, we'll implement viewDidLayoutSubviews() and call this closure.

```
public override func viewDidLayoutSubviews() {
  super.viewDidLayoutSubviews()
  setupViews?(view, heading, username, password)
}
```

Let's try this out. I'll duplicate our current Playground page and add a page 2. I'll update the Chapter manifest to include this page, and temporarily I'll place it at the top so it loads first thing for testing.

```
Page2.playgroundpage
```

Now I'll open Contents.swift for this page and clear out everything. I'll import Playground Support, and UIKit, and load the view controller from the storyboard like we did before.

Now I'll write the setupViews method that the view controller will call during viewDidLayoutSubviews. It will place each of the labels just offscreen, by setting their centers to the negative of whatever their widths are, divided by two.

Finally, I'll set the closure on the view controller to this functoin, and set the live view to this view controller.

```
import PlaygroundSupport
import UIKit

let viewController = ViewController.loadFromStoryboard()
func setupViews(view: UIView, heading: UILabel, username: UITextField, password: UITextField) {
  heading.center.x = -heading.bounds.width/2
  username.center.x = -username.bounds.width/2
  password.center.x = -password.bounds.width/2
}

viewController.setupViews = setupViews
PlaygroundPage.current.liveView = viewController
```

I'll send this over to my iPad, and check it out: the views are now offscreen.

Now I need to repeat this idea so the user can write some code to animate everything back in. This should happen in viewDidAppear. 

Again, first we'll create a variable to store a closure for some code that will animate the views.

```
public typealias AnimateViews = (UIView, UILabel, UITextField, UITextField) -> Void
public var animateViews: AnimateViews?
```  

Then, in viewDidAppear(), we'll call this.

```
animateViews?(view, heading, username, password)
```

Back in Contents.swift, we'll write the function to animate the views back to the center of the screen.

```
func animateViews(view: UIView, heading: UILabel, username: UITextField, password: UITextField) {
  UIView.animate(withDuration: 0.5) {
    heading.center.x  = view.center.x
    username.center.x = view.center.x
    password.center.x = view.center.x
  }
}
```

Finally, we'll set animateViews to our new method.

```
viewController.animateViews = animateViews
```

I'll send this over to my iPad again, and now if I tap run my code, I see the views animate in. Cool!

## Interlude

At this point, our playground works, but it isn't very interactive. What is the user supposed to do?

This is where you can get creative and figure out how you can make a learning puzzle or challenge for the user. In this case, I think it would be cool if instead of just telling the user where to put the views to perform this animation, we leave it up to them.

To do this, I need to do three things:

1. Hide any unnecessary setup code from them.
2. Add some instructions for the user.
3. Take out certain code that we want them to figure out, and make those sections editable.
4. Add some code completion to make their lives a bit easier.

Let's try this out.

## Demo

First, let's hide any unncessary setup code from the user. To do this, we'll add //#-hidden code and //#-end-hidden-code tags around anything they don't need to worry about for learning purposes.

```
//#-hidden-code
import PlaygroundSupport
import UIKit

let viewController = ViewController.loadFromStoryboard()
func setupViews(view: UIView, heading: UILabel, username: UITextField, password: UITextField) {
//#-end-hidden-code
heading.center.x = -heading.bounds.width/2
username.center.x = -username.bounds.width/2
password.center.x = -password.bounds.width/2
//#-hidden-code
}
//#-end-hidden-code
//#-hidden-code
func animateViews(view: UIView, heading: UILabel, username: UITextField, password: UITextField) {
//#-end-hidden-code
UIView.animate(withDuration: 0.5) {
  heading.center.x  = view.center.x
  username.center.x = view.center.x
  password.center.x = view.center.x
}
//#-hidden-code
}

viewController.setupViews = setupViews
viewController.animateViews = animateViews
PlaygroundPage.current.liveView = viewController
//#-end-hidden-code
```

Second, we'll add some instructions to explain what the user should do. Rememer, to add instructions, just use the /*: and */ tags and put markdown in-between. I've written the instructions in advance to save some typing time, so I'll just paste them in here.

```
/*:
Your first task is to animate the form elements onto the screen when it first displays.

To do this, first set the center of each of your views so they are just offscreen to the left.
*/
```

```
/*:
To animate the title into view you call the **UIView** class method `animate(withDuration:animations:)`. The animation starts immediately and animates over half a second; you set the duration via the first method parameter in the code.

It’s as easy as that; all the changes you make to the view in the animations closure will be animated by UIKit.

Here, set the center of each of your views to the center of the screen.
*/
```

Third, we'll take out the positions for each of these views, and put 0s as placeholders. Then, we'll make them editable by using the /*#-editable-code*/ and /*#-end-editable-code*/ tags. If the Playground finds any of these inside your code sections, it assumes the rest is NOT editable.

```
heading.center.x =
  /*#-editable-code*/0/*#-end-editable-code*/
username.center.x =
  /*#-editable-code*/0/*#-end-editable-code*/
password.center.x =
  /*#-editable-code*/0/*#-end-editable-code*/
```

```
  heading.center.x  =
    /*#-editable-code*/0/*#-end-editable-code*/
  username.center.x =
    /*#-editable-code*/0/*#-end-editable-code*/
  password.center.x =
    /*#-editable-code*/0/*#-end-editable-code*/
```

Fourth, I don't know about you but I hate typing on an iPad. Anything to make that easier is much appreciated. Luckily, Playground Books allow you to have fine-grained control over the auto completion that is set up. We'll configure this to use the identifiers the user will need to solve this challenge.

To do this, we'll start by hiding all of the default code completion. Then, we'll configure the identifier namespace, which is used for any identifiers you want to show, like function nanes, punctuation, variables, and any other symbol. We'll set it to show a list of all the identifiers the user will need to solve this challenge.

```
//#-code-completion(everything, hide)
//#-code-completion(identifier, show, -, ., /, view, heading, username, password, center, bounds, width, x)
```

There are more namespaces besides everything and identifier - there's also keyword, literal, module, and more - check the Playground Book format reference for a full list.

By the way, I only need to set this once, and it stays in effect for all the snippets below where I add these lines. You could change the code completion later on in this file if you want.

That's it! Now I can AirDrop this to my iPad and I have a fully interactive challenge, with code completion.

## Interlude

At this point, we have an awesome challenge for our readers. Wouldn't it be cool if we could detect if they successfully complete the challenge or not? We could show them a congratulations message if they do, and offer them a hint if they don't.

Luckily, Playground Books has a cool feature built right in for this, called assessments, and it's pretty easy to use. Let's check it out!

## Demo

First, I'll open up ViewController.swift and create an enumeration that we'll use to track the user's progress. They can fail if they don't place their views offscreen at the right spot, they can fail if they don't animate their views back to the right spot, or they can be successful. 

We'll track the current status, and like before offer a hook that so we can notify the playground of the animation status.

```
public enum AnimationStatus {
  case failedViewsNotOffscreen
  case failedViewsNotBack
  case success
}
public var currentStatus: AnimationStatus = .success
public typealias ReportAnimationStatus = (AnimationStatus) -> Void
public var reportAnimationStatus: ReportAnimationStatus?
```

In viewDidLayoutSubviews(), we'll check to see if the user placed the views in the right spot, and set the status to failed if not.

```
if currentStatus == .success &&
  (heading.center.x != -heading.bounds.width/2 ||
  username.center.x != -username.bounds.width/2 ||
  password.center.x != -password.bounds.width/2) {
  currentStatus = .failedViewsNotOffscreen
}
```

In viewDidAppear(), we'll check to sese if the user animated the views back to the right spot, and set the status to failed if not. We'll wait for 0.5 seconds in a half-hearted attempt to match the timing of the animation, and call then call the reportAnimationStatus hook we set up.

```
if currentStatus == .success &&
  (heading.center.x != view.center.x ||
  username.center.x != view.center.x ||
  password.center.x != view.center.x) {
  currentStatus = .failedViewsNotBack
}

UIView.animate(withDuration: 0.5, animations: {
  // Placeholder to attempt to match animation
}, completion: { success in
  self.reportAnimationStatus?(self.currentStatus)
})
```

Back in Contents.swift, we'll write the method that the view controller will call to report status. In the case that the user fails, we want to show a hint. That is really easy in playgrounds - you just set PlaygroundPage.current.assessmentStatus.

You can provide either a fail or a pass case. We'll set it to fail, which allows us to prove an array of hints, and a solution that's hidden behind a spoiler tag.

We'll repeat this for the other failure case as well.

Finally for the success case, we'll use the pass case instead, which allows us to show a congratulations message. We'll also use Markdown to add a link to the next page, which you can access with the special @next URL.

```
func reportAnimationStatus(_ status: ViewController.AnimationStatus) {
  switch status {
    case .failedViewsNotOffscreen:
    PlaygroundPage.current.assessmentStatus = .fail(hints: ["To make each view just offscreen to the left, you will have to consider the width of each view's bounds."], solution: "The center of each view should be set to its `-bounds.width/2`.")
  case .failedViewsNotBack:
    PlaygroundPage.current.assessmentStatus = .fail(hints: ["To center each view in the center of the screen, you will have to consider the center of the parent view (`view`)."], solution: "The center of each view should be set to `view.center.x`.")
    case .success:
      PlaygroundPage.current.assessmentStatus = .pass(message: "### Great job \nYou've solved your first challenge! \n\n[**Next Page**](@next)")
  }
}
```

Finally, I need to remember to set the closure on the view controller.

```
viewController.reportAnimationStatus = reportAnimationStatus
```

That's it! I'll AirDrop this to my iPad, and if I try this and fail, I can access a hint for the step I'm stuck at. 

And if I try this and succeed, I get a congratulations message. Nice!

## Conclusion

Allright, that's everything I'd like to cover in this screencast.

At this point, you should understand how to add challenges for the user to complete into your playgrounds, and how to use assessments to check if they passed or failed.

So far, the live view only shows up when you tap Run My Code. But you may be wondering how you can get it to run permanently, like in Apple's Learn to Code playground. That is the subject of my next screencast.

Speaking of challenges, assessments, and tests, do you know why the teacher jumped into the pond? To test the waters. Allright - I'm out!
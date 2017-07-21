/*:
Your first task is to animate the form elements onto the screen when it first displays.

To do this, first set the center of each of your views so they are just offscreen to the left.
*/
//#-hidden-code
import PlaygroundSupport
import UIKit

let viewController = ViewController.loadFromStoryboard()
func setupViews(view: UIView, heading: UILabel, username: UITextField, password: UITextField) {
//#-end-hidden-code
//#-code-completion(everything, hide)
//#-code-completion(identifier, show, -, ., /, view, heading, username, password, center, bounds, width, x)
heading.center.x = /*#-editable-code*/0/*#-end-editable-code*/
username.center.x = /*#-editable-code*/0/*#-end-editable-code*/
password.center.x = /*#-editable-code*/0/*#-end-editable-code*/
//#-hidden-code
}
//#-end-hidden-code
/*:
To animate the title into view you call the **UIView** class method `animate(withDuration:animations:)`. The animation starts immediately and animates over half a second; you set the duration via the first method parameter in the code.

It’s as easy as that; all the changes you make to the view in the animations closure will be animated by UIKit.

Here, set the center of each of your views to the center of the screen.
*/
//#-hidden-code
func animateViews(view: UIView, heading: UILabel, username: UITextField, password: UITextField) {
//#-end-hidden-code
UIView.animate(withDuration:0.5) {
  heading.center.x = /*#-editable-code*/0/*#-end-editable-code*/
  username.center.x = /*#-editable-code*/0/*#-end-editable-code*/
  password.center.x = /*#-editable-code*/0/*#-end-editable-code*/
}
//#-hidden-code
}

func reportAnimationStatus(_ status: ViewController.AnimationStatus) {
  switch status {
    case .failedViewsNotOffscreen:
      PlaygroundPage.current.assessmentStatus = .fail(hints: ["To make each view just offscreen to the left, you will have to consider the width of each view's bounds."], solution: "The center of each view should be set to its `-bounds.view.width/2`.")
    case .failedViewsNotBack:
      PlaygroundPage.current.assessmentStatus = .fail(hints: ["To center each view in the middle of the screen, you will have to consider the center of the parent view ('view')."], solution: "The center of each view should be set to `view.center.x.`")
    case .success:
      PlaygroundPage.current.assessmentStatus = .pass(message: "### Great job \nYou've solved your first challenge! \n\n[**Next Page**](@next)")
  }
}

viewController.setupViews = setupViews
viewController.animateViews = animateViews
viewController.reportAnimationStatus = reportAnimationStatus
PlaygroundPage.current.liveView = viewController
//#-end-hidden-code

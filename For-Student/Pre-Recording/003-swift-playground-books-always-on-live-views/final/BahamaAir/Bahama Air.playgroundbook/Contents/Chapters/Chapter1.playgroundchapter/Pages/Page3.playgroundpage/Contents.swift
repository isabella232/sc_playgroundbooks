/*:
You can animate a view’s position and frame in order to make it grow, shrink, or move around as you did in the previous section. Here are the properties you can use to modify a view’s position and size:

* **bounds**: Animate this property to reposition the view’s content within the view’s frame.

* **frame**: Animate this property to move and/or scale the view.

* **center**: Animate this property when you want to move the view to a new location on screen.

Try animating the position and size of this view by changing the values below. Tap **Run My Code** to see your changes.
*/
//#-hidden-code
import PlaygroundSupport
import CoreGraphics
import Foundation
import UIKit

let page = PlaygroundPage.current
let proxy = page.liveView as? PlaygroundRemoteLiveViewProxy

func animateFrame(centerX: Double, centerY: Double, width: Double, height: Double) {
  proxy?.send(.dictionary([
    Constants.parameterCommandName: PlaygroundValue.string(Constants.commandNameAnimateFrameCenter),
    Constants.parameterCenterX: PlaygroundValue.floatingPoint(centerX),
    Constants.parameterCenterY: PlaygroundValue.floatingPoint(centerY),
    Constants.parameterWidth: PlaygroundValue.floatingPoint(width),
    Constants.parameterHeight: PlaygroundValue.floatingPoint(height)
  ]))
}
//#-end-hidden-code
animateFrame(centerX: /*#-editable-code*/200/*#-end-editable-code*/, /*#-editable-code*/centerY: 200/*#-end-editable-code*/, width: /*#-editable-code*/50/*#-end-editable-code*/, height: /*#-editable-code*/50/*#-end-editable-code*/)

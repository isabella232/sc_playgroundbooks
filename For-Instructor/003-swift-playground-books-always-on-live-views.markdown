## Swift Playground Books: Always-On Live Views

Hey what's up everybody, this is Ray. In today's screencast, I'm going to show you how you can add always-on live views to your Playground Books, and how you can pass messages between your Playgrounds and your Live Views. This will allow you to influence what's happening in your live view, by writing code in your playground.

You see this technique used quite heavily in Apple's Learn to Code Playground Book. They have a game running over on the right hand side, and you can make the character in the game move by writing code over on the left hand side. The nice thing about always-on-live views is it gives the users something fun and visual to enjoy as they write code, giving them some good motivation to keep learnign and experimenting.

## Demo

I have a project with a view controller that I want to use to demonstrate various types of iOS animations. Right now we're looking at animating the position and scale of a view, by animating its center and frame properties.

My idea is I'd like to display this in the live view of my Playground Book, except rather than have it only appear when you type Run My Code, it should always be running. Then, you should able to tweak the animation values on the left hand side in the Playground, and have it change the animation that is running in the live view to the right.

Let's start by getting this View Controller to show up in an always-on live view. To do this, I'll create a new page in my playground book, and I'll configure it in the manifest.

I'll clear out Contents.swift, and add a new file LiveView.swift. Then, in LiveView.swift, I'll add the code that I would have put in Contents.swift in the past, to create the View Controller and set it as the current page's live view.

```
import PlaygroundSupport

let viewController = AnimationViewController.loadFromStoryboard()
viewController.animationType = .positionScale(centerX: 20, centerY: 20, width: 300, height: 300)
PlaygroundPage.current.liveView = viewController
```

I'll AirDrop this over to my iPad, and nice - I see my animations.

By the way - if the animations jump around or seem strange to you, try terminating the Playgrounds app and restarting it.

## Interlude

At this point, we have a view controller running in an always-on live view, before we even tap Run My Code.

Now, we want to be able to affect the always-on live view from our playground. But there's one problem - we can't access the live view directly.

You can think of our playground code, and our live view as running in entirely differnet processes. The only way they can communicate is through a proxy class created by Apple: PlaygroundRemoteLiveViewProxy.

In your Playground, you get a PlaygroundRemoteLiveViewProxy and send messages to it - kinda like sending network packets across the wire.

Then, in your Live View - you implement PlaygroundLiveViewMessageHandler on your view controller, and receive these messages. 

In our case, we're going to send a message to change the target frame that the view is animating to. Let's take a look at how we do that.

The only thing you can send from a playground to a live view is a certain type called a PlaygroundValue. A PlaygroudnValue can contain an array, boolean, data, date, dictionary, floatingPoint, integer, or string.

So how can you use this to perform a command over on the other side? Well, one good way is to use a dictionary. You can have a key for the command name that specifies a sting with the command to perform. Then, you can include other keys for each parameter, with the value being the value you are passing across.

In our case, we will set up a command name for "animate the frame and center", with parameters for "centerX", "centerY", "width", and "height". Let's try it out.

## Demo

I'm going to create a new Swift File in my Xcode project called Constants.swift. Here I'll create constants for all of the keys in our dictionary, plus the command name I mentioned earlier.

```
import Foundation

public class Constants {

  // Parameters
  public static let parameterCommandName = "commandName"
  public static let parameterCenterX = "centerX"
  public static let parameterCenterY = "centerY"
  public static let parameterWidth = "width"
  public static let parameterHeight = "height"

  // Command names
  public static let commandNameAnimateFrameCenter = "animateFrameCenter"

}
```

Since I created a new file, I need to modify my PrepPlaygroundBook.sh to copy this over to the Playground Book.

```
cp "$SRCROOT/BahamaAirLoginScreen/Constants.swift" "$OUTPUT/Contents/Sources"
```

Back in AnimationViewController, I need to make the AnimationViewController implement PlaygroundLiveViewMessageHandler, to indicate I can process messages received from the Playground.

```
extension AnimationViewController: PlaygroundLiveViewMessageHandler {

}
```

Hm, I'm receiving an error here. To fix that, let me import the PlaygroundSupport module.

```
import PlaygroundSupport
```

Ack - I'm getting a "No such module" error. What gives?

## Interlude

It turns out the PlaygroundSupport module doesn't exist for iOS - just playgrounds - kinda makes sense.

But I'd like to be able to compile AnimationViewController.swift in my Xcode project, because it's really handy for testing it out. To do this, I need to use a mock version of PlaygroundSupport on the iOS side.

It turns out Lou Franco wrote a handy PlaygroundSupport mock that is perfect for this. I forked it and updated it for Swift 4, so let's use that.

## Demo

Lou's PlaygroundSupport mock uses Carthage, so you'll need that if you want to use it. I already have Carthage installed, so I'll just add the URL for my forked repository inside the Cartfile.

```
github "https://github.com/rwenderlich/PlaygroundSupportMock.git" "master"
```

Then I'll pull down and build the project with Carthage bootstrap.

Now that it's built, I need to add it to my project. 

  1. First I'll drag it to my Linked Frameworks and Libraries.
  2. Then I'll go to my Build Phases Tab and add a new Run SCript Phase.
  3. I'll set the commandto carthate's copy frameworks command

```
/usr/local/bin/carthage copy-frameworks
```
  
  4. I'll add the Playground Support framework to the input files

```
$(SRCROOT)/Carthage/Build/iOS/PlaygroundSupport.framework
```

  5. And I'll add the directory to copy it to to the output files

```
$(BUILT_PRODUCTS_DIR)/$(FRAMEWORKS_FOLDER_PATH)/PlaygroundSupport.framework
```

If I build and run again - now I get a different error, that it's not conforming to the protocol. Progress! I'll just click Fix to add the stubs.

We don't need to add anything for these first two methods, but they're here if you want to do something when the playground connection opens or closes.

The receive method is the most important one. Here we receive a PlaygroundValue from the other side.

PlaygroundValue is an emumeration, so I'll switch on it. As we dicsused earlier, I'm expecting a dictionary with everythign we need for this command.

The first thing I'll do is look to see if there is a value in the dictionary for the command name, which should be a string. If this isn't the case, I'll bail.

Next, I'll check to see if the command is animate frame and center. If it is, I'll look for the value of each of the other parameters, which are all floats in this case.

At this point, I have all of the data I need, so I can do whatever I need to do for this command. In this case, all I need to do is update the animation type on the view controller, and it will start animating with those values.

If the PlaygroundValue is anything but a dictionary, I'll return.

```
public func receive(_ message: PlaygroundValue) {
    switch message {
    case .dictionary(let dict):
      guard case let .string(command)? = dict[Constants.parameterCommandName] else {
        // Invalid command
        return
      }
      if command == Constants.commandNameAnimateFrameCenter {
        guard case let .floatingPoint(centerX)? = dict[Constants.parameterCenterX],
          case let .floatingPoint(centerY)? = dict[Constants.parameterCenterY],
          case let .floatingPoint(width)? = dict[Constants.parameterWidth],
          case let .floatingPoint(height)? = dict[Constants.parameterHeight] else {
          // Invalid command
          return
        }
        self.animationType = .positionScale(centerX: CGFloat(centerX), centerY: CGFloat(centerY), width: CGFloat(width), height: CGFloat(height))
      }
    default:
        return
    }
  }
```  

OK - that's it for the View Controller side. Back in Contents.swift, I'll start by adding some instructions for the user.

Then, I'll add a hidden code section, and import everything I need.

I'll get the current page, and cast the page's live view as a PlaygroundRemoteLiveViewProxy. Note that this is the only way I can communicate to the other side - I can't just cast it to the view controller and start calling methods, like we did when we created it in Contents.swift.

Now I'll create a helper method called animateFrame I'll use to wrap the proxy code.

It will just call send on the proxy, and now I need to create the PlaygroundValue I'm expecting on the other side, I just pass in all the keys and values, like I explained earlier.

At this point I'll end the hidden section, and add some code that the user can tweak to influence the animation.

```
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
```

That's it! I'll AirDrop this over to my iPad, and now when I type Run My Code, it sends a message across to the other side that influences the always-on live view. Nice!

## Conclusion

Allright, that's everything I'd like to cover in this screencast.

Just like we communicated from the Playground to the View Controller using PlaygroundRemoteLiveViewProxy and PlaygroundLiveViewMessageHandler, we can go back the other way with PlaygroundRemoteLiveViewProxyDelegate. 

If you watched this screencast and my other Playground Book screencasts, at this point you should have a solid understanding of how to make Playground Books. There are a few other things that you can do with Playground Books, like glossaries, key value stores, and copying code between pages, but you should be able to pick this up on your own reading Apple's Playground Books documentation. 

I'd love to see what you end up making with Swift Playground Books - please send anything cool you make my way so I can check it out. 

Speaking of books, do you know why books are afraid of their sequels? Because they always come after them. Allright - I'm out!
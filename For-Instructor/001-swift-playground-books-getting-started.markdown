## Swift Playground Books: Getting Started

Hey what's up everybody, this is Ray. In today's screencast, I'm going to show you how you can make your own Playground Books for the iPad.

Before we begin, let's review what Playground Books are, and take a look at the Playgrounds app on the iPad.

## Demo 1 - Playgrounds App (Scripted but Live recording)

[Delete any playgrounds in the playgrounds app except Learn To Code 1 and Tree, and restart Playgrounds app.]

Last year, Apple introduced a new app for the iPad called Playgrounds, that allows you to code in Swift right on your iPad.

The Playgrounds app supports two types of Playgrounds: the traditional Swift Playgrounds you know and love, like this example from the Swift Algorithm Club...

...and also a new format called Swift Playground Books, like this example called Learn to Code created by Apple.

Swift Playground books introduce many new features beyond traditional Playgrounds, such as:

  * chapters
  * hints and assessments
  * cut scenes
  * always-on live views
  * glossary
  
...and much more. 

## Interlude

In this screencast, I'm going to show you how to get started creating your own Playground Books. I'll show you how to take a View Controller from a real Xcode project, and easily use it as the live view in a Playground Book. 

... [TODO Whatever I end up showing here.]

## Demo 2 - Directory Structure (Scripted but Live recording)

Let's start by getting a "Hello, World" playground book running.

A Playground Book is simply a collection of Swift files, plists, and other resources in a particular directory format. I downloaded the Learn to Code playground book from Apple, and if you right click on the file and click "Show Package Contents", you can see inside.

The Contents folder is what you'll be creating. The Playgrounds App itself puts any changes to the source code that the user makes into the Edits folder.

Inside Contents, you need to add a plist called Manifest.plist. This contains some information like the Swift version you're using, the names of the chapters in your book, and even the icon to use for your playground book.

Inside PrivateResources, you can put any resources that the book might need, suchas its icon, or its asset catalogue. None of these can be accessed by the user directly - if you want that, you should use the optional PublicResources folder instead.

Sources contains any Swift files that you want any page in your book to be able to access. 

Chapters contians a playgroundchapter folder for each chapter. Each playgroundchapter contains another Manifest.plist file, that contains the name of the chapter, and the list of all the pages in that chapter. Each chapter can also have its own public and private resources.

There are two types of pages you can have in a Playground Book. The first is a playgroundpage. This contains five things:

  1. Another manifest plist with some information about this page, such as if the live view should be visible by default.
  2. Contents.swift, which contains the code and markup that should be in the playground to the left.
  3. LiveView.swift. This is an optoinal file that you use if you want to set up an always-on live view.
  4. Private and Public resources as usual.
  5. Sources for any source files that are specific to this page.

Another type of page you can add is a cutscenepage. This is pretty simple - its manifest file just points to an HTML page which is used to render the cutscene.

You could create this entire structure manually, but it's a bit tedious. 

```
https://github.com/raywenderlich/PlaygroundBookTemplate
```

To make the process easier, I've created this empty Playground Book template that's up-to-date with the latest version of Playground Books - version 3.0. 

Let's use this to create a simple Hello, World playground book. 

```
git clone https://github.com/raywenderlich/PlaygroundBookTemplate.git
```

I'll clone the empty PlaygroundBookTemplate repository, and Show Package Contents for the playground book. I can see that the basic directory structure is pre-created, and it has a single chapter, and a single page.

Let's see what this looks like in Playgrounds. I'll right click the playground, and choose my iPad. A few seconds later, I'll see the new Playground Book. I an open it, and see Hello Playground Book. 

## Interlude

Now that we have an empty starting point, let's create a real playground book.

For this screencast, we're going to take a chapter from our popular book iOS Animations by Tutorials by Marin Todorov, and start converting it into a Playground Book. Let's get started.

## Demo 4

The chapter we want to convert is Chapter 1 from iOS Animations by Tutorials, which covers how to create your first animation in iOS. 

In this screencast, we'll just be converting this first bit of the chapter, that introduces the starter project for the chapter: a login screen for a fictional airline called Bahama Air. Our goal is to explain the starter project, and show the user what it looks like right in the Playground Book's live view.

I downloaded the sample project from this chapter of iOS Animations by Tutorials, converted it to Swift 4, and this is what it looks like. I would like this view controller to appear as the live view in Playgrounds.

It's pretty easy to display a live view in Playgrounds. All you have to do is import the PlaygroundSupport module, and set PlaygroundPage.current.liveView to a view, or a view controller.

However, this particular view controller has two challenges: 
  
  1) It comes from a Storyboard, not raw code
  2) It uses assets in the Asset catalog.

Luckily, we can fix this. All we need to do is copy the compiled storyboard and asset catalogue over to the Playground Book, in the PrivateResources folder I showed you earlier. Personally I've found the easiest way to do this is to write a script.

Let's do that now - starting with getting everything we need into a single workspace to make it easy to manage.

First, I'll go to File\Save As Workspace and create a workspace in the same directory as my Xcode project.

Second, I'll copy my Empty.playgroundbook to my BahamaAir folder, and rename it to Bahama Air.playgroundbook. Whatever you name the file is what will appear in the Playgrounds app.

Third, I'll drag my Bahama Air playground book into my workspace. Because it's a workspace, I can navigate all of my files.

Fourth, I'll copy over a script I wrote to copy the appropriate files from my project over to the playground book, and add it to my workspace. You can see that it simply copies ViewController.swift over to Sources, and copies the compiled assets and storyboard over to PrivateResources.

Fifth, I'll configure the project to run this script every time I build the project. To do this, I'll go to BahamaAirLoginScreen\Build Phases, click the + button in the upper left, and select New Run Script Phase. I'll then enter in the path to my PrepPlaygroundBook script. I'll hit command=B just to make sure it compiles OK.

```
./PrepPlaygroundBook/PrepPlaygroundBook.sh
```

I can build the project, and cool - I see the files being copied over to the correct spot.

Sixth, I'll write some helper code to make it easy to load this view controller from a storyboard. It will load the Main storyboard, and then instantiate a view controller with the Storyboard ID set to ViewController.

```
public extension ViewController {
  class func loadFromStoryboard() -> ViewController {
    let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
    return storyboard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
  }
}
```

I'll also mark the class as public so I can access it from the Playground.

```
public class ViewController: UIViewController {
```

That means I have to update viewDidLoad, viewWillAppear, and viewDidAppear too.

```
override public func viewDidLoad() {
override public func viewWillAppear(_ animated: Bool) {
override public func viewDidAppear(_ animated: Bool) {  
```

Seventh, I need to remember to configure the view controller to use that Storyboard ID. So I'll open it up, selet the view controlleer, switch to the Identity Inspector, and set the Storyboard ID to ViewController.

Finally, when our Playground Book code runs, it will be using a module named Book_Sources. Effectively, that means the ViewController that we just copied over to Sources will be in the Book_Sources module. Therefore, we need to configure this project's Product Module name to match this so that when we build the storyboard, it references the ViewController class in the Book_Sources module. To do this, I'l go to Build Settings and set the Product Module Name to Book_Sources.

Eighth and finally, I'll write some code to configure the live view. To do this, I'll open Chpater 1\Page 1\Contents.swift, import the PlaygroundSupport module, and call the helper method I just wrote to load the view controller from the storyboard. Then, I'll set the live view to that view controller.

```
import PlaygroundSupport

let viewController = ViewController.loadFromStoryboard()
PlaygroundPage.current.liveView = viewController
```

This is stuff I don't want the user to see, so I'll wrap it in a hidden-code annotation.

```
//#-hidden-code
...
//#=end-hidden-code

Also, I'll add some markup to the top of the playground to explain what's going on. To do this, I simply open up a comment with /*: and end with */. In between, I can add any markdown I want.

```
/*:
*/
```

Now I'll paste some text that I copied from the chapter from iOS Aniations by Tutorials and modified slightly.

```
In this playground you’ll dip your toes into the bottomless sea of view animations. Don’t be misled by the playground's title, however — getting started with such a powerful and rich API means there’s a lot of interesting material to cover!

In this playground, you’ll learn how to do the following:

* Set the stage for a cool animation.
* Create move and fade animations.
* Adjust the animation easing.
* Reverse and repeat animations.

There’s a fair bit of material to get through, but I promise it will be a lot of fun. Are you up for the challenge?

Tap **Run My Code** on the right to see the login screen of a fictional airline app. The app doesn’t do much right now; it just shows a login form with a title, two text fields, and a big friendly button at the bottom.

The project is ready for you to jump in and shake things up a bit!
```

That's it! Now I can share the playground book to my iPad, open it up, and I see my markdown. If I tap Run My Code, I see the Bahama Air Login View Controller on the right. Nice!

## Closing

Allright, that's everything I'd like to cover in this screencast.

At this point, you should understand the basics of working with Playground Books, including how to take a view controller from an Xcode project, and use it as the live view in a Playground Book. 

There's a lot more to Playground Books - including the ability to assess success or failure, use "always on" live views, and more - and I'll be covering those in future screencasts.

Let's wrap things up with a question. Why did the chicken cross the playground? To get to the other slide. I'm out!
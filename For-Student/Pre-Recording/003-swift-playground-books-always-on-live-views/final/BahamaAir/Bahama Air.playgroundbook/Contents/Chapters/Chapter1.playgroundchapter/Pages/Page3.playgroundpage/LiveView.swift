import PlaygroundSupport

let viewController = AnimationViewController.loadFromStoryboard()
viewController.animationType = .positionScale(centerX: 20, centerY: 20, width: 300, height: 300)
PlaygroundPage.current.liveView = viewController

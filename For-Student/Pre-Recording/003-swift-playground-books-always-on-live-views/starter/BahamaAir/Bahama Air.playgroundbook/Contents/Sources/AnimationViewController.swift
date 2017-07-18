//
//  AnimationViewController.swift
//  BahamaAirLoginScreen
//
//  Created by Main Account on 7/16/17.
//  Copyright © 2017 Razeware LLC. All rights reserved.
//

import UIKit

public class AnimationViewController: UIViewController {

  @IBOutlet weak var panda: UIImageView!

  var isAnimating: Bool = false

  public enum AnimationType {
    case positionScale(centerX: CGFloat, centerY: CGFloat, width: CGFloat, height: CGFloat)
    case appearance(color: UIColor, alpha: CGFloat)
    case transform(transformData: Data)
  }
  static var testTransform: Data {
    get {
      let rotation = CGAffineTransform(rotationAngle: CGFloat(Double.pi) / 2)
      let translateUp = CGAffineTransform(translationX: 0, y: -200)
      let scaleUp = CGAffineTransform(scaleX: 1.5, y: 1.5)
      let transform = rotation.concatenating(scaleUp.concatenating(translateUp))
      return NSKeyedArchiver.archivedData(withRootObject: transform)
    }
  }
  public var animationType: AnimationType = .positionScale(centerX: 20, centerY: 20, width: 300, height: 300)
  //.positionScale(centerX: 20, centerY: 20, width: 300, height: 300)
  //.appearance(color: UIColor.green, alpha: 0.5)
  //.transform(transformData: testTransform)

  public override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
  }

  func animateFrameCenter(centerX: CGFloat, centerY: CGFloat, width: CGFloat, height: CGFloat) {

    panda.center.x = view.center.x
    panda.center.y = view.center.y
    let startFrame = self.panda.frame
    UIView.animate(withDuration: 0.5, delay: 0.25, options: [.curveEaseInOut],
      animations: {
        // Animate
        self.panda.center.x = centerX
        self.panda.center.y = centerY
        self.panda.frame.size.width = width
        self.panda.frame.size.height = height
      },
      completion: { finished in
        if (finished) {
          // Animate back
          UIView.animate(withDuration: 0.5, delay: 0.25, options: [.curveEaseInOut], animations: {
            self.panda.frame = startFrame
          }, completion: { finished in
            if (finished) {
              self.isAnimating = false
              self.animate()
            }
          })
        }
      }
    )
  }

  func animateColorAlpha(color: UIColor, alpha: CGFloat) {

    panda.center.x = view.center.x
    panda.center.y = view.center.y
    let startColor = panda.backgroundColor
    let startAlpha = panda.alpha
    UIView.animate(withDuration: 1.0, delay: 0.25, options: [.curveEaseInOut], animations: {
      self.panda.backgroundColor = color
      self.panda.alpha = alpha
    }) { finished in
      if (finished) {
        UIView.animate(withDuration: 1.0, delay: 0.25, options: [.curveEaseInOut], animations: {
          self.panda.backgroundColor = startColor
          self.panda.alpha = startAlpha
        }) { finished in
          if (finished) {
            self.isAnimating = false
            self.animate()
          }
        }
      }
    }
  }

  func animateTransform(transform: CGAffineTransform) {

    panda.center.x = view.center.x
    panda.center.y = view.center.y
    let startTransform = self.panda.transform
    UIView.animate(withDuration: 1.0, delay: 0.25, options: [.curveEaseInOut], animations: {
      self.panda.transform = transform
    }) { finished in
      if (finished) {
        UIView.animate(withDuration: 1.0, delay: 0.25, options: [.curveEaseInOut], animations: {
          self.panda.transform = startTransform
        }) { finished in
          if (finished) {
            self.isAnimating = false
            self.animate()
          }
        }
      }
    }
  }

  func animate() {
    if isAnimating { return }
    isAnimating = true

    switch animationType {
    case .positionScale(let centerX, let centerY, let width, let height):
      animateFrameCenter(centerX: centerX, centerY: centerY, width: width, height: height)
    case .appearance(let color, let alpha):
      animateColorAlpha(color: color, alpha: alpha)
    case .transform(let transformData):
      if let transform = NSKeyedUnarchiver.unarchiveObject(with: transformData) as? CGAffineTransform {
        animateTransform(transform: transform)
      }
    }
  }

  override public func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    self.animate()
  }
}

public extension AnimationViewController {
  class func loadFromStoryboard() -> AnimationViewController {
    let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
    return storyboard.instantiateViewController(withIdentifier: "AnimationViewController") as! AnimationViewController
  }
}

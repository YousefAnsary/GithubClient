//
//  UIView+Animations.swift
//  GithubClient
//
//  Created by Yousef on 4/7/21.
//

import UIKit

extension UIView {
    
    func zoomInAndOut(scale: CGFloat = 1.5) {
        
        UIView.animate(withDuration: 0.5, delay: 0.0, options: UIView.AnimationOptions.curveEaseIn, animations: {
            self.transform = CGAffineTransform.identity.scaledBy(x: scale, y: scale)
            
        }) { (finished) in
            UIView.animate(withDuration: 1, animations: {
                self.transform = CGAffineTransform.identity
            })
        }
        
    }
    
    func blink(enabled: Bool = true, duration: CFTimeInterval = 0.3, stopAfter: CFTimeInterval = 2, completion: (()-> Void)? = nil) {
        enabled ? (UIView.animate(withDuration: duration,
                                  delay: 0.0,
                                  options: [.curveEaseInOut, .autoreverse, .repeat],
                                  animations: { [weak self] in self?.alpha = 0.0 },
                                  completion: { [weak self] _ in self?.alpha = 1.0 })) : self.layer.removeAllAnimations()
        if !stopAfter.isEqual(to: 0.0) && enabled {
            DispatchQueue.main.asyncAfter(deadline: .now() + stopAfter) { [weak self] in
                self?.layer.removeAllAnimations()
                completion?()
            }
        }
    }
    
    func shake() {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.07
        animation.repeatCount = 4
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: self.center.x - 10, y: self.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: self.center.x + 10, y: self.center.y))
        
        self.layer.add(animation, forKey: "position")
    }
    
}

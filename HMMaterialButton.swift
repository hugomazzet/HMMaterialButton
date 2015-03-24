//
//  HMMaterialButton.swift
//
//  Created by hugo mazet on 15/03/2015.
//  Copyright (c) 2015 Hugo Mazet. All rights reserved.
//

import Foundation
import UIKit

protocol HMMaterialButtonDelegate : NSObjectProtocol
{
     func materialButtonTouchUpInside(button: HMMaterialButton)
}

class HMMaterialButton: UIButton
{
    private let ghostStartAlpha : CGFloat = 1
    private let ghostEndAlpha : CGFloat = 0.4
    private let ghostInAnimationDuration : NSTimeInterval = 0.4
    private let ghostOutAnimationDuration : NSTimeInterval = 0.2
    
    private var ghost: Ghost!
    private var isAnimationFinished = true
    private var isTouching = false
    
    var delegate: HMMaterialButtonDelegate?
    
    // MARK: - Init
    // ----------------------------------------------------------------------------------------------
    // Init Coder
    // ----------------------------------------------------------------------------------------------
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // ----------------------------------------------------------------------------------------------
    // Init
    // ----------------------------------------------------------------------------------------------
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        self.setup()
    }
    
    // ----------------------------------------------------------------------------------------------
    // Setup
    // ----------------------------------------------------------------------------------------------
    internal func setup()
    {
        self.clipsToBounds = true
        
        let tapGestureRecognizer: UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: "touchDown:")
        tapGestureRecognizer.minimumPressDuration = 0.001
        self.addGestureRecognizer(tapGestureRecognizer)
        
        self.ghost = Ghost(frame: CGRectMake(0, 0, 30, 30))
    }
    
    // ----------------------------------------------------------------------------------------------
    // Touch Down
    // ----------------------------------------------------------------------------------------------
    func touchDown(gestureRecognizer:UIGestureRecognizer)
    {
        if gestureRecognizer.state == UIGestureRecognizerState.Began
        {
            self.isTouching = true
            self.isAnimationFinished = false
            
            let point: CGPoint = gestureRecognizer.locationInView(self)
            
            self.ghost.frame = CGRectMake(0, 0, 30, 30)
            self.ghost.center = point
            self.addSubview(self.ghost)
            
            var radius: CGFloat = self.frame.size.width*2.5
            
            if self.frame.size.height > self.frame.size.width{
                radius = self.frame.size.height*2.5
            }
            
            UIView.animateWithDuration(self.ghostInAnimationDuration, animations: { () -> Void in
                
                self.ghost.frame.size.width = radius
                self.ghost.frame.size.height = radius
                self.ghost.center = point
                self.ghost.alpha = self.ghostEndAlpha
                
            }, completion: { (ended) -> Void in
                
                self.isAnimationFinished = true
                
                if !self.isTouching{
                   self.endedAnimation()
                }
            })
        }
        else if gestureRecognizer.state == UIGestureRecognizerState.Ended
        {
            self.isTouching = false
            self.delegate?.materialButtonTouchUpInside(self)
            
            if self.isAnimationFinished{
                self.endedAnimation()
            }
        }
    }
    
    // ----------------------------------------------------------------------------------------------
    // Ended Animation
    // ----------------------------------------------------------------------------------------------
    private func endedAnimation()
    {
        UIView.animateWithDuration(self.ghostOutAnimationDuration, animations: { () -> Void in
            
            self.ghost.alpha = 0
            
            }, completion: { (ended) -> Void in
                
                self.isAnimationFinished = true
                self.isTouching = false
                self.ghost.removeFromSuperview()
                self.ghost.alpha = self.ghostStartAlpha
        })

    }
}

// MARK: - Class Ghost
// ----------------------------------------------------------------------------------------------
// Class Ghost
// ----------------------------------------------------------------------------------------------
class Ghost: UIView
{
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clearColor()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func drawRect(rect: CGRect)
    {
        let context = UIGraphicsGetCurrentContext()
        
        // decide on radius
        let rad = CGRectGetWidth(rect)/2.5
        let endAngle = CGFloat(2*M_PI)
        
        // add the circle to the context
        CGContextAddArc(context, CGRectGetMidX(rect), CGRectGetMidY(rect), rad, 0, endAngle, 1)
        
        // set fill and stroke color
        CGContextSetFillColorWithColor(context,UIColor(white: 1, alpha: 0.6).CGColor)
        CGContextSetStrokeColorWithColor(context,UIColor(white: 1, alpha: 0).CGColor)
        
        // draw the path
        CGContextDrawPath(context, kCGPathFillStroke);
    }
}







//
//  BufferSlider.swift
//  Pods
//
//  Created by brianliu on 2016/2/22.
//
//

import UIKit

let padding:CGFloat = 2;

/// - Easily use
/// - Easily customize
/// - Drop-In replacement
/// - Supports **Objective-C** and **Swift**
/// - *@IBDesignable* class *BufferSlider*
/// - *@IBInspectable* property *bufferStartValue* (*Swift.Double*)
/// - 0.0 ~ 1.0
/// - *@IBInspectable* property *bufferEndValue* (*Swift.Double*)
/// - 0.1 ~ 1.0
/// - *@IBInspectable* property *borderColor* (*UIKit.UIColor*)
/// - *@IBInspectable* property *fillColor* (*UIKit.UIColor*)
/// - *@IBInspectable* property *borderWidth* (*Swift.Double*)
/// - *@IBInspectable* property *sliderHeight* (*Swift.Double*)
@IBDesignable public class BufferSlider: UISlider {
    ///0.0 ~ 1.0. @IBInspectable
    @IBInspectable public var bufferStartValue:Double = 0{
        didSet{
            if bufferStartValue < 0.0 {
                bufferStartValue = 0
            }
            if bufferStartValue > bufferEndValue {
                bufferStartValue = bufferEndValue
            }
            self.setNeedsDisplay()
        }
    }
    ///0.0 ~ 1.0. @IBInspectable
    @IBInspectable public var bufferEndValue:Double = 0{
        didSet{
            if bufferEndValue > 1.0 {
                bufferEndValue = 1
            }
            if bufferEndValue < bufferStartValue{
                bufferEndValue = bufferStartValue
            }
            self.setNeedsDisplay()
        }
    }
    
    ///fillColor property. @IBInspectable
    @IBInspectable public var borderColor:UIColor = UIColor.blackColor()
    
    ///fillColor property. @IBInspectable
    @IBInspectable public var fillColor:UIColor? = nil

    ///BorderWidth property. @IBInspectable
    @IBInspectable public var borderWidth: Double = 0.5 {
        didSet{
            if borderWidth < 0.5 {
                borderWidth = 0.5
            }
            self.setNeedsDisplay()
        }
    }
    
    ///Slider height property. @IBInspectable
    @IBInspectable public var sliderHeight: Double = 6 {
        didSet{
            if sliderHeight < 6 {
                sliderHeight = 6
            }
        }
    }
    ///Do not call this delegate mehtod directly. This is for hiding built-in slider drawing after iOS 7.0
    public override func trackRectForBounds(bounds: CGRect) -> CGRect {
        var result = super.trackRectForBounds(bounds)
        result.size.height = 0.01
        return result
    }
    
    ///Custom Drawing. Subclass and and override to suit you needs.
    public override func drawRect(rect: CGRect) {
        borderColor.set()
        let rect = CGRectInset(self.bounds, CGFloat(borderWidth)+padding, CGFloat(borderWidth))
        let height = sliderHeight.CGFloatValue
        let radius = height/2
        let sliderRect = CGRectMake(rect.origin.x, rect.origin.y + (rect.height/2-radius), rect.width, height)

        let path = UIBezierPath()
        path.addArcWithCenter(CGPointMake(sliderRect.origin.x + radius, sliderRect.origin.y+radius), radius: radius, startAngle: CGFloat(M_PI)/2, endAngle: -CGFloat(M_PI)/2, clockwise: true)
        path.addLineToPoint(CGPointMake(sliderRect.width-radius, sliderRect.origin.y))
        path.addArcWithCenter(CGPointMake(sliderRect.width-radius, sliderRect.origin.y+radius), radius: radius, startAngle: -CGFloat(M_PI)/2, endAngle: CGFloat(M_PI)/2, clockwise: true)
        path.addLineToPoint(CGPointMake(sliderRect.origin.x + radius, sliderRect.origin.y+height))
        
        borderColor.setStroke()
        path.lineWidth = borderWidth.CGFloatValue
        path.stroke()
        path.addClip()
        
        var fillHeight = sliderRect.size.height-borderWidth.CGFloatValue
        if fillHeight < 0 {
            fillHeight = 0
        }
        
        let fillRect = CGRectMake(
            sliderRect.origin.x + sliderRect.size.width*CGFloat(bufferStartValue),
            sliderRect.origin.y + borderWidth.CGFloatValue/2,
            sliderRect.size.width*CGFloat(bufferEndValue-bufferStartValue),
            fillHeight)
        if let color = fillColor { color.setFill() }
        else if let color = self.superview?.tintColor{ color.setFill()}
        else{ UIColor.redColor().setFill() }
        
        UIBezierPath(rect: fillRect).fill()
    }

}


extension Double{
    var CGFloatValue: CGFloat {
        return CGFloat(self)
    }
}

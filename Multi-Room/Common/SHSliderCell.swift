//
//  SHSliderCell.swift
//  Multi-Room
//
//  Created by Patrick Busch on 01.07.18.
//

import Cocoa

class SHSliderCell: NSSliderCell {

    var color: NSColor = NSColor.black
    
    private func currentTick() -> Int {
        
        guard let slider = controlView as? NSSlider, slider.numberOfTickMarks > 0, slider.doubleValue > 0 else {
            return 0
        }
        
        return Int((slider.maxValue / slider.doubleValue).rounded(.down))
    }
    
    override func drawTickMarks() {
        
        guard let slider = controlView as? NSSlider, slider.numberOfTickMarks > 0 else {
            return
        }
        
        let knobRect = self.knobRect(flipped: false)
        
//        let tickStrength: CGFloat = 2
        let longerSide: CGFloat = 8
        let shorterSide: CGFloat = 1
        
        if (slider.isVertical) {
            
            let horizontalInset: CGFloat = 1
            let verticalInset: CGFloat = knobRect.height / 2
            let drawRect = slider.bounds.insetBy(dx: horizontalInset, dy: verticalInset) //squish in slightly
            let step = drawRect.height/CGFloat(numberOfTickMarks - 1) //classic fenceposts problem
            var mark = CGFloat(0)
            for _ in 0..<numberOfTickMarks {
                let blob = NSBezierPath(roundedRect: NSRect(x: horizontalInset , y: mark + verticalInset, width: longerSide, height: shorterSide), xRadius: 0, yRadius: 0)
                self.color.set()
                blob.fill()
                self.color.set()
                blob.stroke()
                mark += step
            }
        } else {
            
            let horizontalInset: CGFloat = knobRect.width / 2
            let verticalInset: CGFloat = 1
            let drawRect = slider.bounds.insetBy(dx: horizontalInset, dy: verticalInset) //squish in slightly
            let step = drawRect.width/CGFloat(numberOfTickMarks - 1) //classic fenceposts problem
            var mark = CGFloat(0)
            for _ in 0..<numberOfTickMarks {
                let blob = NSBezierPath(roundedRect: NSRect(x: mark + horizontalInset , y:verticalInset, width: shorterSide, height: longerSide), xRadius: 0, yRadius: 0)
                self.color.set()
                blob.fill()
                self.color.set()
                blob.stroke()
                mark += step
            }
        }
    }
    
    override func drawBar(inside aRect: NSRect, flipped: Bool) {
        
        guard let slider = controlView as? NSSlider else {
            return
        }
        
        if (slider.isVertical) {
            var rect = aRect
            rect.size.width = CGFloat(5)
            let barRadius = CGFloat(0)
            let bg = NSBezierPath(roundedRect: rect, xRadius: barRadius, yRadius: barRadius)
            self.color.setFill()
            bg.fill()
        }
        else {
            var rect = aRect
            rect.size.height = CGFloat(5)
            let barRadius = CGFloat(0)
            let bg = NSBezierPath(roundedRect: rect, xRadius: barRadius, yRadius: barRadius)
            self.color.setFill()
            bg.fill()
        }
    }
}

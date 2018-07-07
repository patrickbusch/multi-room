//
//  SHSliderCell.swift
//  Multi-Room
//
//  Created by Patrick Busch on 01.07.18.
//

import Cocoa


class SHSlider: NSSlider {
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        createTickMarks()
        recolorTickMarks()
    }
    
    var inactiveColor: NSColor = NSColor.white {
        didSet {
            self.recolorTickMarks()
        }
    }
    var activeColor: NSColor = NSColor.black {
        didSet {
            self.recolorTickMarks()
        }
    }
    
    private var tickMarks: [NSView] = [NSView]()
    
    func recolorTickMarks() {
        
        guard self.tickMarks.count > 0 else {
            return
        }
        
        var tickMarksToColor: Int = 0
        
        if (self.doubleValue > 0) {
            var tickMarksToColorAsDouble: Double = self.doubleValue / self.maxValue * Double(self.tickMarks.count)
            
            tickMarksToColorAsDouble.round(FloatingPointRoundingRule.down)
            
            tickMarksToColor = Int(tickMarksToColorAsDouble)
        }
        
        for x in 0..<self.tickMarks.count {
            if (x <= tickMarksToColor) {
                self.tickMarks[x].backgroundColor = self.activeColor
            } else {
                self.tickMarks[x].backgroundColor = self.inactiveColor
            }
            
            
        }
        
    }
    
    private func createTickMarks() {
        
        for x  in 0..<self.numberOfTickMarks {
            
            let tickView = NSView()
            let tickRect = self.rectOfTickMark(at: x)
            if (self.isVertical) {
                tickView.frame = NSRect(x: tickRect.origin.x, y: tickRect.origin.y, width: tickRect.size.width, height: tickRect.size.height * 2)
            } else {
                tickView.frame = NSRect(x: tickRect.origin.x, y: tickRect.origin.y, width: tickRect.size.width * 2, height: tickRect.size.height)
            }

            
            tickView.translateOrigin(to: self.frame.origin)
            tickView.backgroundColor = NSColor.white
            tickMarks.append(tickView)
            
            self.addSubview(tickView, positioned: .below, relativeTo: nil)
        }
        
    }
}

class SHSliderCell: NSSliderCell {
    
    override func drawTickMarks() {
        
//        guard let slider = controlView as? NSSlider, slider.numberOfTickMarks > 0 else {
//            return
//        }
//
//        let knobRect = self.knobRect(flipped: false)
//
//        if (slider.isVertical) {
//
//            let width: CGFloat = slider.bounds.width / 4
//            let height: CGFloat = 2
//            let horizontalInset: CGFloat = 1
//            let verticalInset: CGFloat = knobRect.height / 2
//            let drawRect = slider.bounds.insetBy(dx: horizontalInset, dy: verticalInset) //squish in slightly
//            let step = drawRect.height/CGFloat(numberOfTickMarks - 1) //classic fenceposts problem
//            var mark = CGFloat(0)
//            for _ in 0..<numberOfTickMarks {
//                let blob = NSBezierPath(roundedRect: NSRect(x: horizontalInset , y: mark + verticalInset, width: width, height: height), xRadius: 0, yRadius: 0)
////                self.color.set()
//                NSColor.clear.set()
//                blob.fill()
////                self.color.set()
////                blob.stroke()
//                mark += step
//            }
//        } else {
//
//            let width: CGFloat = 2
//            let height: CGFloat = slider.bounds.height / 4
//            let horizontalInset: CGFloat = knobRect.width / 2
//            let verticalInset: CGFloat = 1
//            let drawRect = slider.bounds.insetBy(dx: horizontalInset, dy: verticalInset) //squish in slightly
//            let step = drawRect.width/CGFloat(numberOfTickMarks - 1) //classic fenceposts problem
//            var mark = CGFloat(0)
//            for _ in 0..<numberOfTickMarks {
//                let blob = NSBezierPath(roundedRect: NSRect(x: mark + horizontalInset , y:verticalInset, width: width, height: height), xRadius: 0, yRadius: 0)
////                self.color.set()
//                NSColor.clear.set()
//                blob.fill()
//
////                blob.stroke()
//                mark += step
//            }
//        }
        
    }
    
    override func drawBar(inside aRect: NSRect, flipped: Bool) {
        
//        guard let slider = controlView as? NSSlider else {
//            return
//        }
//        
//        if (slider.isVertical) {
//            var rect = aRect
//            rect.size.width = CGFloat(5)
//            let barRadius = CGFloat(0)
//            let bg = NSBezierPath(roundedRect: rect, xRadius: barRadius, yRadius: barRadius)
//            self.color.setFill()
//            bg.fill()
//        }
//        else {
//            var rect = aRect
//            rect.size.height = CGFloat(5)
//            let barRadius = CGFloat(0)
//            let bg = NSBezierPath(roundedRect: rect, xRadius: barRadius, yRadius: barRadius)
//            self.color.setFill()
//            bg.fill()
//        }
    }
}

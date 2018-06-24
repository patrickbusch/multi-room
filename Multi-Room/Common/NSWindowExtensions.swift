//
//  NSWindowExtensions.swift
//  Multi-Room
//
//  Created by Patrick Busch on 24.06.18.
//

import Cocoa

extension NSWindow {
    var titlebarHeight: CGFloat {
        let contentHeight = contentRect(forFrameRect: frame).height
        return frame.height - contentHeight
    }
}

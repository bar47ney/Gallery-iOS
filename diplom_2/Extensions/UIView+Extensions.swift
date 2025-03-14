//
//  UIView+Extensions.swift
//  lesson_14
//
//

import UIKit

extension UIView {
    func roundCorners(radius: CGFloat = 16) {
        layer.cornerRadius = radius
    }

    func dropShadow(
        color: UIColor? = .black, opacity: Float = 1, radius: CGFloat = 10,
        width: CGFloat = 0, height: CGFloat = 0
    ) {
        layer.masksToBounds = false
        layer.shadowColor = color?.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = CGSize(width: width, height: height)
        layer.shadowRadius = radius

        layer.shadowPath = UIBezierPath(rect: bounds).cgPath
        layer.shouldRasterize = true
    }
    
    func addGradient () {
        let gradient  = CAGradientLayer()
        gradient.colors = [
            UIColor.red.cgColor,
            UIColor.green.cgColor,
            UIColor.blue.cgColor
        ]
        gradient.startPoint = CGPoint(x: 1, y: 0)
        gradient.endPoint = CGPoint(x: 0, y: 1)
        
        gradient.frame = bounds
        layer.insertSublayer(gradient, at: 0)
    }
}

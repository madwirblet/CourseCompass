//
//  ProgressBar.swift
//  Classort
//
//  Created by Devin Wylde on 11/29/23.
//

import UIKit

class ProgressBar: UIView {
    var bar: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        view.translatesAutoresizingMaskIntoConstraints = true
        view.clipsToBounds = true
        return view
    }()
    
    private var barGradient: CAGradientLayer = {
            let gradientLayer = CAGradientLayer()
            gradientLayer.colors = [CGColor(red: 0.6, green: 0.94, blue: 0.4, alpha: 1), CGColor(red: 0.4, green: 0.94, blue: 0.4, alpha: 1), CGColor(red: 0.4, green: 0.94, blue: 0.6, alpha: 1)]
            gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
            gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
            return gradientLayer
        }()
    
    var progress: Int = 0
    var threshold: Int = 1
    
    var foregroundColor: UIColor? {
        didSet {
//            bar.backgroundColor = foregroundColor
//            setNeedsLayout()
        }
    }
    override var frame: CGRect {
        didSet {
            bar.height = frame.height
            bar.width = frame.width * (Double(progress) / Double(threshold))
            barGradient.frame = CGRect(x: 0, y: 0, width: width, height: height)
            setNeedsLayout()
        }
    }
    
    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        addSubview(bar)
        bar.layer.addSublayer(barGradient)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        UIView.animate(withDuration: 0.1) {
            self.bar.width = self.width * (Double(self.progress) / Double(self.threshold))
        }
    }
    
    func increment(count: Int) {
        progress += count
        setNeedsLayout()
    }
    
    func set(count: Int) {
        progress = count
        setNeedsLayout()
    }
}

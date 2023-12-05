//
//  ImageSelectButton.swift
//  Classort
//
//  Created by Devin Wylde on 12/2/23.
//

import UIKit

class ImagedButton: UIButton {
    var iconView: UIImageView!
    var cEnabled: Bool = false
    
    func disable() {
        cEnabled = false
        updateIconView()
    }
    
    func enable() {
        cEnabled = true
        updateIconView()
    }
    
    func isCEnabled() -> Bool {
        return cEnabled
    }
    
    func updateIconView() {
        if let iconView = iconView {
            iconView.removeFromSuperview()
        }
        
        let iconSize = CGSize(width: UIScreen.main.bounds.height / 42.6, height: UIScreen.main.bounds.height / 42.6)
        let iconX = bounds.width * 0.08
        
        if cEnabled {
            let iconFrame = CGRect(origin: CGPoint(x: iconX, y: (bounds.height - iconSize.height) / 2), size: iconSize)
            iconView = UIImageView(frame: iconFrame)
            iconView.contentMode = .scaleAspectFit
            iconView.image = iconImage()
            addSubview(iconView)
        }
        
        let titleX = iconX + iconSize.width + bounds.width * 0.05
        titleLabel?.frame.origin.x = titleX
        titleLabel?.font = UIFont(name: "KohinoorTelugu-Regular", size: height * 0.5)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        updateIconView()
        
    }
    
    func iconImage() -> UIImage? {
        return nil
    }
}

class CheckmarkButton: ImagedButton {
    public var activeFunction: ((Course) -> Bool)
    
    init(activeFunction: @escaping (Course) -> Bool) {
        self.activeFunction = activeFunction
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func clicked(list: inout [CheckmarkButton]) {
        if !cEnabled {
            for btn in list {
                if btn != self {
                    btn.disable()
                }
            }
            
            cEnabled = true
        }
    }
    
    override func iconImage() -> UIImage? {
        return UIImage(named: "checkmark")?.withTintColor(.white)
    }
}

class ArrowButton: ImagedButton {
    var activeFunctions: (() -> Void, () -> Void)
    var reverse: () -> Void
    var pEnabled: Bool = false
    var cDirection: Bool = false
    var pDirection: Bool = false
    
    func setDisabled() {
        pEnabled = false
        disable()
    }
    
    func setEnabled() {
        pEnabled = true
        enable()
    }
    
    init(activeFunctions: (() -> Void, () -> Void), reverse: @escaping () -> Void) {
        self.activeFunctions = activeFunctions
        self.reverse = reverse
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func clicked(list: inout [ArrowButton]) {
        if !cEnabled {
            for btn in list {
                if btn != self {
                    btn.disable()
                }
            }
            
            cEnabled = true
            cDirection = false
        } else {
            cDirection = !cDirection
        }
    }
    
    override func iconImage() -> UIImage? {
        return cDirection ? UIImage(named: "downarrow")?.withTintColor(.white) : UIImage(named: "uparrow")?.withTintColor(.white)
    }
    
    func activate() {
        if cEnabled && !pEnabled {
            if cDirection {
                activeFunctions.1()
            } else {
                activeFunctions.0()
            }
        } else if cEnabled && pDirection != cDirection {
            reverse()
        }
        pEnabled = cEnabled
        pDirection = cDirection
    }
}

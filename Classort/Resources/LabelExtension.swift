//
//  LabelExtension.swift
//  Classort
//
//  Created by Devin Wylde on 12/2/23.
//

import UIKit

extension UILabel {
    
    func fadeTextChange(to: String) {
        UIView.animate(withDuration: 0.32) {
            self.layer.opacity = 0
        } completion: { _ in
            self.text = to
            UIView.animate(withDuration: 0.32) {
                self.layer.opacity = 1
            }
        }
    }
    
}

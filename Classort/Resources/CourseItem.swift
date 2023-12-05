//
//  CourseItem.swift
//  Classort
//
//  Created by Devin Wylde on 11/29/23.
//

import UIKit

class CourseItem: UICollectionViewCell {
    // title: 7%
    // other: 5%
    private let colorScale = [UIColor(red: 0.94, green: 0.4, blue: 0.4, alpha: 1), UIColor(red: 0.94, green: 0.7, blue: 0.4, alpha: 1), UIColor(red: 0.94, green: 0.92, blue: 0.4, alpha: 1), UIColor(red: 0.84, green: 0.94, blue: 0.4, alpha: 1), UIColor(red: 0.4, green: 0.94, blue: 0.42, alpha: 1)]
    
    private let titleL: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 0.44, green: 0.44, blue: 0.44, alpha: 1)
        return label
    }()
    
    var code: String!
    var name: String!
    
    private let codeL: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 0.44, green: 0.44, blue: 0.44, alpha: 1)
        return label
    }()
    
    private let instructorL: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 0.44, green: 0.44, blue: 0.44, alpha: 1)
        return label
    }()
    
    private let ratingL: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
        label.textAlignment = .center
        return label
    }()
    
    func configure(title: String, code: String, instructor: String, rating: String, color: UIColor) {
        self.code = code
        self.name = title
        backgroundColor = color
        
        titleL.text = title
        codeL.text = code
        instructorL.text = "Instructor: " + instructor
        ratingL.text = rating
        
        if let rint = Int(rating), rint > 0 && rint < 6 {
            ratingL.backgroundColor = colorScale[rint - 1]
        } else {
            ratingL.backgroundColor = UIColor(white: 0.8, alpha: 1)
        }
        
        addSubview(titleL)
        addSubview(codeL)
        addSubview(instructorL)
        addSubview(ratingL)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = width * 0.02
        
        titleL.font = UIFont(name: "KohinoorTelugu-Regular", size: width * 0.064)
        codeL.font = UIFont(name: "KohinoorTelugu-Regular", size: width * 0.05)
        instructorL.font = UIFont(name: "KohinoorTelugu-Regular", size: width * 0.05)
        ratingL.font = UIFont(name: "KohinoorTelugu-Regular", size: width * 0.03)
        
        titleL.frame = CGRect(x: width * 0.033, y: width * 0.033, width: width * 0.867, height: width * 0.1)
        codeL.frame = CGRect(x: width * 0.033, y: width * 0.133, width: width * 0.867, height: width * 0.067)
        
        instructorL.sizeToFit()
        instructorL.left = width * 0.9 - instructorL.width
        instructorL.top = height * 0.75
        
        ratingL.frame = CGRect(x: width * 0.925, y: 0, width: width * 0.05, height: width * 0.05)
        ratingL.center.y = instructorL.center.y
        ratingL.layer.cornerRadius = width * 0.025 // doesnt work
    }
    
    func setRating(rating: String) {
        ratingL.text = rating
        
        if let rint = Double(rating), rint > 0 {
            ratingL.backgroundColor = UIColor(hue: (rint - 1) / 12, saturation: 1, brightness: 1, alpha: 1)
        } else {
            ratingL.backgroundColor = UIColor(white: 0.8, alpha: 1)
        }
        
        setNeedsLayout()
    }
}

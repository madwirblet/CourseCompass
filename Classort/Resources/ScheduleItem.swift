//
//  ScheduleItem.swift
//  Classort
//
//  Created by Devin Wylde on 12/3/23.
//

import UIKit

class ScheduleItem: UICollectionViewCell {
    var schedule: Schedule!
    var labels: [[UILabel]] = []
    var rowRange: ClosedRange<Int>!
    var liked: Bool = false
    
    let courseColors: [UIColor] = [
        UIColor(red: 255/255, green: 223/255, blue: 186/255, alpha: 1.0),
        UIColor(red: 244/255, green: 188/255, blue: 198/255, alpha: 1.0),
        UIColor(red: 173/255, green: 216/255, blue: 230/255, alpha: 1.0),
        UIColor(red: 244/255, green: 222/255, blue: 205/255, alpha: 1.0),
        UIColor(red: 230/255, green: 230/255, blue: 250/255, alpha: 1.0),
        UIColor(red: 144/255, green: 238/255, blue: 144/255, alpha: 1.0),
        UIColor(red: 255/255, green: 182/255, blue: 193/255, alpha: 1.0),
        UIColor(red: 255/255, green: 228/255, blue: 196/255, alpha: 1.0),
        UIColor(red: 240/255, green: 128/255, blue: 128/255, alpha: 1.0),
        UIColor(red: 175/255, green: 238/255, blue: 238/255, alpha: 1.0)
    ]
    
    let heart: UIImageView = {
        let view = UIImageView()
        view.isUserInteractionEnabled = true
        view.image = UIImage(named: "heart")?.withTintColor(.white)
        return view
    }()
    
    let info: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .right
        return label
    }()
    
    func configure(schedule: Schedule) {
        for c in subviews {
            c.removeFromSuperview()
        }
        labels = []
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(like))
        heart.addGestureRecognizer(tapGesture)
        addSubview(heart)
        
        if savedSchedules.contains(where: { $0 == schedule }) {
            heart.image = UIImage(named: "heart_filled")?.withTintColor(.white)
            liked = true
        }
        
        if schedule.credits == schedule.creditsMax {
            info.text = "Classes: \(schedule.classes.count) • Credits: \(schedule.credits) • Rating: \(String(format: "%.1f", schedule.rating))"
        } else {
            info.text = "Classes: \(schedule.classes.count) • Credits: \(schedule.credits)-\(schedule.creditsMax) • Rating: \(String(format: "%.1f", schedule.rating))"
        }
        addSubview(info)
        
        self.schedule = schedule
        self.rowRange = schedule.rowStart...schedule.rowEnd
        
        generateLabels()
        setNeedsLayout()
    }
    
    @objc func like() {
        liked = !liked
        
        let img = liked ? "heart_filled" : "heart"
        
        UIView.transition(with: heart, duration: 0.05, options: .transitionCrossDissolve) {
            self.heart.image = UIImage(named: img)?.withTintColor(.white)
        }
        
        if liked {
            savedSchedules.append(schedule)
        } else {
            if let index = savedSchedules.firstIndex(where: { $0 == schedule }) {
                savedSchedules.remove(at: index)
            }
        }
    }
    
    func newLabel() -> UILabel {
        let label = UILabel()
        label.clipsToBounds = true
        label.textAlignment = .center
        label.layer.borderWidth = 1.0
        label.layer.cornerRadius = 4.0
        label.layer.borderColor = UIColor.black.cgColor
        label.backgroundColor = .white
        label.textColor = .black
        return label
    }
    
    func generateLabels() {
        labels.append([])
        for i in 0..<6 {
            let label = newLabel()
            label.text = ["", "M", "T", "W", "R", "F"][i]
            addSubview(label)
            labels[0].append(label)
        }
        
        for row in rowRange {
            labels.append([])
            for col in 0..<6 {
                let label = newLabel()
                
                if col == 0 {
                    label.text = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "E1", "E2", "E3"][row]
                } else if let info = schedule.blocks[(row * 5) + col-1], let cIdx: Int = schedule.classes.firstIndex(where: {$0 == info}) {
                    label.backgroundColor = courseColors[cIdx % courseColors.count]
                    label.text = info
                } else {
                    label.text = ""
                }
                
                addSubview(label)
                labels[labels.count-1].append(label)
            }
        }
    }
    
    func getHeight() -> Int {
        return labels.count / 6
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let pad: CGFloat = 5.0
        let cHeight: CGFloat = (width / 12) - pad
        let cWidth: CGFloat = (width / 6) - pad
        
        heart.frame = CGRect(x: width * 0.02, y: width * 0.02, width: width * 0.06, height: width * 0.06)
        info.frame = CGRect(x: width * 0.12, y: width * 0.02, width: width * 0.84, height: width * 0.06)
        info.font = UIFont(name: "KohinoorTelugu-Regular", size: width * 0.046)
        
        for i in labels.indices {
            for j in labels[i].indices {
                labels[i][j].frame = CGRect(x: CGFloat(j) * (cWidth + pad) + pad/2, y: height - CGFloat(labels.count - i) * (cHeight + pad), width: cWidth, height: cHeight)
                labels[i][j].font = UIFont(name: "KohinoorTelugu-Regular", size: cWidth * 0.2)
            }
        }
    }
}


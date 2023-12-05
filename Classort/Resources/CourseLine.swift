//
//  CourseLine.swift
//  Classort
//
//  Created by Devin Wylde on 12/3/23.
//

import UIKit

protocol CourseLineDelegate: AnyObject {
    func didTapTrashButton(for course: Course)
}

class CourseLine: UICollectionViewCell {
    var course: Course!
    var tapped: Bool = false
    weak var delegate: CourseLineDelegate?
    
    private let priority: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "exc")?.withTintColor(.white)
        return view
    }()
    
    private let label: UILabel = {
        let label = UILabel()
        label.textColor = .white
        return label
    }()
    
    private let trash: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "trash")?.withTintColor(.white)
        return view
    }()
    
    func tap() {
        tapped = !tapped
        let img = tapped ? "exc_filled" : "exc"
        
        UIView.transition(with: priority, duration: 0.05, options: .transitionCrossDissolve) {
            self.priority.image = UIImage(named: img)?.withTintColor(.white)
        }
    }

    func configure(course: Course) {
        self.course = course
        addSubview(priority)
        addSubview(label)
        addSubview(trash)
        label.text = course.code + ": " + course.name
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(trashed))
        trash.isUserInteractionEnabled = true
        trash.addGestureRecognizer(tapGesture)
    }
    
    @objc func trashed() {
        delegate?.didTapTrashButton(for: course)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        label.font = UIFont(name: "KohinoorTelugu-Regular", size: height)
        
        priority.frame = CGRect(x: width * 0.05, y: 0, width: height, height: height)
        label.frame = CGRect(x: height + width * 0.06, y: 0, width: width * 0.85 - height * 2, height: height)
        trash.frame = CGRect(x: width * 0.95 - height, y: 0, width: height, height: height)
    }

}

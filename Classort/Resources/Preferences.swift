//
//  Preferences.swift
//  Classort
//
//  Created by Devin Wylde on 12/3/23.
//

import UIKit

class Preferences: UIView {
    
    internal let sliderContainer: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.3, alpha: 1.0)
        view.layer.cornerRadius = 10.0
        return view
    }()
    
    internal let sliderSelectionTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.text = "Credit Range"
        label.font = UIFont(name: "KohinoorTelugu-Medium", size: 20)
        return label
    }()
    
    internal let sliderView: DualSlider = {
        let view = DualSlider(length: 7, lLoc: minCredits - 12, rLoc: maxCredits - 12)
        return view
    }()
    
    internal let numberView: NumberList = {
        let view = NumberList(min: 12, max: 18)
        return view
    }()
    
    internal let scheduleContainer: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.3, alpha: 1.0)
        view.layer.cornerRadius = 10.0
        return view
    }()
    
    internal let scheduleSelectionTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.text = "Blocked Time Periods"
        label.font = UIFont(name: "KohinoorTelugu-Medium", size: 20)
        return label
    }()
    
    internal let scheduleHolder: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10.0
        view.clipsToBounds = true
        return view
    }()
    
    internal let scheduleTimeSelector: ScheduleTSItem = {
        let item = ScheduleTSItem(selected: blockedTimes)
        return item
    }()
    
    init() {
        super.init(frame: .zero)
        
        addSubview(sliderContainer)
        sliderContainer.addSubview(sliderSelectionTitleLabel)
        sliderContainer.addSubview(sliderView)
        sliderContainer.addSubview(numberView)
        
        addSubview(scheduleContainer)
        scheduleContainer.addSubview(scheduleSelectionTitleLabel)
        scheduleContainer.addSubview(scheduleHolder)
        scheduleHolder.addSubview(scheduleTimeSelector)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        sliderContainer.frame = CGRect(x: width * 0.04, y: 0, width: width * 0.92, height: height * 0.1)
        sliderSelectionTitleLabel.frame = CGRect(x: sliderContainer.width * 0.02, y: 0, width: sliderContainer.width * 0.96, height: 40)
        sliderView.frame = CGRect(x: sliderContainer.width * 0.08, y: sliderContainer.height * 0.4, width: sliderContainer.width * 0.84, height: sliderContainer.height * 0.4)
        numberView.frame = CGRect(x: sliderView.left, y: sliderContainer.height * 0.8, width: sliderView.width, height: sliderContainer.height * 0.2)
        
        scheduleContainer.frame = CGRect(x: width * 0.04, y: sliderContainer.bottom + height * 0.02, width: width * 0.92, height: height * 0.54)
        scheduleSelectionTitleLabel.frame = CGRect(x: scheduleContainer.width * 0.02, y: 0, width: scheduleContainer.width * 0.96, height: 40)
        scheduleHolder.frame = CGRect(x: scheduleContainer.width * 0.04, y: scheduleSelectionTitleLabel.bottom + scheduleContainer.height * 0.02, width: scheduleContainer.width * 0.92, height: scheduleContainer.height * 0.96 - scheduleSelectionTitleLabel.bottom)
        scheduleTimeSelector.frame = CGRect(x: 0, y: 0, width: scheduleHolder.width, height: scheduleHolder.height)
    }

    func getTimeSelected() -> [[Bool]] {
        return scheduleTimeSelector.selected
    }
    
    func getLowCredits() -> Int {
        return sliderView.lLoc + 12
    }
    
    func getHighCredits() -> Int {
        return sliderView.rLoc + 12
    }
}

class CoursedPreferences: Preferences {
    private let courseContainer: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.3, alpha: 1.0)
        view.layer.cornerRadius = 10.0
        return view
    }()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.backgroundColor = .clear
        return view
    }()
    
    private let courseSelectionTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.text = "Selected Courses"
        label.font = UIFont(name: "KohinoorTelugu-Medium", size: 20)
        return label
    }()
    
    var courses: [Course] = []
    var priorityCourses: [Course] = []
    
    override init() {
        super.init()
        addSubview(courseContainer)
        courseContainer.addSubview(courseSelectionTitleLabel)
        courseContainer.addSubview(collectionView)
        
        collectionView.register(CourseLine.self, forCellWithReuseIdentifier: "CourseLine")
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(courses: [Course]) {
        self.courses = courses
        collectionView.reloadData()
    }
    
    override func layoutSubviews() {
        courseContainer.frame = CGRect(x: width * 0.04, y: 0, width: width * 0.92, height: height * 0.3)
        courseSelectionTitleLabel.frame = CGRect(x: courseContainer.width * 0.02, y: 0, width: courseContainer.width * 0.96, height: 40)
        collectionView.frame = CGRect(x: 0, y: courseSelectionTitleLabel.bottom + courseContainer.height * 0.02, width: courseContainer.width, height: courseContainer.height * 0.98 - courseSelectionTitleLabel.bottom)
        
        sliderContainer.frame = CGRect(x: width * 0.04, y: courseContainer.bottom + height * 0.02, width: width * 0.92, height: height * 0.1)
        sliderSelectionTitleLabel.frame = CGRect(x: sliderContainer.width * 0.02, y: 0, width: sliderContainer.width * 0.96, height: 40)
        sliderView.frame = CGRect(x: sliderContainer.width * 0.08, y: sliderContainer.height * 0.4, width: sliderContainer.width * 0.84, height: sliderContainer.height * 0.4)
        numberView.frame = CGRect(x: sliderView.left, y: sliderContainer.height * 0.8, width: sliderView.width, height: sliderContainer.height * 0.2)
        
        scheduleContainer.frame = CGRect(x: width * 0.04, y: sliderContainer.bottom + height * 0.02, width: width * 0.92, height: height * 0.56)
        scheduleSelectionTitleLabel.frame = CGRect(x: scheduleContainer.width * 0.02, y: 0, width: scheduleContainer.width * 0.96, height: 40)
        scheduleHolder.frame = CGRect(x: scheduleContainer.width * 0.04, y: scheduleSelectionTitleLabel.bottom + scheduleContainer.height * 0.02, width: scheduleContainer.width * 0.92, height: scheduleContainer.height * 0.96 - scheduleSelectionTitleLabel.bottom)
        scheduleTimeSelector.frame = CGRect(x: 0, y: 0, width: scheduleHolder.width, height: scheduleHolder.height)
    }
}

extension CoursedPreferences: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, CourseLineDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return courses.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CourseLine", for: indexPath) as! CourseLine
        
        let course = courses[indexPath.row]
        
        cell.delegate = self
        cell.configure(course: course)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.width, height: 20)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! CourseLine
        cell.tap()
        
        if cell.tapped {
            priorityCourses.append(self.courses[indexPath.row])
        } else {
            if let index = priorityCourses.firstIndex(where: { $0 == self.courses[indexPath.row] }) {
                priorityCourses.remove(at: index)
            }
        }
    }
    
    func didTapTrashButton(for course: Course) {
        if let index = courses.firstIndex(where: { $0 == course }) {
            courses.remove(at: index)
            collectionView.reloadData()
        }
    }
}


class DualSlider: UIView {
    
    private let leftN: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private let rightN: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private let line: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private let lineGreen: UIView = {
        let view = UIView()
        view.backgroundColor = .green
        return view
    }()
    
    var lLoc: Int
    var rLoc: Int
    let length: Int
    
    init(length: Int, lLoc: Int, rLoc: Int) {
        self.lLoc = lLoc
        self.rLoc = rLoc
        self.length = length
        super.init(frame: .zero)
        addSubview(line)
        addSubview(lineGreen)
        addSubview(leftN)
        addSubview(rightN)
        
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(pan(_:)))
        addGestureRecognizer(panGestureRecognizer)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var panFunc: ((Int) -> Void)!
    @objc func pan(_ sender: UIPanGestureRecognizer) {
        let location = sender.location(in: self)
        let nLoc = max(min(Int(location.x / width * CGFloat(length - 1) + 0.5), length - 1), 0)
        switch (sender.state) {
        case .began:
            panFunc = [panLeft, panRight][abs(location.x - leftN.right) > abs(location.x - rightN.left) ? 1 : 0]
            return
        case .changed:
            panFunc(nLoc)
            return
        default:
            return
        }
    }
    
    func panLeft(nLoc: Int) {
        if lLoc != nLoc && nLoc < rLoc {
            lLoc = nLoc
            setNeedsLayout()
        }
    }
    
    func panRight(nLoc: Int) {
        if rLoc != nLoc && nLoc > lLoc {
            rLoc = nLoc
            setNeedsLayout()
        }
    }
    
    override func layoutSubviews() {
        let leftX = CGFloat(lLoc) * width / CGFloat(length - 1)
        let rightX = CGFloat(rLoc) * width / CGFloat(length - 1)
        
        line.frame = CGRect(x: 0, y: height * 0.4, width: width, height: height * 0.2)
        leftN.frame = CGRect(x: leftX - height * 0.1, y: height * 0.1, width: height * 0.2, height: height * 0.8)
        rightN.frame = CGRect(x: rightX - height * 0.1, y: height * 0.1, width: height * 0.2, height: height * 0.8)
        lineGreen.frame = CGRect(x: leftX, y: height * 0.4, width: rightX - leftX, height: height * 0.2)
        
        line.layer.cornerRadius = height * 0.1
        leftN.layer.cornerRadius = height * 0.1
        rightN.layer.cornerRadius = height * 0.1
    }
}

class NumberList: UIView {
    let min: Int
    let max: Int
    let range: Int
    init(min: Int, max: Int) {
        self.min = min
        self.max = max
        self.range = max - min
        super.init(frame: .zero)
        
        for i in min...max {
            let label = UILabel()
            label.textColor = .white
            label.textAlignment = .center
            label.text = String(i)
            label.tag = i - min
            addSubview(label)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        for c in subviews {
            if let c = c as? UILabel {
                c.frame = CGRect(x: CGFloat(c.tag) * width / CGFloat(range) - height / 2, y: 0, width: height, height: height)
                c.font = UIFont(name: "KohinoorTelugu-Medium", size: height)
            }
            
        }
    }
}

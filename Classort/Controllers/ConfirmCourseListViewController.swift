//
//  ConfirmCourseListViewController.swift
//  Classort
//
//  Created by Devin Wylde on 12/3/23.
//

import UIKit

class ConfirmCourseListViewController: UIViewController {
    
    var toMain: (() -> Void)?
    var courses: [Course] = []

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.text = "Confirm Selections"
        label.textAlignment = .center
        label.font = UIFont(name: "KohinoorTelugu-Medium", size: 30)
        return label
    }()
    
    private let backButton: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "back")?.withTintColor(.white)
        view.isUserInteractionEnabled = true
        return view
    }()
    
    private let preferences: CoursedPreferences = {
        let view = CoursedPreferences()
        return view
    }()
    
    private let confirmButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(red: 0.1, green: 0.3, blue: 0.1, alpha: 1.0)
        button.layer.cornerRadius = 8.0
        button.setTitle("Generate Schedules", for: .normal)
        button.addTarget(self, action: #selector(openScheduleList), for: .touchUpInside)
        return button
    }()
    
    func configure(courses: [Course]) {
        self.courses = courses
        preferences.configure(courses: courses)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(white: 0.1, alpha: 1)
        
        view.addSubview(titleLabel)
        view.addSubview(backButton)
        
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(backButtonClicked))
        backButton.addGestureRecognizer(recognizer)
        
        view.addSubview(preferences)
        view.addSubview(confirmButton)
    }
    
    @objc func backButtonClicked() {
        dismiss(animated: false)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        titleLabel.frame = CGRect(x: 0, y: view.safeAreaInsets.top, width: view.width, height: 50)
        backButton.frame = CGRect(x: 10, y: view.safeAreaInsets.top + 15, width: 20, height: 20)
        
        confirmButton.frame = CGRect(x: view.width * 0.15, y: view.height * 0.88, width: view.width * 0.7, height: view.width * 0.16)
        confirmButton.titleLabel?.font = UIFont(name: "KohinoorTelugu-Medium", size: view.width * 0.048)
        
        preferences.frame = CGRect(x: 0, y: titleLabel.bottom + view.height * 0.02, width: view.width, height: confirmButton.top - titleLabel.bottom - view.height * 0.04)
    }
    
    @objc func openScheduleList() {
        let blockedSchedule = preferences.getTimeSelected()
        var blocked: [Int] = []
        for row in blockedSchedule.indices {
            for col in blockedSchedule[row].indices {
                if blockedSchedule[row][col] {
                    blocked.append(row * 5 + col)
                }
            }
        }
        
        let vc = ScheduleListViewController()
        let scheduleBuilder = ScheduleBuilder(courses: preferences.courses, priority: preferences.priorityCourses, blocked: blocked, lowBound: preferences.getLowCredits(), highBound: preferences.getHighCredits())
        vc.configure(schedules: scheduleBuilder.buildSchedules(), generated: true)
        vc.toMain = {
            self.dismiss(animated: false)
            self.toMain?()
        }
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: false)
    }
}

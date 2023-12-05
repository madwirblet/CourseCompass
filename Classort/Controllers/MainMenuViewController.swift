//
//  MainMenuViewController.swift
//  ClassortTest
//
//  Created by Maddy Wirbel on 12/1/23.
//

import UIKit

class MainMenuViewController: UIViewController {
    
    let logo: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "logo")
        return view
    }()
    
    let button0: UIButton = {
        let button = UIButton()
        button.setTitle("Create a Schedule", for: .normal)
        button.backgroundColor = UIColor(white: 0.3, alpha: 1.0)
        button.layer.cornerRadius = 8.0
        button.addTarget(self, action: #selector(openScheduleCreator), for: .touchUpInside)
        return button
    }()
    
    let button1: UIButton = {
        let button = UIButton()
        button.setTitle("View Saved Schedules", for: .normal)
        button.backgroundColor = UIColor(white: 0.3, alpha: 1.0)
        button.layer.cornerRadius = 8.0
        button.addTarget(self, action: #selector(openSavedSchedules), for: .touchUpInside)
        return button
    }()
    
    let button2: UIButton = {
        let button = UIButton()
        button.setTitle("Set Preferences", for: .normal)
        button.backgroundColor = UIColor(white: 0.3, alpha: 1.0)
        button.layer.cornerRadius = 8.0
        button.addTarget(self, action: #selector(openPreferences), for: .touchUpInside)
        return button
    }()
    
    let button3: UIButton = {
        let button = UIButton()
        button.setTitle("Calibrate Sorting", for: .normal)
        button.backgroundColor = UIColor(white: 0.3, alpha: 1.0)
        button.layer.cornerRadius = 8.0
        button.addTarget(self, action: #selector(openCalibrator), for: .touchUpInside)
        return button
    }()

    override func viewDidAppear(_ animated: Bool) {
        loadRatings()
        loadBlockedTimes()
        loadCreditRange()
        loadSchedules()
        loadDefaultSort()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(white: 0.1, alpha: 1.0)
        
        view.addSubview(logo)
        view.addSubview(button0)
        view.addSubview(button1)
        view.addSubview(button2)
        view.addSubview(button3)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        logo.frame = CGRect(x: view.width * 0.1, y: view.safeAreaInsets.top, width: view.width * 0.8, height: view.width * 0.16)
        button0.frame = CGRect(x: view.width * 0.05, y: logo.bottom + view.width * 0.1, width: view.width * 0.9, height: view.width * 0.2)
        button1.frame = CGRect(x: view.width * 0.05, y: button0.bottom + view.width * 0.05, width: view.width * 0.9, height: view.width * 0.2)
        button2.frame = CGRect(x: view.width * 0.05, y: button1.bottom + view.width * 0.05, width: view.width * 0.9, height: view.width * 0.2)
        button3.frame = CGRect(x: view.width * 0.05, y: button2.bottom + view.width * 0.05, width: view.width * 0.9, height: view.width * 0.2)
        
        button0.titleLabel?.font = UIFont(name: "KohinoorTelugu-Medium", size: view.width * 0.06)
        button1.titleLabel?.font = UIFont(name: "KohinoorTelugu-Medium", size: view.width * 0.06)
        button2.titleLabel?.font = UIFont(name: "KohinoorTelugu-Medium", size: view.width * 0.06)
        button3.titleLabel?.font = UIFont(name: "KohinoorTelugu-Medium", size: view.width * 0.06)
    }
    
    @objc func openCalibrator() {
        let vc = CalibrateViewController()
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: false)
    }
    
    @objc func openScheduleCreator() {
        let vc = SemesterSelectorViewController()
        vc.modalPresentationStyle = .fullScreen
        vc.toMain = {
            self.dismiss(animated: false)
        }
        present(vc, animated: false)
    }
    
    @objc func openSavedSchedules() {
        let vc = ScheduleListViewController()
        vc.configure(schedules: savedSchedules)
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: false)
    }
    
    @objc func openPreferences() {
        let vc = PreferencesViewController()
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: false)
    }
}

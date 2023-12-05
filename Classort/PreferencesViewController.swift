//
//  PreferencesViewController.swift
//  Classort
//
//  Created by Devin Wylde on 12/3/23.
//

import UIKit

class PreferencesViewController: UIViewController {
    var courses: [Course] = []

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.text = "Preferences"
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
    
    private let scrollView: UIScrollView = {
        let field = UIScrollView()
        field.isScrollEnabled = true
        field.isUserInteractionEnabled = true
        field.showsVerticalScrollIndicator = true
        field.backgroundColor = .clear
        return field
    }()
    
    private let preferences: Preferences = {
        let view = Preferences()
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(white: 0.1, alpha: 1)
        
        view.addSubview(titleLabel)
        view.addSubview(backButton)
        view.addSubview(scrollView)
        
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(backButtonClicked))
        backButton.addGestureRecognizer(recognizer)
        
        scrollView.addSubview(preferences)
    }
    
    @objc func backButtonClicked() {
        blockedTimes = preferences.getTimeSelected()
        minCredits = preferences.getLowCredits()
        maxCredits = preferences.getHighCredits()
        saveBlockedTimes()
        saveCreditRange()
        dismiss(animated: false)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        titleLabel.frame = CGRect(x: 0, y: view.safeAreaInsets.top, width: view.width, height: 50)
        backButton.frame = CGRect(x: 10, y: view.safeAreaInsets.top + 15, width: 20, height: 20)
        scrollView.frame = CGRect(x: 0, y: titleLabel.bottom + view.height * 0.03, width: view.width, height: view.height * 0.99 - titleLabel.bottom)
        
        preferences.frame = CGRect(x: 0, y: 0, width: scrollView.width, height: scrollView.height)
    }
}

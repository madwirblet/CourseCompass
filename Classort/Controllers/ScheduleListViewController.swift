//
//  ScheduleListViewController.swift
//  Classort
//
//  Created by Devin Wylde on 12/3/23.
//

import UIKit

class ScheduleListViewController: UIViewController {
    var schedules: [Schedule] = []
    var toMain: (() -> Void)?
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.text = "Saved Schedules"
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
    
    private let exitButton: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "exit")?.withTintColor(.white)
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
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.backgroundColor = .clear
        return view
    }()
    
    private let emptyLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.text = "No Schedules Available"
        label.textAlignment = .center
        label.font = UIFont(name: "KohinoorTelugu-Medium", size: 15)
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor(white: 0.1, alpha: 1)
        
        view.addSubview(titleLabel)
        view.addSubview(backButton)
        
        let backTapGesture = UITapGestureRecognizer(target: self, action: #selector(backButtonClicked))
        backButton.addGestureRecognizer(backTapGesture)
        
        view.addSubview(scrollView)
        scrollView.addSubview(collectionView)
        
        collectionView.register(ScheduleItem.self, forCellWithReuseIdentifier: "ScheduleItem")
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    func configure(schedules: [Schedule], generated: Bool = false) {
        if generated {
            titleLabel.text = "All Schedules"
            emptyLabel.text = "No Schedules. Try changing your settings!"
            view.addSubview(exitButton)
            
            let exitTapGesture = UITapGestureRecognizer(target: self, action: #selector(exitButtonClicked))
            exitButton.addGestureRecognizer(exitTapGesture)
        }
        
        self.schedules = schedules
        if schedules.isEmpty {
            view.addSubview(emptyLabel)
        }
        
        collectionView.reloadData()
        updateCollectionFraming()
    }
    
    @objc func backButtonClicked() {
        saveSchedules()
        dismiss(animated: false)
    }
    
    @objc func exitButtonClicked() {
        saveSchedules()
        dismiss(animated: false)
        toMain?()
    }
    
    func updateCollectionFraming() {
        collectionView.frame = CGRect(x: 0, y: 0, width: scrollView.width, height: scrollView.height)
        scrollView.contentSize = CGSize(width: view.width, height: collectionView.height)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        titleLabel.frame = CGRect(x: 0, y: view.safeAreaInsets.top, width: view.width, height: 50)
        backButton.frame = CGRect(x: 10, y: view.safeAreaInsets.top + 15, width: 20, height: 20)
        exitButton.frame = CGRect(x: view.width - 40, y: view.safeAreaInsets.top + 15, width: 20, height: 20)
        
        scrollView.frame = CGRect(x: 0, y: titleLabel.bottom + view.height * 0.02, width: view.width, height: view.height * 0.98 - titleLabel.bottom)
        collectionView.frame = CGRect(x: 0, y: 0, width: scrollView.width, height: scrollView.height)
        emptyLabel.frame = CGRect(x: 0, y: titleLabel.bottom, width: view.width, height: view.height - titleLabel.bottom * 2)
    }
}

extension ScheduleListViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return schedules.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ScheduleItem", for: indexPath) as! ScheduleItem
        
        let schedule = schedules[indexPath.row]
        
        cell.configure(schedule: schedule)
        cell.clipsToBounds = true
        cell.backgroundColor = UIColor(white: 0.6, alpha: 1.0)
        cell.layer.cornerRadius = 10.0
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let schedule = schedules[indexPath.row]
        return CGSize(width: collectionView.width * 0.98, height: collectionView.width * 0.086 * schedule.height + collectionView.width * 0.24)
    }
}

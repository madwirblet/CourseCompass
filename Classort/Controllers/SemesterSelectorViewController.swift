//
//  SemesterSelectorViewController.swift
//  Classort
//
//  Created by Devin Wylde on 12/3/23.
//

import UIKit

class SemesterSelectorViewController: UIViewController {
    var toMain: (() -> Void)?
    var terms: [Term] = []
    var termOpening: Bool = false
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.text = "Select a Semester"
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
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.backgroundColor = .clear
        return view
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
        
        collectionView.register(TermItem.self, forCellWithReuseIdentifier: "TermItem")
        collectionView.dataSource = self
        collectionView.delegate = self
        
        Task {
            self.terms = await collectTermInfo()
            collectionView.reloadData()
            updateCollectionFraming()
        }
    }
    
    @objc func backButtonClicked() {
        dismiss(animated: false)
    }
    
    func updateCollectionFraming() {
        collectionView.frame = CGRect(x: 0, y: 0, width: scrollView.width, height: scrollView.height)
        scrollView.contentSize = CGSize(width: view.width, height: collectionView.height)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        titleLabel.frame = CGRect(x: 0, y: view.safeAreaInsets.top, width: view.width, height: 50)
        backButton.frame = CGRect(x: 10, y: view.safeAreaInsets.top + 15, width: 20, height: 20)
        
        scrollView.frame = CGRect(x: 0, y: titleLabel.bottom + view.height * 0.02, width: view.width, height: view.height * 0.98 - titleLabel.bottom)
        collectionView.frame = CGRect(x: 0, y: 0, width: scrollView.width, height: scrollView.height)
    }
}

extension SemesterSelectorViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return terms.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TermItem", for: indexPath) as! TermItem
        
        let term = terms[indexPath.row]
        
        cell.configure(title: term.DESC, code: term.CODE, color: UIColor(red: 0.3, green: 0.7, blue: 0.3, alpha: 1), downloaded: checkIfTermInStorage(term: term.CODE))
        cell.clipsToBounds = true
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = collectionView.cellForItem(at: indexPath) as! TermItem
        if termOpening {
            return
        }
        
        if checkIfTermInStorage(term: item.code), let courses = loadCourses(term: item.code) {
            let vc = CourseListViewController()
            vc.configure(courses: courses)
            vc.toMain = {
                self.dismiss(animated: false)
                self.toMain?()
            }
            vc.modalPresentationStyle = .overFullScreen
            present(vc, animated: false)
        } else {
            termOpening = true
            Task {
                let courses = await collectCourseInfo(term: item.code, increment: {inc in DispatchQueue.main.async { item.incDownload(count: inc) }}, setThreshold: {threshold in DispatchQueue.main.async { item.initializeDownload(threshold: threshold)}})
                saveCourses(term: item.code, courses: courses)
                
                let vc = CourseListViewController()
                vc.configure(courses: courses)
                vc.modalPresentationStyle = .overFullScreen
                present(vc, animated: false)
                self.termOpening = false
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let pad: CGFloat = 10
        return CGSize(width: (collectionView.width - pad) / 2, height: view.width * 0.15)
    }
}

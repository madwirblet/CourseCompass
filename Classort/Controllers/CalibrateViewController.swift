//
//  CalibrateViewController.swift
//  Classort
//
//  Created by Devin Wylde on 12/2/23.
//

import UIKit

class CalibrateViewController: UIViewController {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.text = "Calibrating..."
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
    
    private let progressLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.layer.opacity = 0
        return label
    }()
    
    private let progressBar: ProgressBar = {
        let view = ProgressBar()
        view.backgroundColor = .white
        view.foregroundColor = UIColor(red: 0.5, green: 1.0, blue: 0.5, alpha: 1.0)
        view.layer.cornerRadius = 8.0
        view.clipsToBounds = true
        view.layer.opacity = 0
        return view
    }()
    
    private let quickSortLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.text = "QuickSort Speed: "
        label.layer.opacity = 0
        return label
    }()
    
    private let mergeSortLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.text = "MergeSort Speed: "
        label.layer.opacity = 0
        return label
    }()
    
    private let savingLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.text = "Saving Calibrations..."
        label.layer.opacity = 0
        return label
    }()
    
    private let loading = UIActivityIndicatorView(style: .medium)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(white: 0.1, alpha: 1.0)
        
        view.addSubview(titleLabel)
        view.addSubview(backButton)
        
        let backTapGesture = UITapGestureRecognizer(target: self, action: #selector(backButtonClicked))
        backButton.addGestureRecognizer(backTapGesture)
        
        view.addSubview(progressLabel)
        view.addSubview(progressBar)
        view.addSubview(loading)
        view.addSubview(quickSortLabel)
        view.addSubview(mergeSortLabel)
        view.addSubview(savingLabel)
        
        
        let testCapacity = 100_000 //100_000
        
        progressBar.threshold = testCapacity
        
        performCalibration(capacity: testCapacity)
    }
    
    var calibrationTask: Task<Void, Never>?
    
    @objc func backButtonClicked() {
        calibrationTask?.cancel()
        dismiss(animated: false)
    }
    
    func performCalibration(capacity: Int) {
        calibrationTask = Task {
            progressLabel.text = "Loading test data..."
            
            UIView.animate(withDuration: 0.32) {
                self.progressBar.layer.opacity = 1
                self.progressLabel.layer.opacity = 1
            }
            
            var courses = await generateCourseData(nodes: capacity, watch: calibrationTask!, increment: {
                DispatchQueue.main.async {
                    self.progressBar.increment(count: 1)
                }
            })
            
            if Task.isCancelled {
                return
            }
            
            var courses2 = Array(courses) // shallow copy
            
            loading.startAnimating()
            
            let qStartTime = DispatchTime.now()
            quickSort(list: &courses, comparator: compareNameAsc(_:_:), low: 0, high: courses.count - 1)
            let qEndTime = DispatchTime.now()
            let qTime = Double(qEndTime.uptimeNanoseconds - qStartTime.uptimeNanoseconds) / 1_000_000_000
            
            let mStartTime = DispatchTime.now()
            mergeSort(list: &courses2, comparator: compareNameAsc(_:_:), left: 0, right: courses2.count - 1, courseIndex: -1)
            let mEndTime = DispatchTime.now()
            let mTime = Double(mEndTime.uptimeNanoseconds - mStartTime.uptimeNanoseconds) / 1_000_000_000
            
            loading.stopAnimating()
            
            quickSortLabel.text! += String(qTime)
            mergeSortLabel.text! += String(mTime)
            
            if qTime > mTime {
                quickDefault = true
                saveDefaultSort()
            } else {
                quickDefault = false
                saveDefaultSort()
            }
            
            UIView.animate(withDuration: 0.32) {
                self.progressBar.layer.opacity = 0
                self.progressLabel.layer.opacity = 0
            } completion: { _ in
                UIView.animate(withDuration: 1.0) {
                    self.quickSortLabel.layer.opacity = 1
                } completion: { _ in
                    UIView.animate(withDuration: 1.0) {
                        self.mergeSortLabel.layer.opacity = 1
                    } completion: { _ in
                        UIView.animate(withDuration: 1.0) {
                            self.savingLabel.layer.opacity = 1
                        }
                    }
                }
            }
        }
    }
    
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        titleLabel.frame = CGRect(x: 0, y: view.safeAreaInsets.top, width: view.width, height: 50)
        backButton.frame = CGRect(x: 10, y: view.safeAreaInsets.top + 15, width: 20, height: 20)
        
        progressLabel.frame = CGRect(x: 25, y: view.height / 2 - 40, width: view.width - 50, height: 25)
        progressBar.frame = CGRect(x: 25, y: view.height / 2 - 12.5, width: view.width - 50, height: 25)
        loading.frame = CGRect(x: 0, y: view.height / 2 + 20, width: view.width, height: 25)
        
        quickSortLabel.frame = CGRect(x: 0, y: view.height / 2 - 75, width: view.width, height: 25)
        mergeSortLabel.frame = CGRect(x: 0, y: view.height / 2 - 25, width: view.width, height: 25)
        savingLabel.frame = CGRect(x: 0, y: view.height / 2 + 25, width: view.width, height: 25)
    }
}

//
//  ViewController.swift
//  Classort
//
//  Created by Devin Wylde on 11/29/23.
//

import UIKit

struct StringCast: Codable {
    var value: String?
    
    init(from decoder: Decoder) throws {
        if let string = try? decoder.singleValueContainer().decode(String.self) {
            value = string
        } else if let int = try? decoder.singleValueContainer().decode(Int.self) {
            value = String(int)
        } else {
            value = nil
        }
    }
}

struct IntFilter: Codable {
    var value: Int?
    
    init(from decoder: Decoder) throws {
        if let int = try? decoder.singleValueContainer().decode(Int.self) {
            value = int
        } else {
            value = nil
        }
    }
}

class CourseListViewController: UIViewController {
    
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
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.text = "Select Courses:"
        label.font = UIFont(name: "KohinoorTelugu-Medium", size: 30)
        return label
    }()
    
    private let scrollView: UIScrollView = {
        let field = UIScrollView()
        field.isScrollEnabled = true
        field.isUserInteractionEnabled = true
        field.showsVerticalScrollIndicator = true
        return field
    }()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return view
    }()
    
    private let cover: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.layer.opacity = 0
        return view
    }()
    
    internal let searchBar: UITextField = {
        let searchBar = UITextField()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.placeholder = "Search Courses"
        let placeholderAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor(white: 0.1, alpha: 1.0)
        ]
        searchBar.attributedPlaceholder = NSAttributedString(string: "Search Courses", attributes: placeholderAttributes)
        searchBar.autocapitalizationType = .none
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(didTapDoneButton))
        toolbar.setItems([doneButton], animated: false)
        searchBar.inputAccessoryView = toolbar
        searchBar.backgroundColor = UIColor(white: 1, alpha: 0.8)
        searchBar.textColor = UIColor(white: 0.1, alpha: 1)
        searchBar.layer.cornerRadius = 16.0
        searchBar.font = UIFont(name: "KohinoorTelugu-Regular", size: 20)
        return searchBar
    }()
    
    internal let searchIcon: UIImageView = {
        let icon = UIImageView()
        icon.image = UIImage(named: "Search")
        icon.layer.opacity = 0.9
        return icon
    }()
    
    @objc internal func didTapDoneButton() {
        view.endEditing(true)
    }
    
    var curCourseInfo: [Course] = []
    var courseInfo: [Course] = []
    var selectedCourses: [Course] = []
    var coursesLoaded: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(titleLabel)
        view.addSubview(searchBar)
        searchBar.addSubview(searchIcon)
        view.addSubview(scrollView)
        scrollView.addSubview(collectionView)

        collectionView.register(CourseItem.self, forCellWithReuseIdentifier: "CourseItem")
        collectionView.dataSource = self
        collectionView.delegate = self

        searchBar.delegate = self

        loadCourses()
    }
    
    func loadCourses() {
        showProgressBar()
        Task {
            progressLabel.text = "Loading course data..."
            await updateCourseInfo()
            saveCourseInstructors()
            UIView.animate(withDuration: 0.3) {
                self.progressLabel.layer.opacity = 0
            } completion: { _ in
                self.progressLabel.text = "Loading ratings data..."
                UIView.animate(withDuration: 0.3) {
                    self.progressLabel.layer.opacity = 1
                } completion: { _ in
                    Task {
                        await self.updateInstructorRatings()
                        self.updateFilteredCourses()
                        self.updateCourseFraming()
                        self.hideProgressBar()
                    }
                }
            }
        }
        
    }
    
    func updateCourseInfo() async {
        courseInfo = await collectCourseInfo(term: 2241, increment: { inc in DispatchQueue.main.async { self.progressBar.increment(count: inc) }}, setThreshold: { t in self.progressBar.threshold = t })
    }
    
    func updateInstructorRatings() async {
        self.progressBar.threshold = courseInfo.count
        self.progressBar.set(count: 0)
        courseInfo = await fetchInstructorRatings(courseInfo: courseInfo, increment: { DispatchQueue.main.async { self.progressBar.increment(count: 1) }})
    }
    
    func saveCourseInstructors() {
        for i in courseInfo.indices {
            if let firstSection = courseInfo[i].sections.first {
                var commonInstructorNames = Set(firstSection.instructors.map { $0.name })

                for section in courseInfo[i].sections.dropFirst() {
                    let instructorNames = Set(section.instructors.map { $0.name })
                    commonInstructorNames.formIntersection(instructorNames)
                }

                if let commonName = commonInstructorNames.first {
                    courseInfo[i].instructor = commonName
                } else {
                    courseInfo[i].instructor = "Variable"
                }
            } else {
                courseInfo[i].instructor = "Variable"
            }
        }
    }
    
    
    
    func updateFilteredCourses() {
        if searchBar.text == nil || searchBar.text == "" {
            curCourseInfo = courseInfo
        } else {
            curCourseInfo = courseInfo.filter({$0.code.lowercased().contains(searchBar.text!.lowercased()) || $0.name.lowercased().contains(searchBar.text!.lowercased())})
        }
        collectionView.reloadData()
    }
    
    func updateCourseFraming() {
        collectionView.frame = CGRect(x: 0, y: 0, width: scrollView.width, height: scrollView.height)
        scrollView.contentSize = CGSize(width: view.width, height: collectionView.height)
    }
    
    func hideProgressBar() {
        UIView.animate(withDuration: 0.32) {
            self.progressBar.layer.opacity = 0
            self.progressLabel.layer.opacity = 0
        } completion: { _ in
            UIView.animate(withDuration: 0.32) {
                self.cover.layer.opacity = 0
            } completion: { _ in
                self.progressBar.removeFromSuperview()
                self.progressLabel.removeFromSuperview()
                self.cover.removeFromSuperview()
            }
        }
    }
    
    func showProgressBar() {
        view.addSubview(cover)
        view.addSubview(progressLabel)
        view.addSubview(progressBar)
        
        UIView.animate(withDuration: 0.32) {
            self.cover.layer.opacity = 1
        } completion: { _ in
            UIView.animate(withDuration: 0.32) {
                self.progressBar.layer.opacity = 1
                self.progressLabel.layer.opacity = 1
            }
        }
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        titleLabel.frame = CGRect(x: 5, y: view.safeAreaInsets.top, width: view.width - 10, height: 50)
        searchBar.frame = CGRect(x: view.width * 0.01, y: titleLabel.bottom + view.height * 0.02, width: view.width * 0.99, height: view.height * 0.06)
        searchIcon.frame = CGRect(x: searchBar.height * 0.25, y: searchBar.height * 0.25, width: searchBar.height * 0.5, height: searchBar.height * 0.5)
        scrollView.frame = CGRect(x: 0, y: searchBar.bottom + view.height * 0.01, width: view.width, height: view.height * 0.99 - searchBar.bottom)
        collectionView.frame = CGRect(x: 0, y: 0, width: scrollView.width, height: scrollView.height)
        
        if !coursesLoaded {
            cover.frame = CGRect(x: 0, y: 0, width: view.width, height: view.height)
            progressLabel.frame = CGRect(x: 25, y: view.height / 2 - 40, width: view.width - 50, height: 25)
            progressBar.frame = CGRect(x: 25, y: view.height / 2 - 12.5, width: view.width - 50, height: 25)
        }
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: searchBar.height, height: searchBar.height))
        searchBar.leftView = paddingView
        searchBar.leftViewMode = .always
    }
    
    @objc func itemTapped(sender: CourseItem) {
        print("We gottem @ " + sender.code)
    }
}

extension CourseListViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return curCourseInfo.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CourseItem", for: indexPath) as! CourseItem
        
        let course = curCourseInfo[indexPath.row]
        
        cell.configure(title: course.name, code: course.code, instructor: course.instructor!, rating: course.rating!, color: ((selectedCourses.contains(where: { $0 == course })) ? UIColor(red: 0.8, green: 1.0, blue: 0.9, alpha: 1.0) : .white))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        if let index = selectedCourses.firstIndex(where: { $0 == self.curCourseInfo[indexPath.row] }) {
            selectedCourses.remove(at: index)
            cell?.backgroundColor = .white
        } else {
            selectedCourses.append(self.curCourseInfo[indexPath.row])
            cell?.backgroundColor = UIColor(red: 0.8, green: 1.0, blue: 0.9, alpha: 1.0)
        }
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.width, height: view.width * 0.3)
    }
}

extension CourseListViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if textField == self.searchBar {
            updateFilteredCourses()
        }
    }
}

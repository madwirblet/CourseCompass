//
//  TermItem.swift
//  Classort
//
//  Created by Devin Wylde on 12/3/23.
//
import UIKit

class TermItem: UICollectionViewCell {
    var isLoading: Bool = false
    var loadingIcon = UIActivityIndicatorView()
    
    private let label: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    private let downloadIcon: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "download")?.withTintColor(.white)
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    private let progress: ProgressBar = {
        let bar = ProgressBar()
        bar.backgroundColor = UIColor(white: 0.6, alpha: 1.0)
        return bar
    }()
    
    var code: String!
    var name: String!
    var downloaded: Bool!
    
    func load() {
        isLoading = true
        loadingIcon.color = .white
        addSubview(loadingIcon)
        loadingIcon.center = downloadIcon.center
        loadingIcon.startAnimating()
        downloadIcon.removeFromSuperview()
    }
    
    func stopLoad() {
        isLoading = false
        loadingIcon.stopAnimating()
        loadingIcon.removeFromSuperview()
        progress.removeFromSuperview()
    }
    
    func initializeDownload(threshold: Int) {
        progress.threshold = threshold
        load()
    }
    
    func incDownload(count: Int) {
        progress.increment(count: count)
    }
    
    func completeDownload() {
        progress.removeFromSuperview()
        stopLoad()
    }
    
    func configure(title: String, code: String, color: UIColor, downloaded: Bool) {
        self.code = code
        self.name = title
        backgroundColor = color
        
        label.text = title
        
        self.downloaded = downloaded
        if !downloaded {
            addSubview(progress)
            addSubview(downloadIcon)
        }
        addSubview(label)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = width * 0.02
        
        label.font = UIFont(name: "KohinoorTelugu-Regular", size: width * 0.1)
        
        if downloaded {
            label.frame = CGRect(x: 0, y: 0, width: width, height: height)
        } else {
            progress.frame = CGRect(x: 0, y: 0, width: width, height: height)
            
            label.sizeToFit()
            downloadIcon.frame = CGRect(x: (width - label.width - width * 0.08 - 10) / 2, y: (height - width * 0.08) / 2, width: width * 0.08, height: width * 0.08)
            label.frame.origin = CGPoint(x: (width - label.width + width * 0.08 + 10) / 2, y: (height - label.height) / 2)
        }
    }
}

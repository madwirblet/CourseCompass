//
//  ScheduleTSItem.swift
//  Classort
//
//  Created by Devin Wylde on 12/3/23.
//

import UIKit

class ScheduleTSItem : UIView {
    public var selected: [[Bool]]
    
    private var panGestureRecognizer: UIPanGestureRecognizer!
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.backgroundColor = .clear
        return view
    }()
    
    init(selected: [[Bool]]) {
        self.selected = selected
        super.init(frame: .zero)
        
        for i in 1...5 {
            for j in 1...14 {
                let cell = ScheduleTSCell()
                let tapGesture = UITapGestureRecognizer(target: self, action: #selector(periodTapped(_:)))
                cell.addGestureRecognizer(tapGesture)
                cell.isUserInteractionEnabled = true
                cell.backgroundColor = selected[j - 1][i - 1] ? UIColor(white: 0.8, alpha: 1.0) : .white
                cell.layer.borderColor = CGColor(gray: 0.6, alpha: 1.0)
                cell.layer.borderWidth = 1.0
                cell.loc = (j, i)
                cell.editable = true
                addSubview(cell)
            }
        }
        
        for i in 0...5 {
            let cell = ScheduleTSCell()
            cell.backgroundColor = .white
            cell.layer.borderColor = CGColor(gray: 0.6, alpha: 1.0)
            cell.layer.borderWidth = 1.0
            cell.loc = (0, i)
            cell.text = ["", "M", "T", "W", "R", "F"][i]
            cell.textAlignment = .center
            cell.textColor = .black
            addSubview(cell)
        }
        
        for j in 1...14 {
            let cell = ScheduleTSCell()
            cell.backgroundColor = .white
            cell.layer.borderColor = CGColor(gray: 0.6, alpha: 1.0)
            cell.layer.borderWidth = 1.0
            cell.loc = (j, 0)
            cell.text = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "E1", "E2", "E3"][j-1]
            cell.textAlignment = .center
            cell.textColor = .black
            addSubview(cell)
        }
        
        panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        addGestureRecognizer(panGestureRecognizer)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let cHeight: CGFloat = (height / 15)
        let cWidth: CGFloat = (width / 6)
        
        for c in subviews {
            if let c = c as? ScheduleTSCell {
                c.frame = CGRect(x: CGFloat(c.loc.1) * cWidth, y: CGFloat(c.loc.0) * cHeight, width: cWidth, height: cHeight)
            }
        }
    }
    
    @objc func periodTapped(_ sender: UITapGestureRecognizer) {
        tap(view: sender.view as! ScheduleTSCell)
    }
    
    func tap(view: ScheduleTSCell) {
        if view.editable {
            selected[view.loc.0 - 1][view.loc.1 - 1] = !selected[view.loc.0 - 1][view.loc.1 - 1]
            view.backgroundColor = selected[view.loc.0 - 1][view.loc.1 - 1] ? UIColor(white: 0.8, alpha: 1.0) : .white
        }
    }
    
    var changed: [ScheduleTSCell] = []
    @objc func handlePan(_ gestureRecognizer: UIPanGestureRecognizer) {
        switch gestureRecognizer.state {
        case .began:
            changed = []
        case .changed:
            let location = gestureRecognizer.location(in: self)
            if let cell = findCell(at: location), !changed.contains(cell) {
                tap(view: cell)
                changed.append(cell)
            }
            break
        default:
            break
        }
    }

    private func findCell(at location: CGPoint) -> ScheduleTSCell? {
        for subview in subviews {
            if let cell = subview as? ScheduleTSCell, cell.frame.contains(location) {
                return cell
            }
        }
        return nil
    }
}

class ScheduleTSCell: UILabel {
    var loc: (Int, Int)!
    var editable: Bool = false
}

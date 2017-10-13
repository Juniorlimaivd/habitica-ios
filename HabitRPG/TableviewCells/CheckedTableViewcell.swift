//
//  HRPGCheckedTableViewcell.swift
//  Habitica
//
//  Created by Phillip Thelen on 09/03/2017.
//  Copyright © 2017 HabitRPG Inc. All rights reserved.
//

import UIKit
import Down

class CheckedTableViewCell: TaskTableViewCell {

    @IBOutlet weak var checkBox: HRPGCheckBoxView!
    @IBOutlet weak var checklistIndicator: UIView!
    @IBOutlet weak var checklistDoneLabel: UILabel!
    @IBOutlet weak var checklistAllLabel: UILabel!
    @IBOutlet weak var checklistSeparator: UIView!
    @IBOutlet weak var checklistIndicatorWidth: NSLayoutConstraint!
    @IBOutlet weak var checklistContainer: UIStackView!
    @IBOutlet weak var checklistLeftBorderView: UIView!
    @IBOutlet weak var checklistRightBorderView: UIView!
    
    weak var task: Task?
    var isExpanded = false
    var checkboxTouched: (() -> Void)?
    var expandChecklistAction: (() -> Void)?
    var checklistItemTouched: ((_ item: ChecklistItem) -> Void)?

    override func configure(task: Task) {
        self.task = task
        super.configure(task: task)
        self.checkBox.configure(for: task)
        self.checkBox.wasTouched = {[weak self] in
            self?.checkTask()
        }
        
        handleChecklist(task)

        if task.completed?.boolValue ?? false {
            self.checklistIndicator.backgroundColor = .gray500()
            self.titleLabel.textColor = .gray300()
            self.backgroundColor = .gray600()
        } else {
            self.backgroundColor = .white
            self.titleLabel.textColor = .gray10()
        }

        self.titleLabel.backgroundColor = self.backgroundColor
        self.subtitleLabel.backgroundColor = self.backgroundColor

        self.checklistIndicator.layoutIfNeeded()
        
        if let recognizers = self.checklistIndicator.gestureRecognizers, recognizers.count > 0 {
            self.checklistIndicator.removeGestureRecognizer(recognizers[0])
        }
        self.checklistIndicator.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(expandChecklist)))
    }
    
    func handleChecklist(_ task: Task) {
        self.checklistIndicator.backgroundColor = task.lightTaskColor()
        self.checklistLeftBorderView.backgroundColor = task.taskColor()
        self.checklistRightBorderView.backgroundColor = task.taskColor()
        self.checklistIndicator.isHidden = false
        self.checklistIndicator.translatesAutoresizingMaskIntoConstraints = false
        let checklistCount = task.checklist?.count ?? 0
        
        if checklistCount > 0 {
            var checkedCount = 0
            if let checklist = task.checklist?.array as? [ChecklistItem] {
                for item in checklist where item.completed.boolValue {
                    checkedCount += 1
                }
            }
            self.checklistDoneLabel.text = "\(checkedCount)"
            self.checklistAllLabel.text = "\(checklistCount)"
            self.checklistDoneLabel.textColor = .white
            self.checklistAllLabel.textColor = .white
            self.checklistSeparator.backgroundColor = .white
            if checkedCount == checklistCount {
                self.checklistIndicator.backgroundColor = .gray500()
                self.checklistDoneLabel.textColor = .gray300()
                self.checklistAllLabel.textColor = .gray300()
                self.checklistSeparator.backgroundColor = .gray300()
                self.checklistLeftBorderView.backgroundColor = .gray400()
                self.checklistRightBorderView.backgroundColor = .gray400()
            }
            self.checklistDoneLabel.isHidden = false
            self.checklistAllLabel.isHidden = false
            self.checklistSeparator.isHidden = false
            self.checklistIndicatorWidth.constant = 32.0
        } else {
            self.checklistDoneLabel.isHidden = true
            self.checklistAllLabel.isHidden = true
            self.checklistSeparator.isHidden = true
            self.checklistIndicatorWidth.constant = 0
        }
        
        checklistContainer.arrangedSubviews.forEach { (view) in
            view.removeFromSuperview()
        }
        if isExpanded {
            addChecklistViews(task: task)
        }
    }
    
    private func addChecklistViews(task: Task) {
        if let checklist = task.checklist?.array as? [ChecklistItem] {
            for item in checklist {
                let checkbox = HRPGCheckBoxView()
                checkbox.configure(for: item, withTitle: true)
                checklistContainer.addArrangedSubview(checkbox)
                checkbox.wasTouched = {[weak self] in
                    if let action = self?.checklistItemTouched {
                        action(item)
                    }
                }
            }
        }
    }
    
    override func applyAccessibility(_ task: Task) {
        super.applyAccessibility(task)
        var expandLabel = NSLocalizedString("Expand Checklist", comment: "")
        if isExpanded {
            expandLabel = NSLocalizedString("Collapse Checklist", comment: "")
        }
        self.accessibilityCustomActions = [UIAccessibilityCustomAction(name: NSLocalizedString("Complete Task", comment: ""), target: self, selector: #selector(checkTask)),
        UIAccessibilityCustomAction(name: expandLabel, target: self, selector: #selector(expandChecklist))]
        var stateText = ""
        if task.type == "daily" {
            if task.isDue?.boolValue ?? false {
                stateText = NSLocalizedString("Due", comment: "")
            } else {
                stateText = NSLocalizedString("Not due", comment: "")
            }
        } else {
            stateText = NSLocalizedString("Not completed", comment: "")
        }
        if task.completed?.boolValue ?? false {
            stateText = NSLocalizedString("Completed", comment: "")
        }
        self.accessibilityLabel = "\(stateText), \(task.text ?? "")"
    }
    
    func checkTask() {
        if let action = checkboxTouched {
            action()
        }
    }
    
    func expandChecklist() {
        if let action = expandChecklistAction {
            action()
        }
    }
}

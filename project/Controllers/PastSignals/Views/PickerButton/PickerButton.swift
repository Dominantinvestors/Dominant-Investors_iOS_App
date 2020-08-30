//
//  PickerButton.swift
//  DominantInvestors
//
//  Created by Andrew Konovalskiy on 30.08.2020.
//  Copyright © 2020 DS. All rights reserved.
//

import UIKit

protocol PickerButtonDelegate: UIPickerViewDelegate {
    func pickerButtonDidClose(_ pickerButton: PickerButton)
}

final class PickerButton: UIButton {

    private(set) var selectedValues: [String] = []
    private let picker = UIPickerView()
    private(set) var closeButton: UIBarButtonItem!

    private var delegateProxy: UIPickerViewDelegateProxy?
    var closeHandler: (() -> Void)?
    var delegate: UIPickerViewDelegate? {
        set {
            let delegateProxy = UIPickerViewDelegateProxy(newValue)
            delegateProxy.titleChanged = { [weak self] in
                guard let me = self else {
                    return
                }
                me.selectedValues[$0.component] = $0.title
                me.updateTitle()
            }
            picker.delegate = delegateProxy
            self.delegateProxy = delegateProxy
            
            let components = picker.numberOfComponents
            guard components > 0 else {
                return
            }
            
            self.selectedValues = (0..<components).map {
                guard picker.numberOfRows(inComponent: $0) > 0 else {
                    return ""
                }
                return picker.delegate?.pickerView?(picker, titleForRow: 0, forComponent: $0) ?? ""
            }
            updateTitle()
        }
        get {
            return delegateProxy
        }
    }

    var dataSource: UIPickerViewDataSource? {
        set {
            picker.dataSource = newValue
        }
        get {
            return picker.dataSource
        }
    }

    var showsSelectionIndicator: Bool {
        set {
            picker.showsSelectionIndicator = newValue
        }
        get {
            return picker.showsSelectionIndicator
        }
    }

    var closeButtonTitle: String = "Done"

    var buttonTitleSeparator: String = " "

    /// If set true, title is updated automatically when a picker item is selected
    ///
    /// - note: Default is true
    var shouldUpdateTitleAutomatically = true

    override var canBecomeFirstResponder: Bool {
        return true
    }

    /// - note: always returns UIPickerView instalce
    override var inputView: UIView? {
        return picker
    }

    /// - note: always returns UIToolbar instalce that contains close button
    override var inputAccessoryView: UIView? {
        let toolbar = UIToolbar()
        toolbar.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: 44)
        let closeButton = UIBarButtonItem(title: closeButtonTitle,
                                          style: .done,
                                          target: self,
                                          action: #selector(PickerButton.didTapClose(_:)))
        self.closeButton = closeButton
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
                                    target: nil,
                                    action: nil)
        let items = [space, closeButton]
        toolbar.setItems(items, animated: false)
        toolbar.sizeToFit()

        return toolbar
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }

    private func initialize() {
        addTarget(self,
                  action: #selector(PickerButton.didTap(_:)),
                  for: .touchUpInside)
    }

    @objc func didTapClose(_ button: UIBarButtonItem) {
        resignFirstResponder()
        (delegateProxy?.delegate as? PickerButtonDelegate)?.pickerButtonDidClose(self)
        closeHandler?()
    }

    @objc private func didTap(_ button: PickerButton) {
        becomeFirstResponder()
    }

    private func updateTitle() {
        guard shouldUpdateTitleAutomatically else {
            return
        }

        let title = selectedValues.reduce(into: "") { result, title in
            if result.isEmpty {
                result += title
            } else {
                result += (self.buttonTitleSeparator + title)
            }
        }
        setTitle(title, for: [])
    }

    /// scrolls the specified row to center.
    func selectRow(_ row: Int, inComponent component: Int, animated: Bool) {
        let components = picker.numberOfComponents
        guard components > 0, picker.numberOfRows(inComponent: component) > row else {
            return
        }

        picker.selectRow(row, inComponent: component, animated: animated)
        picker.delegate?.pickerView?(picker, didSelectRow: row, inComponent: component)

        self.selectedValues = (0..<components).map {
            guard picker.numberOfRows(inComponent: $0) > 0 else {
                return ""
            }
            let selectedIndex = picker.selectedRow(inComponent: $0)
            return picker.delegate?.pickerView?(picker, titleForRow: selectedIndex, forComponent: $0) ?? ""
        }
        updateTitle()
    }

    /// returns selected row. -1 if nothing selected
    func selectedRow(inComponent component: Int) -> Int {
        return picker.selectedRow(inComponent: component)
    }
}

// MARK: - UIKeyInput
extension PickerButton: UIKeyInput {

    var hasText: Bool {
        return !selectedValues.isEmpty
    }

    func insertText(_ text: String) {}

    func deleteBackward() {}
}

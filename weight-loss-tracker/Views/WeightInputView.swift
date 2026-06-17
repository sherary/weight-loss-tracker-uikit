//
//  WeightInput.swift
//  weight-loss-tracker
//
//  Created by Sherary Apriliana on 27/05/26.
//

import UIKit

final class WeightInputView: UIView {
    private let weightLbl: UILabel = UILabel()
    private let dateLbl: UILabel = UILabel()
    private let doneButton: UIBarButtonItem = UIBarButtonItem()
    
    internal let weightTxtField: UITextField = UITextField()
    internal let datePicker: UIDatePicker = UIDatePicker()
    internal let saveBtn: UIButton = UIButton()
    internal let tapper: UITapGestureRecognizer = UITapGestureRecognizer()
    
    internal var data: Weights? {
        didSet {
            if let availableData = data {
                let weightInStr = String(availableData.weight).replacingOccurrences(of: ".", with: ",")
                
                weightTxtField.text = "\(weightInStr)"
                datePicker.date = availableData.date
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupLayout()
    }
    
    private func setupLayout() {
        weightLbl.text = "Weight (kg)"
        weightLbl.translatesAutoresizingMaskIntoConstraints = false
        
        weightTxtField.translatesAutoresizingMaskIntoConstraints = false
        weightTxtField.borderStyle = .roundedRect
        weightTxtField.font = .systemFont(ofSize: 16, weight: .regular)
        weightTxtField.textColor = .label
        weightTxtField.textAlignment = .left
        weightTxtField.adjustsFontSizeToFitWidth = false
        weightTxtField.minimumFontSize = 10
        weightTxtField.placeholder = "48,65"
        
        weightTxtField.keyboardType = UIKeyboardType.decimalPad
        weightTxtField.autocapitalizationType = .none
        weightTxtField.autocorrectionType = .no
        weightTxtField.spellCheckingType = .no
        weightTxtField.returnKeyType = UIReturnKeyType.done // redundant for decimalPad & numberPad
        weightTxtField.clearButtonMode = .whileEditing
        weightTxtField.isSecureTextEntry = false
        
        let inputRow = UIStackView(arrangedSubviews: [weightLbl, weightTxtField])
        inputRow.axis = .vertical
        inputRow.spacing = 8
        inputRow.alignment = .fill
        inputRow.distribution = .equalSpacing
        inputRow.translatesAutoresizingMaskIntoConstraints = false
        
        dateLbl.text = "Date"
        dateLbl.translatesAutoresizingMaskIntoConstraints = false
        
        datePicker.date = Date.now
        datePicker.datePickerMode = .date
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.preferredDatePickerStyle = .automatic
        datePicker.locale = Locale(identifier: "id_ID")
        datePicker.maximumDate = Date.now
        
        let dateRow = UIStackView(arrangedSubviews: [dateLbl, datePicker])
        dateRow.axis = .vertical
        dateRow.distribution = .equalSpacing
        dateRow.spacing = 8
        dateRow.alignment = .leading
        dateRow.translatesAutoresizingMaskIntoConstraints = false
        
        saveBtn.translatesAutoresizingMaskIntoConstraints = false
        saveBtn.titleLabel?.text = "Save"
        saveBtn.backgroundColor = .systemBlue
        saveBtn.titleLabel?.textColor = .white
        
        self.addSubview(inputRow)
        self.addSubview(dateRow)
        
        NSLayoutConstraint.activate([
            inputRow.topAnchor.constraint(equalTo: self.layoutMarginsGuide.topAnchor),
            inputRow.leadingAnchor.constraint(equalTo: self.layoutMarginsGuide.leadingAnchor),
            inputRow.trailingAnchor.constraint(equalTo: self.layoutMarginsGuide.trailingAnchor),
            dateRow.topAnchor.constraint(equalTo: inputRow.bottomAnchor, constant: 8),
            dateRow.leadingAnchor.constraint(equalTo: self.layoutMarginsGuide.leadingAnchor),
            dateRow.trailingAnchor.constraint(equalTo: self.layoutMarginsGuide.trailingAnchor)
        ])
    }
}

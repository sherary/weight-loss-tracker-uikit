//
//  WeightInputViewController.swift
//  weight-loss-tracker
//
//  Created by Sherary Apriliana on 27/05/26.
//

import UIKit

final class WeightInputViewController: UIViewController {
    private var weightInputView = WeightInputView()
    private var state: String = ViewActivity.add
    
    internal var availableData: Weights? {
        didSet {
            guard let data = availableData else { return }
            
            weightInputView.data = data
            state = ViewActivity.update
        }
    }
    
    override func loadView() {
        self.view = weightInputView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Weight Input"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Save",
            style: .plain,
            target: self,
            action: #selector(closeSheet)
        )
        
        weightInputView.tapper.addTarget(self, action: #selector(dismissKeyboard))
        weightInputView.tapper.cancelsTouchesInView = false // imprtant - lets button still work
        
        weightInputView.weightTxtField.addAction(UIAction { [weak self] action in
            guard let self, let field = action.sender as? UITextField else { return }
            let parsed = Helpers.removeExcessiveCommas(text: field.text!)
            
            field.text = parsed
            
            weightInputView.saveBtn.isEnabled = !parsed.isEmpty
        }, for: .editingChanged)
    }
    
    @objc private func closeSheet() {
        guard let entry = buildEntry() else { return }
        
        WeightStore.shared.upsertByDate(weight: entry.weight, date: entry.date)
        
        dismiss(animated: true)
    }
    
    @objc private func dismissKeyboard() {
        weightInputView.endEditing(true)
    }
    
    private func buildEntry() -> Weights? {
        guard let weightInStr = weightInputView.weightTxtField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
              !weightInStr.isEmpty,
              let weightValue = Double(weightInStr.replacingOccurrences(of: ",", with: ".")),
              weightValue > 0
        else {
            showAlert()
            
            return nil
        }
        
        var weight: Weights = Weights(date: weightInputView.datePicker.date, weight: weightValue, stepCount: 0, calorieBurned: 0)
        if let data = availableData, state == ViewActivity.update {
            weight.id = data.id
            weight.stepCount = data.stepCount
            weight.calorieBurned = data.calorieBurned
        }
        
        return weight
    }
    
    private func showAlert() {
        let alert = UIAlertController(title: "Could not add new data", message: "You haven't input your weight", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true)
    }
    
    
}

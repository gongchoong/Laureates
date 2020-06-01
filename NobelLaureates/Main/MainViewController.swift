//
//  MainViewController.swift
//  NobelLaureates
//
//  Created by chris davis on 2/15/20.
//  Copyright © 2020 Woohyun David Lee. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    let latitudeTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = " Enter latitude"
        textField.textAlignment = .center
        textField.layer.borderWidth = 0.1
        textField.tintColor = UIColor.lightGray
        textField.layer.cornerRadius = 10
        return textField
    }()
    
    let longitudeTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = " Enter longitude"
        textField.textAlignment = .center
        textField.layer.borderWidth = 0.1
        textField.tintColor = UIColor.lightGray
        textField.layer.cornerRadius = 10
        return textField
    }()
    
    let yearTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = " Enter year"
        textField.textAlignment = .center
        textField.layer.borderWidth = 0.1
        textField.tintColor = UIColor.lightGray
        textField.layer.cornerRadius = 10
        return textField
    }()
    
    let calculateButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Calculate", for: .normal)
        button.backgroundColor = Constant.iosBlueColor
        button.titleLabel?.font = UIFont(name: "Lato-Bold", size: 16)
        button.tintColor = UIColor.white
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(calculateButtonTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var yearPickerView: UIPickerView = {
        let pickerView = UIPickerView()
        return pickerView
    }()
    
    let resultTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    lazy var mainViewModel: MainViewModel = {
        let viewModel = MainViewModel()
        return viewModel
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
        setupViewModel()
    }
    
    fileprivate func setupLayout(){
        //configure tableview, set autolayout
        view.backgroundColor = UIColor.white
        resultTableView.delegate = self
        resultTableView.dataSource = self
        resultTableView.register(LaureateCell.self, forCellReuseIdentifier: LaureateCell.identifier)
        
        view.addSubview(latitudeTextField)
        view.addSubview(longitudeTextField)
        view.addSubview(yearTextField)
        view.addSubview(calculateButton)
        view.addSubview(resultTableView)
        
        NSLayoutConstraint.activate([
            
            latitudeTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            latitudeTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            latitudeTextField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.6),
            latitudeTextField.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.04),
            
            longitudeTextField.topAnchor.constraint(equalTo: latitudeTextField.bottomAnchor, constant: 20),
            longitudeTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            longitudeTextField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.6),
            longitudeTextField.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.04),
            
            yearTextField.topAnchor.constraint(equalTo: longitudeTextField.bottomAnchor, constant: 20),
            yearTextField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.6),
            yearTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            yearTextField.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.04),
            
            calculateButton.topAnchor.constraint(equalTo: yearTextField.bottomAnchor, constant: 20),
            calculateButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            calculateButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            calculateButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.05),
            
            resultTableView.topAnchor.constraint(equalTo: calculateButton.bottomAnchor, constant: 20),
            resultTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            resultTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            resultTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
            
            
        ])
        
        latitudeTextField.addTarget(self, action: #selector(latitudeTextFieldDidChange(_:)), for: .editingChanged)
        latitudeTextField.addDoneButton(title: "Done", target: self, selector: #selector(latitudeDoneButtonPressed))
        longitudeTextField.addTarget(self, action: #selector(longitudeTextFieldDidChange(_:)), for: .editingChanged)
        longitudeTextField.addDoneButton(title: "Done", target: self, selector: #selector(longitudeDoneButtonPressed))
        yearTextField.delegate = self
        setupYearPickerView()
    }
    
    fileprivate func setupViewModel(){
        
        mainViewModel.showErrorMessageClosure = { [weak self] in
            guard let errorMessage = self?.mainViewModel.errorMessage else {return}
            DispatchQueue.main.async {
                self?.showErrorAlert(errorMessage)
            }
        }
        
        mainViewModel.reloadTableViewClosure = { [weak self] in
            DispatchQueue.main.async {
                self?.resultTableView.reloadData()
            }
        }
        
    }
    
    fileprivate func setupYearPickerView(){
        yearPickerView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: view.frame.size.height * 0.3)
        yearPickerView.dataSource = self
        yearPickerView.delegate = self
        
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 44))
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let barButton = UIBarButtonItem(title: "Done", style: .plain, target: target, action: #selector(yearPickerViewDonePressed))
        
        toolBar.setItems([space, barButton], animated: false)
        
        self.yearTextField.inputAccessoryView = toolBar
        self.yearTextField.inputView = yearPickerView
    }
    
    @objc func latitudeTextFieldDidChange(_ textField: UITextField){
        guard let value = textField.text else {return}
        mainViewModel.latitudeInput = Double(value)
    }
    
    @objc func longitudeTextFieldDidChange(_ textField: UITextField){
        guard let value = textField.text else {return}
        mainViewModel.longitudeInput = Double(value)
    }
    
    @objc func latitudeDoneButtonPressed(){
        self.view.endEditing(true)
    }
    
    @objc func longitudeDoneButtonPressed(){
        self.view.endEditing(true)
    }
    
    @objc func yearPickerViewDonePressed(){
        self.view.endEditing(true)
    }

    @objc func calculateButtonTapped(){
        //input validation
        guard let lat: Double = mainViewModel.latitudeInput, let lng: Double = mainViewModel.longitudeInput, let year: Int = mainViewModel.yearInput else {
            showErrorAlert("invalid input")
            return
        }
        if lat > Constant.latitudeUpperBound || lat < Constant.latitudeLowerBound{
            showErrorAlert("latitude value out of bounds")
            return
        }
        if lng > Constant.longitudeUpperBound || lng < Constant.longitudeLowerBound{
            showErrorAlert("longitude value out of bounds")
            return
        }
        if year > Constant.yearUpperBound || year < Constant.yearLowerBound{
            showErrorAlert("year value out of bounds")
            return
        }
        view.endEditing(true)
        //if all inputs are validated, fetch
        mainViewModel.fetch()
    }
    
    fileprivate func showErrorAlert(_ errorMessage: String){
        let alertController = UIAlertController(title: "Error", message: errorMessage, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mainViewModel.numberOfCells
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: LaureateCell.identifier, for: indexPath) as? LaureateCell else {
            return UITableViewCell()
        }
        cell.viewModel = mainViewModel.getViewModel(indexPath: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.frame.size.height/10
    }
}

extension MainViewController: UIPickerViewDelegate, UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Constant.getYears().count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(Constant.getYears()[row])"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let yearValue = "\(Constant.getYears()[row])"
        self.yearTextField.text = yearValue
        mainViewModel.yearInput = Int(yearValue)
    }
}

extension UITextField {
    func addDoneButton(title: String, target: Any, selector: Selector){
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 44))
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let barButton = UIBarButtonItem(title: title, style: .plain, target: target, action: selector)
        
        toolBar.setItems([space, barButton], animated: false)
        self.inputAccessoryView = toolBar
    }
}

extension MainViewController: UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        mainViewModel.yearInput = Constant.getYears()[yearPickerView.selectedRow(inComponent: 0)]
        textField.text = "\(Constant.getYears()[yearPickerView.selectedRow(inComponent: 0)])"
    }
}

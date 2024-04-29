//
//  CityFieldView.swift
//  HadiBilet
//
//  Created by Yunus Emre ÖZŞAHİN on 25.04.2024.
//

import UIKit

protocol CityFieldViewDelegate: AnyObject {
    func cityDidSelect(_ cityFieldView: CityFieldView, selectedCity: String)
}

class CityFieldView: UIView{

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var cityTextField: UITextField!
    
    var pickerView: UIPickerView!
    var cities: [String]!
    
    weak var delegate: CityFieldViewDelegate?
    
    private var view: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        commonInit()
    }
    override init(frame: CGRect) {
        super.init(frame: .zero)
        commonInit()
        self.configureView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
        self.configureView()
    }
    private func commonInit(){
        pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        if let textField = cityTextField {
            textField.inputView = pickerView
            let toolBar = UIToolbar()
            toolBar.sizeToFit()
            let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(dismissPicker))
            toolBar.setItems([doneButton], animated: false)
            textField.inputAccessoryView = toolBar
           } else {
               print("cityTextField is not connected in the XIB/Storyboard")
           }
    }
    func setupPicker(cities: [String]){
        self.cities = cities
    }

    private func loadViewFromNib() -> UIView! {
        let bundle = Bundle(for: type(of: self))
        let name = NSStringFromClass(self.classForCoder).components(separatedBy: ".").last!
        let nib = UINib(nibName: name, bundle: bundle)
        
        let view = nib.instantiate(withOwner: self)[0] as! UIView
        
        view.layer.cornerRadius = 10
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor.black.cgColor
        
        return view
    }
    
    private func configureView() {
        guard let nibView = loadViewFromNib() else { return }
        containerView = view
        bounds = nibView.frame
        addSubview(nibView)
    }
    
    func setup(model: City){
        self.configureView()
        cityTextField.text = model.cityName
    }
}
extension CityFieldView: UIPickerViewDelegate,UIPickerViewDataSource{
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        cityTextField.text = cities[row]
        delegate?.cityDidSelect(self, selectedCity: cities[row])
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return cities.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return cities[row]
    }

    @objc func dismissPicker(){
        self.endEditing(true)
    }
    
    
    
}

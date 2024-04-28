//
//  CityFieldView.swift
//  HadiBilet
//
//  Created by Yunus Emre ÖZŞAHİN on 25.04.2024.
//

import UIKit

class CityFieldView: UIView {

    @IBOutlet weak var containerView: UIView!
    
     @IBOutlet weak var headerLabel: UILabel!
    
    @IBOutlet weak var cityTextField: UITextField!
    
    private var view: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func loadViewFromNib() -> UIView! {
        let bundle = Bundle(for: type(of: self))
        let name = NSStringFromClass(self.classForCoder).components(separatedBy: ".").last!
        let nib = UINib(nibName: name, bundle: bundle)
        
        let view = nib.instantiate(withOwner: self)[0] as! UIView
        
        view.layer.cornerRadius = 10
        
        return view
    }
    
    private func configureView() {
        guard let nibView = loadViewFromNib() else { return }
        containerView = view
        bounds = nibView.frame
        addSubview(nibView)
    }
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    func setup(model: City){
        self.configureView()
        cityTextField.text = model.cityName
    }
    

}
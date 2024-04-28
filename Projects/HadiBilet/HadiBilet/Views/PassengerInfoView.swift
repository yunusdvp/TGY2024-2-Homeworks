//
//  PassengerInfoView.swift
//  HadiBilet
//
//  Created by Yunus Emre ÖZŞAHİN on 28.04.2024.
//

import UIKit

class PassengerInfoView: UIView {

    @IBOutlet weak var passengerIdTextField: UITextField!
    @IBOutlet weak var passengerNameTextField: UITextField!
    @IBOutlet weak var passengerSurnameTextField: UITextField!
    @IBOutlet weak var passengerGenderControl: UISegmentedControl!
    
    private var view: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureView()
    }
    
    private func loadViewFromNib() -> UIView! {
        let bundle = Bundle(for: type(of: self))
        let name = NSStringFromClass(self.classForCoder).components(separatedBy: ".").last!
        let nib = UINib(nibName: name, bundle: bundle)
        
        let view = nib.instantiate(withOwner: self)[0] as! UIView
        
        view.layer.cornerRadius = 6
        
        return view
    }
    
    private func configureView() {
        guard let nibView = loadViewFromNib() else { return }
        nibView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        bounds = nibView.frame
        addSubview(nibView)
    }
    
}

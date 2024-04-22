//
//  StatusView.swift
//  BipClone
//
//  Created by Yunus Emre ÖZŞAHİN on 19.04.2024.
//

import UIKit

class StatusView: UIView {

    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var statusAddedLabel: UILabel!
    @IBOutlet weak var mystatusLabel: UILabel!
    
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
        
        view.layer.cornerRadius = 6
        
        return view
    }
    
    private func configureView() {
        guard let nibView = loadViewFromNib() else { return }
        containerView = view
        bounds = nibView.frame
        addSubview(nibView)
    }
    
    func setup(model: MessageModel) {
        self.configureView()
        statusAddedLabel.text = model.message
        mystatusLabel.text = model.sender
        imageView.image = UIImage(systemName: model.senderImageName ?? "default")
        

    }
}

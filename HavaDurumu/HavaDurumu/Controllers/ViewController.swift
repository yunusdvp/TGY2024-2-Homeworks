//
//  ViewController.swift
//  HavaDurumu
//
//  Created by Yunus Emre ÖZŞAHİN on 30.03.2024.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var cityNameLabel: UILabel!
    
    @IBOutlet weak var degreeLabel: UILabel!
    
    @IBOutlet weak var weatherImageView: UIImageView!
    
    //@IBOutlet weak var weatherCollectionView: UICollectionView!
    
    @IBOutlet weak var humidityLabel: UILabel!
    
    
    @IBOutlet weak var popLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        fetchFiveDayForecast(latitude: 36.68, longitude: 33.83, apiKey: "4c2aa4b5ab67ec27c9597734c38ef6d9")
        
    }
    


}

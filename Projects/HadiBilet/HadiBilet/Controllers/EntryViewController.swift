import UIKit


class EntryViewController: UIViewController{
    
    //@IBOutlet weak var neredenView: CityFieldView!
    
    @IBOutlet weak var neredenTextField: UITextField!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var NereyeTextField: UITextField!
    // @IBOutlet weak var nereyeView: CityFieldView!
    override func viewDidLoad() {
        super.viewDidLoad()
        print(datePicker.date.hashValue)
        
        
        /*let model = City(cityName: "Mersin")
        let model2 = City(cityName: "İstanbul")
        neredenView.setup(model: model)
        nereyeView.setup(model: model2)
        neredenView.headerLabel.text = "Nereden"
        nereyeView.headerLabel.text = "Nereye"
        */
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToSecondViewController" {
            if let destinationVC = segue.destination as? ViewController {
                destinationVC.nereden = neredenTextField.text
                destinationVC.nereye = NereyeTextField.text
                

                // UIDatePicker nesnesinin bir örneğini oluşturun.

                // datePicker'dan seçilen tarih örneğini alın.
                let selectedDate = datePicker.date
                // Calendar sınıfını kullanarak tarih bileşenlerini alın.
                let calendar = Calendar.current
                let month = calendar.component(.month, from: selectedDate)
                let day = calendar.component(.day, from: selectedDate)
                // Şimdi "month" değişkeni, yılın kaçıncı ayı olduğunu tutar (1-12 arası).
                destinationVC.day = day
                destinationVC.month = month

            }
        }
    }

    
    
    
    
    @IBAction func reverseCityButtonA(_ sender: UIButton) {
        performSegue(withIdentifier: "goToSecondViewController", sender: self)
    }
    
    /*@IBAction func goButton(_ sender: UIButton) {
    }*/
    
}

import UIKit


class EntryViewController: UIViewController{
    
    @IBOutlet weak var neredenView: CityFieldView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var nereyeView: CityFieldView!
    let cities = ["Mersin","Adana","İstanbul","Ankara"]
    override func viewDidLoad() {
        super.viewDidLoad()
        neredenView.delegate = self
        nereyeView.delegate = self
        neredenView.setupPicker(cities: cities)
        nereyeView.setupPicker(cities: cities)
        nereyeView.headerLabel.text = "Nereye"
        datePicker.minimumDate = Date()
        addDismissKeyboardTapGesture()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToSecondViewController" {
            if let destinationVC = segue.destination as? ViewController {
                destinationVC.nereden = neredenView.cityTextField.text
                destinationVC.nereye = nereyeView.cityTextField.text
                let selectedDate = datePicker.date
                let calendar = Calendar.current
                let month = calendar.component(.month, from: selectedDate)
                let day = calendar.component(.day, from: selectedDate)
                destinationVC.day = day
                destinationVC.month = month

            }
        }
    }
    
    func showAlert(message: String) {
        let okAction = UIAlertAction(title: "Tamam", style: .default, handler: nil)
        AlertManager.shared.showAlert(title: "Hata", message: message, on: self, actions: [okAction])
    }
    
    @IBAction func searchButton(_ sender: UIButton) {
        guard let nereden = neredenView.cityTextField.text, !nereden.isEmpty,
                  let nereye = nereyeView.cityTextField.text, !nereye.isEmpty else {
                showAlert(message: "Lütfen şehir seçimini yapın.")
                return
            }
            performSegue(withIdentifier: "goToSecondViewController", sender: self)
    }
}

extension EntryViewController: CityFieldViewDelegate{
    func cityDidSelect(_ cityFieldView: CityFieldView, selectedCity: String) {
        if cityFieldView == neredenView {
                    nereyeView.setupPicker(cities: cities.filter { $0 != selectedCity })
                } else if cityFieldView == nereyeView {
                    neredenView.setupPicker(cities: cities.filter { $0 != selectedCity })
                }
    }
    
}

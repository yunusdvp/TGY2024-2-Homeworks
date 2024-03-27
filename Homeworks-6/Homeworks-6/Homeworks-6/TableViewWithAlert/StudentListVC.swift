//
//  StudentListVC.swift
//  Homeworks-6
//
//  Created by Yunus Emre ÖZŞAHİN on 27.03.2024.
//



import UIKit

class StudentListVC: UIViewController {

    @IBOutlet weak var studentTable: UITableView!
    var students: [Student] = [] // Öğrenci listesi
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // TableView'ı ayarla
        studentTable.dataSource = self
        studentTable.delegate = self
        
    }

    @IBAction func addBarButtonItem(_ sender: UIBarButtonItem) {
        let alertController = UIAlertController(title: "Öğrenci Ekle", message: "Öğrenci adını giriniz", preferredStyle: .alert)
        
        alertController.addTextField { (textField) in
            textField.placeholder = "Öğrenci Adı"
        }
        
        let addAction = UIAlertAction(title: "Ekle", style: .default) { [weak self] (_) in
            guard let textField = alertController.textFields?.first, let name = textField.text, !name.isEmpty else { return }
            
            let student = Student()
            student.name = name
            
            self?.students.append(student)
            self?.studentTable.reloadData()
        }
        
        let cancelAction = UIAlertAction(title: "İptal", style: .cancel, handler: nil)
        
        alertController.addAction(addAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    }


extension StudentListVC: UITableViewDataSource, UITableViewDelegate {
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return students.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "studentCell", for: indexPath)
        let student = students[indexPath.row]
        cell.textLabel?.text = student.name
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    // Silme işlemini gerçekleştirmek için
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            if editingStyle == .delete {
                
                let alertController = UIAlertController(title: "Silme İşlemi", message: "Silmek istediğinizden emin misiniz?", preferredStyle: .alert)
                
                let evetAction = UIAlertAction(title: "Evet", style: .destructive) { [weak self] (_) in
                    // Kullanıcı evet derse silme işlemini gerçekleştir
                    self?.deleteStudent(at: indexPath)
                }
                
                let hayirAction = UIAlertAction(title: "Hayır", style: .cancel, handler: nil)
                
                alertController.addAction(evetAction)
                alertController.addAction(hayirAction)
                
                present(alertController, animated: true, completion: nil)
            }
        }
        
        private func deleteStudent(at indexPath: IndexPath) {
            // Öğrenciyi listeden sil
            students.remove(at: indexPath.row)
            studentTable.deleteRows(at: [indexPath], with: .fade)
        }
    }


//
//  ScrumViewController.swift
//  scrum
//
//  Created by Anton Shcherbakov on 24/09/2016.
//  Copyright © 2016 Styleru. All rights reserved.
//

import UIKit

class ScrumViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var todoButtonOutlet: UIButton!
    @IBOutlet weak var alertsButtonOutlet: UIButton!
    
    @IBOutlet weak var toDoView: UIView!
    @IBOutlet weak var alertsView: UIView!
    
    let serverClass = ServerClass()
    let ud: UserDefaults = UserDefaults.standard
    var userData: [[Dictionary<String,String>]] = []
    var openedTable: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let id = self.ud.value(forKey: "id")
        self.getData(id as! String)
        if self.ud.value(forKey: "first") == nil {
            serverClass.sendOneSignalGuid(id as! String)
            self.ud.set("1", forKey: "first")
        }
        
        let view = UIView(frame:
            CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.size.width, height: 20.0)
        )
        view.backgroundColor = UIColor.init(colorLiteralRed: 46.0/255.0, green: 64.0/255.0, blue: 78.0/255.0, alpha: 1.0)

        self.view.addSubview(view)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if self.openedTable {
            let alert = UIAlertController(title: "Тасков нет!", message: "Test", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Алертов нет", message: "Test", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBAction func logoutButton(_ sender: AnyObject) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func toDoButton(_ sender: AnyObject) {
        
        UIView.animate(withDuration: 0.3) {
            self.todoButtonOutlet.setTitleColor(UIColor.init(colorLiteralRed: 31.0/255.0, green: 31.0/255.0, blue: 31.0/255.0, alpha: 10.0), for: .normal)
            self.toDoView.backgroundColor = UIColor.init(colorLiteralRed: 31.0/255.0, green: 31.0/255.0, blue: 31.0/255.0, alpha: 10.0)
            
            self.alertsButtonOutlet.setTitleColor(UIColor.init(colorLiteralRed: 108.0/255.0, green: 108.0/255.0, blue: 108.0/255.0, alpha: 10.0), for: .normal)
            self.alertsView.backgroundColor = UIColor.clear
        }
        self.openedTable = true
        if self.userData[0].count == 0 {
            self.showAlert("Тасков нет", alertMessage: "Test")
        } else {
            self.tableView.reloadData()
        }

    }
    @IBAction func alertsButton(_ sender: AnyObject) {
        
        UIView.animate(withDuration: 0.3) {
            self.todoButtonOutlet.setTitleColor(UIColor.init(colorLiteralRed: 108.0/255.0, green: 108.0/255.0, blue: 108.0/255.0, alpha: 10.0), for: .normal)
            self.toDoView.backgroundColor = UIColor.clear
            
            self.alertsButtonOutlet.setTitleColor(UIColor.init(colorLiteralRed: 31.0/255.0, green: 31.0/255.0, blue: 31.0/255.0, alpha: 10.0), for: .normal)
            self.alertsView.backgroundColor = UIColor.init(colorLiteralRed: 31.0/255.0, green: 31.0/255.0, blue: 31.0/255.0, alpha: 10.0)
        }
        self.openedTable = false
        if self.userData[1].count == 0 {
            let alert = UIAlertController(title: "Алертов нет", message: "Test", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else {
            self.tableView.reloadData()
        }
        
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.userData.count != 0 {
        if self.openedTable {
            return self.userData[0].count
        } else {
            return self.userData[1].count
            }
        } else {
            return 0
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: TableViewCell = tableView.dequeueReusableCell(withIdentifier: "todo") as! TableViewCell
        
        cell.selectionStyle = .none
        
        if self.openedTable {

            cell.name.text = self.userData[0][indexPath.row]["name"]
            cell.project.text = String("Проект \(self.userData[0][indexPath.row]["project_name"]!)")
            cell.deadline.text = self.userData[0][indexPath.row]["deadline"]
        
        } else {

            cell.name.text = self.userData[1][indexPath.row]["name"]
            cell.project.text = self.userData[1][indexPath.row]["date"]
            cell.deadline.text = ""
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.openedTable {
            self.showAlert(self.userData[0][indexPath.row]["name"]!, alertMessage: self.userData[0][indexPath.row]["deadline"]!)
        } else {
            self.showAlert(self.userData[1][indexPath.row]["name"]!, alertMessage: self.userData[1][indexPath.row]["date"]!)
        }
    }
    
    func getData(_ userId: String) {
        
        self.userData = []
        
        self.serverClass.getToDo(userId) { response in
            print(response)
            self.userData.append(response as [Dictionary<String,String>])
            self.serverClass.getAlerts(userId) { response in
                print(response)
                self.userData.append(response as [Dictionary<String,String>])
                if self.userData[0].count == 0 && self.userData[1].count == 0 {
                    let alert = UIAlertController(title: "Пусто", message: "Test", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                } else {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    @IBAction func reloadData(_ sender: AnyObject) {
        self.getData(self.ud.value(forKey: "id") as! String)
    }
    
    func showAlert(_ alertTitle: String, alertMessage: String) {
        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

}

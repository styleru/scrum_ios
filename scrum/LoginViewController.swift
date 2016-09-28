//
//  LoginViewController.swift
//  scrum
//
//  Created by Anton Shcherbakov on 24/09/2016.
//  Copyright © 2016 Styleru. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passTextField: UITextField!
    
    let serverClass = ServerClass()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
    
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.loginTextField.text = ""
        self.passTextField.text = ""
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        super.touchesBegan(touches, with: event)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func loginButton(_ sender: AnyObject) {
        serverClass.login(loginTextField.text!, pass: passTextField.text!) { response in
            if response! == "200" {
                self.performSegue(withIdentifier: "toApp", sender: self)
            } else {
                let alert = UIAlertController(title: "Test", message: "Test", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }

}


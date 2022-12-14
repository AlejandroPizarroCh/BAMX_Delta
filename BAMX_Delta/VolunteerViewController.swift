//
//  VolunteerViewController.swift
//  BAMX_Delta
//
//  Created by Alejandro Pizarro on 24/11/22.
//

import Foundation
import UIKit
import Firebase

class VolunteerViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var textEmail: UITextField!
    @IBOutlet weak var textMessage: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    
    let ref = Database.database().reference(withPath: "Voluntarios")
    
    
    @IBOutlet weak var picker: UIPickerView!
    var pickerData: [String] = [String]()
    
    var defaultChoice = 0


    override func viewDidLoad() {
        registerButton.layer.cornerRadius = 10
        super.viewDidLoad()
        // Connect data:
        self.picker.delegate = self
        self.picker.dataSource = self
        
        // Input the data into the array
        pickerData = ["Cualquier campaña", "Alimenta", "Al rescate"]
        picker.selectRow(defaultChoice, inComponent: 0, animated: true)
    }
    
    // MARK: Area de funciones
    
    func verifyEmail(email: String) -> Bool{
        let emailRegex = "^[\\p{L}0-9!#$%&'*+\\/=?^_`{|}~-][\\p{L}0-9.!#$%&'*+\\/=?^_`{|}~-]{0,63}@[\\p{L}0-9-]+(?:\\.[\\p{L}0-9-]{2,7})*$"
        
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        
        if emailPredicate.evaluate(with: textEmail.text!)
        {
            return true
        }
        else{
            return false
        }
    }
    
    func displayAlertMessage(message:String){
        let alertController = UIAlertController(title: "Mensaje de la aplicación", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func displayAlertMessageBlank(message:String){
        let alertController = UIAlertController(title: "Mensaje de la aplicación", message: message, preferredStyle: .alert)
        self.present(alertController, animated: true, completion: nil)
        
        let when = DispatchTime.now() + 2
        DispatchQueue.main.asyncAfter(deadline: when){
            alertController.dismiss(animated: true, completion: nil)
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    
    // MARK: Registrar voluntario
    
    @IBAction func registerVolunteer(_ sender: Any) {
        
        let key = UUID().uuidString
        let object : [String:Any] = [
            "contacto" : self.textEmail.text!,
            "mensaje" : self.textMessage.text!,
            "campaña" : pickerData[self.picker.selectedRow(inComponent:0)]
        ]
        
        if textEmail.text?.isEmpty == true {
            displayAlertMessage(message: "Tienes campos de texto vacíos")
        }else{
            if verifyEmail(email: textEmail.text!){
                ref.child(key).setValue(object){
                    (error: Error?, ref:DatabaseReference) in
                    
                    var message = ""
                    
                    if let error = error {
                        message = "Ha ocurrido un error"
                        print(error)
                    }
                    else{
                        message = "Voluntariado registrado exitosamente!"
                    }
                    self.displayAlertMessageBlank(message: message)
                }
                
            }
        }
        
    }
}

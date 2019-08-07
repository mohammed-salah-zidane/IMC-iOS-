//
//  DoctorReserveTableViewController.swift
//  IMC
//
//  Created by Mohamed Salah Zidane on 1/30/19.
//  Copyright © 2019 Mohamed Salah Zidane. All rights reserved.
//

import UIKit

var segueDoctorId = 0
var segueExpertId = 0
class ReserveTableViewController: UITableViewController, UITextFieldDelegate,UITextViewDelegate {
    
    @IBAction func closeButton(_ sender: Any) {
        //dismiss(animated: false, completion: nil)
        self.navigationController?.popViewController(animated: true)
    }
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var phoneNumTextField: UITextField!
    @IBOutlet var plainViewText: UITextView!
    @IBOutlet var reservationButton: UIBarButtonItem!
    @IBAction func reserveButtonHandler(_ sender: Any) {
        if let phone = phoneNumTextField.text , let name = nameTextField.text , let plain = plainViewText.text{
            if !phone.isBlank  || !name.isBlank || !plain.isBlank{
                print(segueDoctorId)
                if phone.isAlphanumeric {
                    print("in")
                    let valid = UIImage(named:"valid")
                    addLeftImageTo(txtField: phoneNumTextField, andImage: valid!)
                    phoneNumTextField.leftView?.isHidden = false
                    if segueDoctorId != 0 && segueExpertId == 0 {
                        
                        
                        API.doctorReserveDate(id: segueDoctorId, name: name, phone: phone, plain: plain) { (error, success) in
                            if success {
                                print("success doctor reserve")
                            }
                        }
                    }else if segueDoctorId == 0 && segueExpertId != 0{
                        
                        API.expertReserveDate(id: segueDoctorId, name: name, phone: phone, plain: plain)
                        { (error, success) in
                            if success {  print("success expert reserve")  }
                        }
                    }
                    dismiss(animated: false, completion: nil)
                    
                }else{
                    let error = UIImage(named:"error")
                    addLeftImageTo(txtField: phoneNumTextField, andImage: error!)
                    phoneNumTextField.leftView?.isHidden = false
                    return
                }
                let alert = UIAlertController(title: "Oops", message: "عفوا لا يمكن اجراء الطلب ,لان هناك بعض الخانات فارغه , الرجاء ملئ جميع الخانات", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "أوكي", style: .default, handler: nil)
                alert.addAction(okAction)
                present(alert ,animated: true,completion: nil)
                return
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedAround()
        
        
        let gesture = UISwipeGestureRecognizer(target: self, action: #selector(dismiss(fromGesture:)))
        tableView.addGestureRecognizer(gesture)
        
        nameTextConfiguration()
        phoneTextConfiguration()
        plainTextConfiguration()
        
        plainViewText.text = "اكتب شكوتك الطبيه هنا....."
        plainViewText.textColor = UIColor.lightGray
        
        
        plainViewText.delegate = self
        phoneNumTextField.delegate = self
        nameTextField.delegate = self
        
        
        let nameImage = UIImage(named:"nameicon")
        addRightImageTo(txtField: nameTextField, andImage: nameImage!)
        
        let phoneImage = UIImage(named:"phoneNum")
        addRightImageTo(txtField: phoneNumTextField, andImage: phoneImage!)
        
        let error = UIImage(named:"error")
        addLeftImageTo(txtField: phoneNumTextField, andImage: error!)
        phoneNumTextField.leftView?.isHidden = true
        
        
    }
    
    
    @objc func dismiss(fromGesture gesture: UISwipeGestureRecognizer) {
        //Your dismiss code
        //Here you should implement your checks for the swipe gesture
        dismiss(animated: true, completion: nil)
    }
    func addLeftImageTo(txtField: UITextField, andImage img: UIImage) {
        let leftImageView = UIImageView(frame: CGRect(x: 0.0, y: 0.0, width: img.size.width, height: img.size.height))
        leftImageView.image = img
        txtField.leftView = leftImageView
        txtField.leftViewMode = .always
    }
    func addRightImageTo(txtField: UITextField, andImage img: UIImage) {
        let leftImageView = UIImageView(frame: CGRect(x: 0.0, y: 0.0, width: img.size.width, height: img.size.height))
        leftImageView.image = img
        txtField.rightView = leftImageView
        txtField.rightViewMode = .always
    }
    func nameTextConfiguration (){
        nameTextField.layer.cornerRadius = 10
        let shadowPath2 = UIBezierPath(rect: nameTextField.bounds)
        nameTextField.layer.masksToBounds = false
        nameTextField.layer.shadowColor = UIColor(red: 14.0/255.0, green:175.0/255.0, blue: 127.0/255.0, alpha: 1.0).cgColor
        nameTextField.layer.shadowOffset = CGSize(width: CGFloat(1.0), height: CGFloat(1.0))
        nameTextField.layer.shadowOpacity = 1
        nameTextField.layer.shadowPath = shadowPath2.cgPath
    }
    func phoneTextConfiguration (){
        phoneNumTextField.layer.cornerRadius = 10
        
        let shadowPath2 = UIBezierPath(rect: phoneNumTextField.bounds)
        phoneNumTextField.layer.masksToBounds = false
        phoneNumTextField.layer.shadowColor = UIColor(red: 14.0/255.0, green:175.0/255.0, blue: 127.0/255.0, alpha: 1.0).cgColor
        phoneNumTextField.layer.shadowOffset = CGSize(width: CGFloat(1.0), height: CGFloat(1.0))
        phoneNumTextField.layer.shadowOpacity = 1
        phoneNumTextField.layer.shadowPath = shadowPath2.cgPath
    }
    func plainTextConfiguration (){
        plainViewText.layer.cornerRadius = 10
        plainViewText.layer.borderWidth = 3.5
        
        let shadowPath2 = UIBezierPath(rect: plainViewText.bounds)
        plainViewText.layer.masksToBounds = false
        plainViewText.layer.shadowColor = UIColor(red: 14.0/255.0, green:175.0/255.0, blue: 127.0/255.0, alpha: 1.0).cgColor
        plainViewText.layer.shadowOffset = CGSize(width: CGFloat(1.0), height: CGFloat(1.0))
        plainViewText.layer.shadowOpacity = 1
        plainViewText.layer.shadowPath = shadowPath2.cgPath
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if plainViewText.textColor == UIColor.lightGray{
            plainViewText.text = nil
            plainViewText.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if plainViewText.text.isEmpty{
            plainViewText.text = "اكتب شكوتك الطبيه هنا....."
            plainViewText.textColor = UIColor.lightGray
        }
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let phone = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        
        if phone.isAlphanumeric {
            
            
            textField.rightView?.isHidden = false
        } else {
            textField.rightView?.isHidden = true
        }
        
        return true
    }
    @IBAction func unwindToDoctorScreen(segue:UIStoryboardSegue) {
        
    }
    
}

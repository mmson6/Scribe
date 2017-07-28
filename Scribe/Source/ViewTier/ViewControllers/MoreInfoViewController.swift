//
//  MoreInfoViewController.swift
//  Scribe
//
//  Created by Mikael Son on 7/27/17.
//  Copyright © 2017 Mikael Son. All rights reserved.
//

import UIKit

import FirebaseDatabase


class MoreInfoViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var churchPickerView: UIPickerView!
    
    var requestModel: SignUpRequest?
//    let churchs = ["US, Chicago",
//                   "US, Atlanta",
//                   "US, Michigan",
//                   "US, New Jersey",
//                   "US, New York",
//                   "US, Washington",
//                   "US, S. Illinois"]
    let churchs = ["US, Chicago"]
    var selectedChurch = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: IBAction Functions
    
    @IBAction func signUpButtonTapped(_ sender: Any) {
        guard let model = self.requestModel else { return }
        
        let first = model.first
        let last = model.last
        let email = model.email
        let password = model.password
        let church = self.selectedChurch
        
        let parts = email.components(separatedBy: ".")
        var composed = ""
        for part in parts {
            composed.append(part)
            if parts.last != part {
                composed.append("_")
            }
        }
        let request = "\(composed)-\(first)_\(last)-\(church)"
        
        let ref = Database.database().reference(fromURL: AppConfiguration.baseURL)
        let path = "signup_request"
        let requestRef = ref.child(path)
        let status = "request pending"
        let object = ["status": status] as Any
        
        requestRef.child(request).setValue(object) { (error, ref) in
            if let error = error {
                print(error)
            } else {
                self.performSegue(withIdentifier: "unwindToLoginView", sender: nil)
            }
        }
        //--------------------------------------------
        //        let ref = Database.database().reference(fromURL: AppConfiguration.baseURL)
        //        let contactRef = ref.child("contacts")
        //
        //        for (index, object) in ctd.enumerated() {
        //            print("hahaha")
        //            contactRef.child("\(index+1)").setValue(object)
        //        }
        
        //
        //        contactRef.observe(.childAdded, with: { snap in
        //            guard
        //                let json = snap.value as? JSONObject
        //                else {
        //                    return
        //            }
        //
        //            let group = json["group"] as? String
        //            let teacher = json["teacher"] as? Bool
        //            let choir = json["choir"] as? Bool
        //            let translator = json["translator"] as? Bool
        //            let engName = json["name_eng"] as? String
        //            let korName = json["name_kor"] as? String
        //
        //            let contactsNameRef = ref.child("contacts_name")
        //            contactsNameRef.child(snap.key).setValue(
        //                ["name_eng": engName as Any,
        //                 "name_kor": korName as Any,
        //                 "group": group as Any,
        //                 "teacher": teacher as Any,
        //                 "choir": choir as Any,
        //                 "translator": translator as Any
        //                ])
        //
        //        })
        //        self.showLoadingIndicator()
        //
        //        let email = "mson62@gmail.com"
        //        let password = "123456"
        //
        //        Auth.auth().signIn(withEmail: email, password: password) { [weak self] (user, error) in
        //            guard let strongSelf = self else { return }
        //            
        //            if let user = user {
        //                strongSelf.hideLoadingIndicator()
        //                strongSelf.performSegue(withIdentifier: "loginToLanding", sender: nil)
        //            }
        //        }
    }
    
    // MARK: PickerView Related Delegate Functions
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.churchs.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        self.churchPickerView.subviews[1].isHidden = true
        self.churchPickerView.subviews[2].isHidden = true
        
        return self.churchs[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.selectedChurch = self.churchs[row]
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
}

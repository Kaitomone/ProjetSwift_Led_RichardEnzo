//
//  ViewController.swift
//  MQTTSample
//
//  Created by anoop mohanan on 19/05/18.
//  Copyright © 2018 com.anoopm. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    private var mqttManager:MQTTManager!
    @IBOutlet weak var usagerTxtField: UITextField!
    @IBOutlet weak var motDePasseTxtField: UITextField!
    @IBOutlet weak var messageTxtField: UITextField!
    @IBOutlet weak var connectBtn: UIButton!
    @IBOutlet weak var sendBtn: UIButton!
    @IBOutlet weak var setTopicBtn: UIButton!
    @IBOutlet weak var statusView: UIView!
    @IBOutlet weak var statusLabl: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        resetUIWithConnection(status: false)
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func connect(){

        guard let usagerVal = usagerTxtField.text, let motDePasseVal = motDePasseTxtField.text  else {

            return
        }
        
        if (usagerVal.isEmpty && motDePasseVal.isEmpty) {
            //update(message: "Veuillez remplir les champs de connexion")
            return
        }
        mqttManager = MQTTManager.shared(with: self.title!, host: usagerVal,topic: motDePasseVal, presenter: self)
        mqttManager.connect()
        
    }
    @IBAction func send(){
        guard let msg = messageTxtField.text else {
            return
        }
        send(message: msg)
        messageTxtField.text = ""
    }
    func send(message: String){
        
        mqttManager.publish(with: message)
    }

}

extension ViewController: PresenterProtocol{
    func update(message: String) {
        <#code#>
    }
    
    
    func resetUIWithConnection(status: Bool){
        
        usagerTxtField.isEnabled = !status
        motDePasseTxtField.isEnabled = !status
        messageTxtField.isEnabled = status
        connectBtn.isEnabled = !status
        sendBtn.isEnabled = status
        
        if (status){
            updateStatusViewWith(status: "Connecter")
        }else{
            updateStatusViewWith(status: "Déconnecter")
        }
    }
    func updateStatusViewWith(status: String){
        
        statusLabl.text = status
    }
    
    /*func update(message: String){
        
        if let text = messageHistoryView.text{
            let newText = """
            \(text)
            \(message)
            """
            messageHistoryView.text = newText
        }else{
            let newText = """
            \(message)
            """
            messageHistoryView.text = newText
        }
        
        let myRange=NSMakeRange(messageHistoryView.text.count-1, 0);
        messageHistoryView.scrollRangeToVisible(myRange)
        
        
    }*/
    
    
}


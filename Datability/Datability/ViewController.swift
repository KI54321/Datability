//
//  ViewController.swift
//  Datability
//
//  Created by Krish Iyengar on 9/2/22.
//

import UIKit
import SwiftUI
import FirebaseAuth

class ViewController: UIViewController {

    var dataLoginHostingController: UIHostingController<DatabilityLogin>? = nil
    
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        dataLoginHostingController = UIHostingController(rootView: DatabilityLogin(dataVC: self))

        if Auth.auth().currentUser == nil {
            loadDataHostingView()
        }
        else {
            guard let currentUserID = Auth.auth().currentUser?.uid else { return }
            DatabilityUserLoginFirebase.getUser(currentUserID: currentUserID)
        }
    }
    
    func removeDataHostingView() {
        guard let dataLoginHostingController = dataLoginHostingController else { return }

        dataLoginHostingController.removeFromParent()
        dataLoginHostingController.view.removeFromSuperview()
    }
    func loadDataHostingView() {
        guard let dataLoginHostingController = dataLoginHostingController else { return }
        self.addChild(dataLoginHostingController)
        view.addSubview(dataLoginHostingController.view)
        
        dataLoginHostingController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            dataLoginHostingController.view.topAnchor.constraint(equalTo: view.topAnchor),
            dataLoginHostingController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            dataLoginHostingController.view.rightAnchor.constraint(equalTo: view.rightAnchor),
            dataLoginHostingController.view.leftAnchor.constraint(equalTo: view.leftAnchor)
        ])
    }


}


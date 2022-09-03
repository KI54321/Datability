//
//  ViewController.swift
//  Datability
//
//  Created by Krish Iyengar on 9/2/22.
//

import UIKit
import SwiftUI
import FirebaseAuth
import NaturalLanguage

class ViewController: UIViewController {

    var dataLoginHostingController: UIHostingController<DatabilityLogin>? = nil
    var dataChallengesHostingController: UIHostingController<HomeBottomBar>? = nil

  
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        dataLoginHostingController = UIHostingController(rootView: DatabilityLogin(dataVC: self))
        dataChallengesHostingController = UIHostingController(rootView: HomeBottomBar(dataVC: self))
        
        
        if Auth.auth().currentUser == nil {
            loadDataHostingView()
        }
        else {
//            guard let currentUserID = Auth.auth().currentUser?.uid else { return }
//            DatabilityUserLoginFirebase.getUser(currentUserID: currentUserID)
//            
            loadDataChallengesHostingView()
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
    func removeDataChallengesView() {
        guard let dataHostingController = dataChallengesHostingController else { return }

        dataHostingController.removeFromParent()
        dataHostingController.view.removeFromSuperview()
    }
    func loadDataChallengesHostingView() {
        guard let dataHostingController = dataChallengesHostingController else { return }
        self.addChild(dataHostingController)
        view.addSubview(dataHostingController.view)
        
        dataHostingController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            dataHostingController.view.topAnchor.constraint(equalTo: view.topAnchor),
            dataHostingController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            dataHostingController.view.rightAnchor.constraint(equalTo: view.rightAnchor),
            dataHostingController.view.leftAnchor.constraint(equalTo: view.leftAnchor)
        ])
    }

}


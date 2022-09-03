//
//  DatabilityPersonalInfo.swift
//  Datability
//
//  Created by Krish Iyengar on 9/2/22.
//

import SwiftUI

import PermissionsSwiftUI
struct DatabilityPersonalInfo: View {
    @State var dataTextName: String = ""
    @State var dataTextPhoneNumber: String = ""
    @Binding var dataTextEmail: String
    
    var dataVC: ViewController
    @Binding var shouldPresentPersonalInfo: Bool
    @State var continueOnboarding: Bool = false
    @Binding var passwordEntered: String
    var body: some View {
        NavigationView {
            GeometryReader { dataProxy in
                
                
                VStack {
                    
                    Spacer()
                    
                    
                    TextField("John Appleseed", text: $dataTextName)
                        .padding(.all, 10)
                        .background(RoundedRectangle(cornerRadius: 20).stroke(LinearGradient(gradient: Gradient(colors: [Color(red: 0.2, green: 0.58, blue: 0.9), Color(red: 0.93, green: 0.43, blue: 0.68)]), startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: 2))
                        .textFieldStyle(.plain)
                        .frame(maxWidth: .infinity)
                        .padding()
                    
                    TextField("+1-xxx-xxx-xxxx", text: $dataTextPhoneNumber)
                        .padding(.all, 10)
                        .background(RoundedRectangle(cornerRadius: 20).stroke(LinearGradient(gradient: Gradient(colors: [Color(red: 0.2, green: 0.58, blue: 0.9), Color(red: 0.93, green: 0.43, blue: 0.68)]), startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: 2))
                        .textFieldStyle(.plain)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .keyboardType(.phonePad)
                    
                    Button {
                        continueOnboarding = true
                    } label: {
                        Text("Let's Go")
                            .frame(width: 300, height: 40)
                            .background(Color.blue)
                            .foregroundColor(.white)
                    }
                    .cornerRadius(20)
                    .padding()
                    
                    
                    
                    
                    
                    Spacer()
                    
                }
                
                .edgesIgnoringSafeArea(.all)
                .background(Image("wallpaper")
                    .resizable()
                    .ignoresSafeArea()
                    .frame(width: dataProxy.size.width, height: dataProxy.size.height, alignment: .center)
                    .aspectRatio(contentMode: .fit))
                
                
                .navigationTitle("Personal Info")
                .JMModal(showModal: $continueOnboarding, for: [.location, .camera], autoCheckAuthorization: false, restrictDismissal: true, onAppear: {
                    
                }, onDisappear: {
                    
                    // Done onboarding
                    UserDefaults.standard.set(dataTextName, forKey: "fullNameLocal")
                    UserDefaults.standard.set(dataTextEmail, forKey: "emailLocal")
                    UserDefaults.standard.set(0.0, forKey: "challengesCompletedLocal")
                    UserDefaults.standard.set(0.0, forKey: "moneyTilNextPaymentLocal")
                    UserDefaults.standard.set(dataTextPhoneNumber, forKey: "phoneNumberLocal")
                    UserDefaults.standard.set(0.0, forKey: "totalMoneyEarnedLocal")
                    UserDefaults.standard.set(0.0, forKey: "totalSnapsTakenLocal")
                    
                    DatabilityUserLoginFirebase.uploadUser(dataTextName: dataTextName, dataTextEmail: dataTextEmail, dataTextPhoneNumber: dataTextPhoneNumber, password: passwordEntered)
                    
                    shouldPresentPersonalInfo = false
                    dataVC.removeDataHostingView()
                    dataVC.loadDataChallengesHostingView()

                })
                
                .onTapGesture {
                    UIApplication.shared.resignFirstResponder()
                }
                
            }
        }
    }
}

struct DatabilityPersonalInfo_Previews: PreviewProvider {
    static var previews: some View {
        Text("Personal Info")
//        DatabilityPersonalInfo()
    }
}

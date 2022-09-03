//
//  DatabilityLogin.swift
//  Datability
//
//  Created by Krish Iyengar on 9/2/22.
//

import SwiftUI
import FirebaseAuth

struct DatabilityLogin: View {
    @State var dataTextEmail: String = ""
    @State var dataTextPassword: String = ""

    var dataVC: ViewController
    @State var showPermissions: Bool = false
    @State var continueOnboarding: Bool = false
    
    var body: some View {
        NavigationView {
            GeometryReader { dataProxy in
                
                
                VStack {
                    
                    Image("datability_logoV2")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 300, height: 300, alignment: .center)
                        .padding(.bottom, 30).padding(.top, 30)
                    TextField("Email", text: $dataTextEmail)
                        .padding(.all, 10)
                        .background(RoundedRectangle(cornerRadius: 20).stroke(Color(red: 0.51, green: 0.7, blue: 0.64), lineWidth: 2))
                        .textFieldStyle(.plain)
                        .frame(maxWidth: .infinity)
                        .padding()
                    
                    TextField("Password", text: $dataTextPassword)
                        .padding(.all, 10)
                        .background(RoundedRectangle(cornerRadius: 20).stroke(Color(red: 0.51, green: 0.7, blue: 0.64), lineWidth: 2))
                        .textFieldStyle(.plain)
                        .frame(maxWidth: .infinity)
                        .padding()
                    
                    Button {
                        Auth.auth().signIn(withEmail: dataTextEmail, password: dataTextPassword) { didSignInResult, signInResultError in
                            if signInResultError == nil && didSignInResult != nil {
                                guard let currentUID = didSignInResult?.user.uid else { return }
                                DatabilityUserLoginFirebase.getUser(currentUserID: currentUID)
                                showPermissions = true
                                
                            }
                            else {
                                Auth.auth().createUser(withEmail: dataTextEmail, password: dataTextPassword) { didSignInResult, signInResultError in
                                    if signInResultError == nil && didSignInResult != nil {
                                        continueOnboarding = true
                                    }
                                }
                            }
                            
                        }
                    } label: {
                        Text("Sign in")
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
                    .frame(width: 700, height: 800, alignment: .center)
                    .aspectRatio(contentMode: .fit))
                
                .JMModal(showModal: $showPermissions, for: [.location, .camera], autoCheckAuthorization: false, restrictDismissal: true, onAppear: {
                    
                }, onDisappear: {

                    dataVC.removeDataHostingView()
                    dataVC.loadDataChallengesHostingView()
                })
                .fullScreenCover(isPresented: $continueOnboarding, content: {
                    DatabilityPersonalInfo(dataTextEmail: $dataTextEmail, dataVC: dataVC, shouldPresentPersonalInfo: $continueOnboarding, passwordEntered: $dataTextPassword)
                })
                .onTapGesture {
                    UIApplication.shared.resignFirstResponder()
                }
                
            }
        }
    }
}

struct DatabilityLogin_Previews: PreviewProvider {
    static var previews: some View {
        DatabilityLogin(dataVC: ViewController())
    }
}

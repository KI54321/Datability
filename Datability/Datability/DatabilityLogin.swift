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
                    Spacer()
                    
                    
                    TextField("example@gmail.com", text: $dataTextEmail)
                        .padding(.all, 10)
                        .background(RoundedRectangle(cornerRadius: 20).stroke(LinearGradient(gradient: Gradient(colors: [Color(red: 0.2, green: 0.58, blue: 0.9), Color(red: 0.93, green: 0.43, blue: 0.68)]), startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: 2))
                        .textFieldStyle(.plain)
                        .frame(maxWidth: .infinity)
                        .padding()
                    
                    TextField("Password123", text: $dataTextPassword)
                        .padding(.all, 10)
                        .background(RoundedRectangle(cornerRadius: 20).stroke(LinearGradient(gradient: Gradient(colors: [Color(red: 0.2, green: 0.58, blue: 0.9), Color(red: 0.93, green: 0.43, blue: 0.68)]), startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: 2))
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
                    .frame(width: dataProxy.size.width, height: dataProxy.size.height, alignment: .center)
                    .aspectRatio(contentMode: .fit))
                
                .JMModal(showModal: $showPermissions, for: [.location, .camera], autoCheckAuthorization: false, restrictDismissal: true, onAppear: {
                    
                }, onDisappear: {

                    dataVC.removeDataHostingView()
                })
                .navigationTitle("Datability")
                .fullScreenCover(isPresented: $continueOnboarding, content: {
                    DatabilityPersonalInfo(dataTextEmail: $dataTextEmail, dataVC: dataVC, shouldPresentPersonalInfo: $continueOnboarding)
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

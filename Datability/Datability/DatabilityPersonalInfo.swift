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
                    
                    TextField("+1-408-123-4567", text: $dataTextPhoneNumber)
                        .padding(.all, 10)
                        .background(RoundedRectangle(cornerRadius: 20).stroke(LinearGradient(gradient: Gradient(colors: [Color(red: 0.2, green: 0.58, blue: 0.9), Color(red: 0.93, green: 0.43, blue: 0.68)]), startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: 2))
                        .textFieldStyle(.plain)
                        .frame(maxWidth: .infinity)
                        .padding()
                    
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
                .JMModal(showModal: $continueOnboarding, for: [.location, .camera], autoCheckAuthorization: false, restrictDismissal: true)
                .onChange(of: continueOnboarding, perform: { newValue in
                    if !newValue {
                        shouldPresentPersonalInfo = false
                        dataVC.removeDataHostingView()
                    }
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

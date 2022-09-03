//
//  DatabilityProfile.swift
//  Datability
//
//  Created by Pranit Agrawal on 9/2/22.
//

import SwiftUI
import FirebaseAuth

struct DatabilityProfile: View {
    let databaseProfile = DatabilityFetchFirestoreProfile.fetchProfileData()
    let dataVC: ViewController
    
    @State var refreshID: String = UUID().uuidString
    var body: some View {
        
        NavigationView {
            VStack {
                
                Image(systemName: "person.fill")
                    .resizable()
                    .clipShape(Circle())
                    .frame(width:180, height:180)
                    .scaledToFill()
                    .padding(.top, 40)
                    .foregroundColor(Color(red: 0.514, green: 0.698, blue: 0.635))
                    
                Text("@\(databaseProfile?.fullNameLocal ?? "Full Name")")
                        .font(.title).bold()
                        .foregroundColor(Color(red: 0.514, green: 0.698, blue: 0.635))
                        .padding(.top, 30)
                
                List {
                    
                    Section {
                        VStack {
                            Text("\(databaseProfile?.totalSnapsTakenLocal ?? 0) Snaps Taken")
                                .foregroundColor(Color(red: 0.514, green: 0.698, blue: 0.635))
                            Spacer()
                            Text("\(databaseProfile?.challengesCompletedLocal ?? 0) Challenges Completed")
                                .foregroundColor(Color(red: 0.514, green: 0.698, blue: 0.635))
                        }
                        .frame(maxWidth: .infinity, alignment: .center)
                    }
                    .frame(height: 50)
                    

                    Section {
                        VStack {
                            Text("$\(databaseProfile?.totalMoneyEarnedLocal ?? 0) Earned")
                                .foregroundColor(Color(red: 0.514, green: 0.698, blue: 0.635))
                                
                            
                            Spacer()
                            Text("$\(databaseProfile?.moneyTilNextPaymentLocal ?? 0) Till Payout")
                                .foregroundColor(Color(red: 0.514, green: 0.698, blue: 0.635))
                        }
                        .frame(maxWidth: .infinity, alignment: .center)
                        
                    }
                    .frame(height: 50)

                }
                .padding(.top, 20)
                .listStyle(.insetGrouped)
               // .listRowBackground(Color(red: 0.514, green: 0.698, blue: 0.635))
                
                
                
                Spacer()
                
                
            }
            .frame(maxWidth: .infinity)
            .edgesIgnoringSafeArea(.bottom)
            .background(.white) // #83b2a2
            .navigationTitle(Text("My Profile"))
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
               
                        
                        do {
                            try Auth.auth().signOut()
                            
                            UserDefaults.standard.removeObject(forKey: "fullNameLocal")
                            UserDefaults.standard.removeObject(forKey: "emailLocal")
                            UserDefaults.standard.removeObject(forKey: "challengesCompletedLocal")
                            UserDefaults.standard.removeObject(forKey: "moneyTilNextPaymentLocal")
                            UserDefaults.standard.removeObject(forKey: "phoneNumberLocal")
                            UserDefaults.standard.removeObject(forKey: "totalMoneyEarnedLocal")
                            UserDefaults.standard.removeObject(forKey: "totalSnapsTakenLocal")
                            
                            dataVC.removeDataChallengesView()
                            dataVC.loadDataChallengesHostingView()
                        }
                        catch {
                            print("Signed Out")
                        }
                    } label: {
                        HStack {
                            Text("Sign Out")
                        Image(systemName: "rectangle.portrait.and.arrow.right.fill")
                            .font(.headline)
                        }
                    }

                }
            }
            .id(refreshID)
        }
        
    }
}

struct DatabilityProfile_Previews: PreviewProvider {
    static var previews: some View {
        DatabilityProfile(dataVC: ViewController())
    }
}

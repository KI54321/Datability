//
//  DatabilityChallenges.swift
//  Datability
//
//  Created by Krish Iyengar on 9/3/22.
//

import SwiftUI
import FirebaseAuth
import Photos

struct DatabilityChallenges: View {
    var dataVC: ViewController
    
    @State var databilityChallenges: [[String:Any]] = []
    
    @State var refreshID: String = UUID().uuidString
    

    var body: some View {
        
        NavigationView {
            
            List(0..<databilityChallenges.count, id: \.self) { oneDataSelected in
                let oneDatabilityChallenge = databilityChallenges[oneDataSelected]
                
                Section {
                    NavigationLink {
                        DatabilityChallengeExplanation(databilityChallenges: oneDatabilityChallenge)
                        
                    } label: {
                    HStack {
                    VStack {
                        HStack {
                            Text(oneDatabilityChallenge["title"] as? String ?? "")
                                .font(.title2)
                                .fontWeight(.heavy)
                                .multilineTextAlignment(.leading)
                            
                            
                            Spacer()
                   
                        }
                        
                        
                        Spacer()
                        HStack {
                            
                            
                            
                            Text(oneDatabilityChallenge["city"] as? String ?? "")
                                .font(.headline)
//                                .fontWeight(.bold)
                                .multilineTextAlignment(.leading)
                            
                            Spacer()
                        }
                        HStack {
                            
                            Text("$\(oneDatabilityChallenge["payout"] as? String ?? "") Total Payout")
                                .font(.subheadline)
//                                .fontWeight(.bold)
                                .multilineTextAlignment(.trailing)
                                
                            
                            Spacer()
                        }
                    }
                    .padding(.top, 10)
                    .padding(.bottom, 10)
                        VStack {
                            Text("8 Pics")
                                .font(.headline)
                       
//                        } label: {
//
//                            Image(systemName: "chevron.right.circle.fill")
//                                .padding(.all, 10)
//                                .foregroundColor(.white)
//
//
//                        }
//                        .background(Color.black)
//                        .cornerRadius(20)
//                        .frame(width: 25, height: 25, alignment: .center)
//
                        }
                        
                    }
                }
             
                }
                .frame(height: 100)
                
            }
            
            .navigationTitle("My Challenges")
            .id(refreshID)
            .onAppear {
                DatabilityFetchFirestoreProfile.fetchDatabilityChallenges(completion: { databilityChallengesItems in
                    if !databilityChallengesItems.isEmpty {
                        
                        databilityChallenges = databilityChallengesItems
                        refreshID = UUID().uuidString
                    }
                })
            }
            
            
       
            
        }
        
    }
}




struct DatabilityChallenges_Previews: PreviewProvider {
    static var previews: some View {
        Text("H")
        //        DatabilityChallenges()
    }
}

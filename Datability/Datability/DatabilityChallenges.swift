//
//  DatabilityChallenges.swift
//  Datability
//
//  Created by Krish Iyengar on 9/3/22.
//

import SwiftUI
import FirebaseAuth
import Photos
import FirebaseFirestoreSwift
import FirebaseFirestore

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
                                .foregroundColor(Color(red: 0.514, green: 0.698, blue: 0.635))
                                
                            
                            
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
                            
                            
//                            returnViewCountRecords(oneDatabilityChallenge: oneDatabilityChallenge) { oneDataText in
//
//                            }
//                            if oneDatabilityChallenge["entries"] == nil {
                                Text("Open")
                                    .font(.headline)
//                            }
//                            else {
//                                Text("\((oneDatabilityChallenge["entries"] as? [[String:Any]])?.count ?? 0) Pics")
//                                .font(.headline)
//                            }
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
                DatabilityUserLoginFirebase.getMapCoordinates()

            }
            
            
       
            
        }
        
    }
    
    
//    func returnViewCountRecords(oneDatabilityChallenge: [String:Any], completion: @escaping (Text) -> ()) -> AnyView {
//
//        let viewCountRecordsDispatchGroup = DispatchGroup()
//        viewCountRecordsDispatchGroup.enter()
//
//        var numberOfCounts = 0
//        Firestore.firestore().collection("challenges").document(oneDatabilityChallenge["id"] as? String ?? "ERROR").collection("entries").getDocuments { oneDocSnap, oneDocError in
//            if oneDocError == nil && oneDocSnap != nil {
//
//                numberOfCounts = oneDocSnap?.documents.count ?? 0
//            }
//            viewCountRecordsDispatchGroup.leave()
//
//
//        }
//
//        viewCountRecordsDispatchGroup.notify(queue: DispatchQueue(label: "ViewNumberOfSnaps")) {
//            completion(Text("\(numberOfCounts) Pics")
//                .font(.headline))
//            return
//        }
//        return Text("")
//            .hidden()
//    }
}




struct DatabilityChallenges_Previews: PreviewProvider {
    static var previews: some View {
        Text("H")
        //        DatabilityChallenges()
    }
}

//
//  DatabilityProfile.swift
//  Datability
//
//  Created by Pranit Agrawal on 9/2/22.
//

import SwiftUI

struct DatabilityProfile: View {
    
    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        UITableViewCell.appearance().backgroundColor = UIColor.systemPink
    }
    
    var body: some View {
        
        NavigationView {
            VStack {
                
                Image(systemName: "person.fill")
                    .resizable()
                    .clipShape(Circle())
                    .frame(width:180, height:180)
                    .scaledToFill()
                    .padding(.top, 40)
                    .foregroundColor(Color(red: 1, green: 0.89, blue: 0.804))
                    
                    Text("@Krishy")
                        .font(.title).bold()
                        .foregroundColor(Color(red: 1, green: 0.89, blue: 0.804))
                        .padding(.top, 30)
                
                List {
                    Section {
                        Text("@KI54321")
                            .foregroundColor(Color(red: 1, green: 0.89, blue: 0.804))
                            .font(.system(size: 35, weight: .semibold))
                            .frame(maxWidth: .infinity, alignment: .center)
                        
                    }
                    .listRowBackground(Color(red: 0.514, green: 0.698, blue: 0.635))
                    .frame(height: 50)
                    
                    Section {
                        VStack {
                            Text("20 Snaps Taken")
                                .foregroundColor(Color(red: 1, green: 0.89, blue: 0.804))
                            Spacer()
                            Text("10 Challenges Completed")
                                .foregroundColor(Color(red: 1, green: 0.89, blue: 0.804))
                        }
                        .frame(maxWidth: .infinity, alignment: .center)
                    }
                    .listRowBackground(Color(red: 0.514, green: 0.698, blue: 0.635))
                    .frame(height: 50)
                    

                    Section {
                        VStack {
                            Text("$0.00 Earned")
                                .foregroundColor(Color(red: 1, green: 0.89, blue: 0.804))
                                
                            
                            Spacer()
                            Text("$10.00 Till Payout")
                                .foregroundColor(Color(red: 1, green: 0.89, blue: 0.804))
                        }
                        .frame(maxWidth: .infinity, alignment: .center)
                        
                    }
                    .listRowBackground(Color(red: 0.514, green: 0.698, blue: 0.635))
                    .frame(height: 50)

                }
                .padding(.top, 20)
                .listStyle(.insetGrouped)
                .listRowBackground(Color(red: 0.514, green: 0.698, blue: 0.635))
                
                
                
                Spacer()
                
                
            }
        
            .frame(maxWidth: .infinity)
            .edgesIgnoringSafeArea(.bottom)
            .background(Color(red: 0.514, green: 0.698, blue: 0.635)) // #83b2a2
            .navigationTitle(Text("My Profile"))
        
        }
        
    }
}

struct DatabilityProfile_Previews: PreviewProvider {
    static var previews: some View {
        DatabilityProfile()
    }
}

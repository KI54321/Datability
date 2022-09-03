//
//  HomeBottomBar.swift
//  Datability
//
//  Created by Krish Iyengar on 9/3/22.
//

import SwiftUI
import BottomBar_SwiftUI

struct HomeBottomBar: View {
    
    @State var currentTabs = [BottomBarItem(icon: Image(systemName: "house.fill"), title: "Home", color: .purple), BottomBarItem(icon: Image(systemName: "person.fill"), title: "Profile", color: .blue)]
    @State var currentTab: Int = 0
    var dataVC: ViewController
    @State var currentViewShown: AnyView
    
    init(dataVC: ViewController) {
        self.dataVC = dataVC
        currentViewShown = AnyView(DatabilityChallenges(dataVC: dataVC))
        
    }
    var body: some View {
        GeometryReader { geoProxy in
            
        
        VStack {
            
            currentViewShown
            BottomBar(selectedIndex: $currentTab, items: currentTabs)
                .frame(width: geoProxy.size.width/1.5, height: 50, alignment: .center)
                
        }
        .onChange(of: currentTab) { newValue in
                if newValue == 0 {
                    currentViewShown = AnyView(DatabilityChallenges(dataVC: dataVC))

                }
                else {
                    currentViewShown = AnyView(DatabilityProfile(dataVC: dataVC))

                }
            }
        
        }
    }
}

struct HomeBottomBar_Previews: PreviewProvider {
    static var previews: some View {
        Text("Bottom Bar")
//        HomeBottomBar()
    }
}

//
//  DatabilityMaps.swift
//  Datability
//
//  Created by Krish Iyengar on 9/3/22.
//

import SwiftUI
import FirebaseAuth
import Photos
import MapKit

struct DatabilityMaps: View {
    
    var dataVC: ViewController
    
    @State var databilityChallenges: [[String:Any]] = []
    
    @State var refreshID: String = UUID().uuidString
    
    var body: some View {
        NavigationView {
            VStack {
                Map(coordinateRegion: \, annotationItems: <#T##RandomAccessCollection#>, annotationContent: <#T##(Identifiable) -> MapAnnotationProtocol#>)
            }
        }
    }
}

struct DatabilityMaps_Previews: PreviewProvider {
    static var previews: some View {
        Text("H")
        //DatabilityMaps()
    }
}

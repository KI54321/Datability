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

struct DataMapCoordinates: Identifiable {
    
    
    var id = UUID()
    
    var dataCoordinates: CLLocationCoordinate2D
}
struct DatabilityMaps: View {
    
    var dataVC: ViewController
    
    @State var databilityChallenges: [[String:Any]] = []
    @State var mapRegion: MKCoordinateRegion
    
    init(dataVC: ViewController) {
        self.dataVC = dataVC
        mapRegion = MKCoordinateRegion(center: DatabilityUserLoginFirebase.allMapCoordinates.first?.dataCoordinates ??  CLLocationCoordinate2D(latitude: 0, longitude: 0), span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02))
    }
    var body: some View {
        NavigationView {
            VStack {
                Map(coordinateRegion: $mapRegion, annotationItems: DatabilityUserLoginFirebase.allMapCoordinates) { oneCoordinate in
                    MapMarker(coordinate: oneCoordinate.dataCoordinates)
                }
                .ignoresSafeArea()
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

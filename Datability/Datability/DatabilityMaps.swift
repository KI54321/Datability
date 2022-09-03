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
    @State var coordinatesShow: [DataMapCoordinates] = []
    @State var refreshID: String = UUID().uuidString
    @State var mapRect: MKCoordinateRegion = MKCoordinateRegion()
    
    var body: some View {
        NavigationView {
            VStack {
                Map(coordinateRegion: $mapRect, annotationItems: coordinatesShow) { oneCoordinate in
                    MapMarker(coordinate: oneCoordinate.dataCoordinates)
                }
            }
            .id(refreshID)
            .onAppear {
                DatabilityUserLoginFirebase.getMapCoordinates { allCLLLandmarkLocations in
                    coordinatesShow = allCLLLandmarkLocations.map({ oneCLLLocation in
                        return DataMapCoordinates(dataCoordinates: oneCLLLocation.coordinate)
                    })
                    refreshID = UUID().uuidString
                    
                }
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

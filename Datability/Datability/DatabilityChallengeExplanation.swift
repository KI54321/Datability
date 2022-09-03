//
//  DatabilityChallengeExplanation.swift
//  Datability
//
//  Created by Krish Iyengar on 9/3/22.
//

import SwiftUI

struct DatabilityChallengeExplanation: View {
    
    @State var dataSelectedImage: UIImage = UIImage()
    @State var dataTakePhotVC: Bool = false
    @State var databilityChallenges: [String:Any]
    @State var databilitySummaryText = ""

       
    var body: some View {
        GeometryReader { geoProxy in
            
        
        VStack {
            Text(databilitySummaryText)
                .font(.body)
                .fontWeight(.medium)
                .padding()
            Button {
                dataTakePhotVC = true
            } label: {
                Text("Capture the Photo")
                    .padding()
                    .foregroundColor(Color.white)
            }
            .frame(width: geoProxy.size.width-60)
            .background(Color.blue)
            .cornerRadius(20)
            
            Spacer()


        }
        .navigationTitle("\(databilityChallenges["type"] as? String ?? "Type")")
        
        .fullScreenCover(isPresented: $dataTakePhotVC) {
            ImagePickerDataViewControllerRepresentable(dataSelectedImage: $dataSelectedImage)
                .edgesIgnoringSafeArea(.vertical)
        }
        .onChange(of: dataSelectedImage) { newValue in
            guard let oneCoord = PlantScanner.dataLocationManager.location else { return }

            PlantScanner.plantScanner(image: newValue, expectedPlant: (databilityChallenges["type"] as? String ?? "Type")) { plantScannerWorked in
                if plantScannerWorked {
                PlantScanner.uploadPhoto(image: newValue, lat: oneCoord.coordinate.latitude, long: oneCoord.coordinate.longitude, currentDictChallenge: databilityChallenges)
                }
            }
        }
        .onAppear {
            PlantScanner.dataLocationManager.startUpdatingLocation()
            
            PlantScanner.createNLPSummaries(plant: databilityChallenges["type"] as? String ?? "Type") { newSummaryText in
                databilitySummaryText = newSummaryText
            }
        }
        .onDisappear {
            PlantScanner.dataLocationManager.stopUpdatingLocation()
            
        }
        }
    }
}
struct ImagePickerDataViewControllerRepresentable: UIViewControllerRepresentable {
    
    typealias UIViewControllerType = UIImagePickerController
    @Environment(\.presentationMode) var dataPresentationMode
    @Binding var dataSelectedImage: UIImage
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let dataImagePickerController = UIImagePickerController()
        dataImagePickerController.sourceType = .camera
        dataImagePickerController.delegate = context.coordinator
        return dataImagePickerController
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
        
    }
    
    func makeCoordinator() -> PhotoDataCoordinator {
        return PhotoDataCoordinator(imagePickerDataVC: self)
    }
    
    
}
class PhotoDataCoordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    var imagePickerDataVC: ImagePickerDataViewControllerRepresentable
    
     init(imagePickerDataVC: ImagePickerDataViewControllerRepresentable) {
         self.imagePickerDataVC = imagePickerDataVC
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.imagePickerDataVC.dataPresentationMode.wrappedValue.dismiss()
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let infoDataImage = info[.originalImage] as? UIImage else { return }
        self.imagePickerDataVC.dataSelectedImage = infoDataImage
        self.imagePickerDataVC.dataPresentationMode.wrappedValue.dismiss()
    }
}
struct DatabilityChallengeExplanation_Previews: PreviewProvider {
    static var previews: some View {
        Text("Datability")
//        DatabilityChallengeExplanation(databilityChallenges: [:])
    }
}

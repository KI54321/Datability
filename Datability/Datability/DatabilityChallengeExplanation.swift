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
    @State var databilityWikiURL: String
    @State var databilityName: String
    @State var databilityImageURL: String

       
    var body: some View {
        VStack {
            Text("\(databilityChallenges["description"] as? String ?? "description")")
                .font(.body)
                .fontWeight(.medium)
            Button {
                dataTakePhotVC = true
            } label: {
                Text("Tale the photo")
            }

        }
        .navigationTitle("\(databilityChallenges["type"] as? String ?? "Type")")
        
        .fullScreenCover(isPresented: $dataTakePhotVC) {
            ImagePickerDataViewControllerRepresentable(dataSelectedImage: $dataSelectedImage)
        }
        .onChange(of: dataSelectedImage) { newValue in
            PlantScanner.plantScanner(image: newValue) { plantScannerFirstResultName, plantScannerFirstResultWikiURL, plantScannerFirstResultImageURL in
                databilityName = plantScannerFirstResultName
                databilityImageURL = plantScannerFirstResultImageURL
                databilityWikiURL = plantScannerFirstResultWikiURL

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
        DatabilityChallengeExplanation(databilityChallenges: [:])
    }
}

//
//  DatabilityChallengeExplanation.swift
//  Datability
//
//  Created by Krish Iyengar on 9/3/22.
//

import SwiftUI
import SPAlert
import ActivityIndicatorView
import FirebaseFirestore
import FirebaseAuth

struct DatabilityChallengeExplanation: View {
    
    @State var dataSelectedImage: UIImage = UIImage()
    @State var dataTakePhotVC: Bool = false
    @State var databilityChallenges: [String:Any]
    @State var databilitySummaryText = ""
    @State var showSPAlert = false
    @State var showSPAlertBad = false
@State var isProcessingResults = false
    @State var challengePhotoImage: UIImage = UIImage()
    
    var body: some View {
        GeometryReader { geoProxy in
            
            ScrollView {
                VStack {
                    if !isProcessingResults {
                        VStack {
                            Text("Brought to you by \(databilityChallenges["host"] as? String ?? "Company")")
                                .padding(.top, 10)
                    Image(uiImage: challengePhotoImage)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .cornerRadius(20)
                        .frame(width: geoProxy.size.width-40, height: 280, alignment: .center)
                        .shadow(radius: 10)
                    
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
                    }
                    else {
                        
                        ActivityIndicatorView(isVisible: $isProcessingResults, type: .equalizer(count: 15))
                            .padding(.bottom, 50)
                    }
                    
                    
                }
                .navigationTitle("\(databilityChallenges["type"] as? String ?? "Type")")
                
                .fullScreenCover(isPresented: $dataTakePhotVC) {
                    ImagePickerDataViewControllerRepresentable(dataSelectedImage: $dataSelectedImage)
                        .edgesIgnoringSafeArea(.vertical)
                }
                .onChange(of: dataSelectedImage) { newValue in
                    self.isProcessingResults = true
                    guard let oneCoord = PlantScanner.dataLocationManager.location else { return }
                    
                    PlantScanner.plantScanner(image: newValue, expectedPlant: (databilityChallenges["type"] as? String ?? "Type")) { plantScannerWorked in
                        
                        self.isProcessingResults = false
                        
                        if plantScannerWorked {
                            PlantScanner.uploadPhoto(image: newValue, lat: oneCoord.coordinate.latitude, long: oneCoord.coordinate.longitude, currentDictChallenge: databilityChallenges)
                            // Increments total snaps taken local
                            let moneyIncrementedRandom = Double.random(in: 0.1...1.0)
                            UserDefaults.standard.set(UserDefaults.standard.integer(forKey:"totalSnapsTakenLocal") + 1, forKey: "totalSnapsTakenLocal")
                            UserDefaults.standard.set(UserDefaults.standard.double(forKey:"totalMoneyEarnedLocal") + moneyIncrementedRandom, forKey: "totalMoneyEarnedLocal")

                            Firestore.firestore().collection("users").document(Auth.auth().currentUser?.uid ?? "ERROR").updateData(["totalSnapsTakenLocal":FieldValue.increment(1.0)])
                            Firestore.firestore().collection("users").document(Auth.auth().currentUser?.uid ?? "ERROR").updateData(["totalMoneyEarnedLocal":FieldValue.increment(moneyIncrementedRandom)])
                            showSPAlert = true
                        }
                        else {
                            showSPAlertBad = true
                            
                        }
                        
                    }
                }
                .SPAlert(isPresent: $showSPAlert, message: "Congrats! This entry works.", preset: .done)
                .SPAlert(isPresent: $showSPAlertBad, message: "Wrong One! Try a different plant.", preset: .error)
                .onAppear {
                    PlantScanner.dataLocationManager.startUpdatingLocation()
                    
                    PlantScanner.createNLPSummaries(plant: databilityChallenges["type"] as? String ?? "Type") { newSummaryText in
                        databilitySummaryText = newSummaryText
                    }
                    PlantScanner.getPhotoChallengesURL(currentDictChallenge: databilityChallenges) { oneDataImageChallenge in
                        challengePhotoImage = oneDataImageChallenge
                    }
                }
                .onDisappear {
                    PlantScanner.dataLocationManager.stopUpdatingLocation()
                    
                }
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

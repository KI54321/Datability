//
// DatabilityProfile.swift
// Datability
//
// Created by Pranit Agrawal on 9/2/22.
//

import SwiftUI
import FirebaseAuth
import MessageUI
import FirebaseFirestore

struct DatabilityProfile: View {
    @State var databaseProfile = DatabilityFetchFirestoreProfile.fetchProfileData()
    let dataVC: ViewController
    @State var refreshID: String = UUID().uuidString
    @State var shouldPresentWithdrawal = false
    var body: some View {
        NavigationView {
            VStack {
                List {
                Image(systemName: "person.fill")
                    .resizable()
                    .clipShape(Circle())
                    .frame(width:120, height:120)
                    .scaledToFill()
                    .padding(.top, 40)
                    .foregroundColor(Color(red: 0.514, green: 0.698, blue: 0.635))
                    .frame(maxWidth: .infinity)
                    .padding(.bottom, 30)
                    
                    LazyVGrid(
                        columns: Array(repeating: .init(.flexible(), spacing: 16), count: 2), spacing: 16) {
                            VStack {
                                Text("\(databaseProfile?.challengesCompletedLocal ?? 0)")
                                    .font(.system(size:80))
                                    .foregroundStyle(.conicGradient(colors: [.blue, .purple,.pink], center: .trailing, angle: .degrees(0)))
                                Text("Challenges Participated In")
                                    .multilineTextAlignment(.center)
                            }
                            VStack(spacing: 16) {
                                Spacer()
                                Text("\(databaseProfile?.totalSnapsTakenLocal ?? 0)")
                                    .font(.system(size:80))
                                    .foregroundStyle(.conicGradient(colors: [.pink, .orange, .yellow], center: .trailing, angle: .degrees(0)))
                                Text("Snaps Taken\n")
                            } .offset(y: -8)
                            VStack {
                                Text("\(databaseProfile?.totalSnapsTakenLocal ?? 0)")
                                    .font(.system(size:80))
                                    .foregroundStyle(.conicGradient(colors: [Color(red: 0.8, green: 0.267, blue: 0.294), Color(red: 0.875, green: 0.451, blue: 0.451), .white], center: .trailing, angle: .degrees(0)))
                                Text("Total Points Earned")
                                Spacer()
                            }.offset(y: -27)
                            VStack(spacing: 20) {
                                Spacer()
                                Text("$\(databaseProfile?.totalMoneyEarnedLocal ?? 0, specifier: "%.2f")")
                                    .font(.system(size:50))
                                    .foregroundStyle(.conicGradient(colors: [Color(red: 0.498, green: 0.745, blue: 0.922), Color(red: 0.337, green: 0.796, blue: 0.976), .blue], center: .trailing, angle: .degrees(300)))
                                Text("Total Money Earned")
                            } .offset(y: -36)
                        }
                    Button {
                        shouldPresentWithdrawal = true
                    } label: {
                        Text("Request Withdrawal")
                            .buttonStyle(.plain)
                            .frame(width: 250, height: 60)
                            .background(Color(red: 0.514, green: 0.698, blue: 0.635))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .scaledToFill()
                            .padding(.bottom, 22)
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                }
                
            }.frame(maxWidth: .infinity)
                .edgesIgnoringSafeArea(.bottom)
                .background(.white) // #83B2A2
                .navigationTitle("@\(databaseProfile?.fullNameLocal ?? "Full Name")")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            do {
                                
                                try Auth.auth().signOut()
                                
                                UserDefaults.standard.removeObject(forKey: "fullNameLocal")
                                UserDefaults.standard.removeObject(forKey: "emailLocal")
                                UserDefaults.standard.removeObject(forKey: "challengesCompletedLocal")
                                UserDefaults.standard.removeObject(forKey: "moneyTilNextPaymentLocal")
                                UserDefaults.standard.removeObject(forKey: "phoneNumberLocal")
                                UserDefaults.standard.removeObject(forKey: "totalMoneyEarnedLocal")
                                UserDefaults.standard.removeObject(forKey: "totalSnapsTakenLocal")
                                dataVC.removeDataChallengesView()
                                dataVC.loadDataChallengesHostingView()
                            }
                            catch {
                                print("Signed Out")
                            }
                        } label: {
                            HStack {
                                Text("Sign Out")
                                Image(systemName: "rectangle.portrait.and.arrow.right.fill")
                                    .font(.headline)
                            }
                        }
                    }
                }
                .id(refreshID)
                .sheet(isPresented: $shouldPresentWithdrawal) {
                    DatabilityWithdrawMailComposer(moneyNeeded: databaseProfile?.totalMoneyEarnedLocal ?? 0.0, topView: self)
                }
        }
    }
}
struct DatabilityWithdrawMailComposer: UIViewControllerRepresentable {
    typealias UIViewControllerType = MFMailComposeViewController
    var moneyNeeded: Double
    var topView: DatabilityProfile
    @Environment(\.presentationMode) var presentationMode
    func makeUIViewController(context: Context) -> MFMailComposeViewController {
        let balanceMailComposeController = MFMailComposeViewController()
        balanceMailComposeController.setSubject("Payment of $\(moneyNeeded)")
        balanceMailComposeController.setMessageBody("Please send this email to the databilityteam@gmail.com for the amount to be paid.", isHTML: false)
        balanceMailComposeController.setToRecipients(["databilityteam@gmail.com"])
        balanceMailComposeController.mailComposeDelegate = context.coordinator
        return balanceMailComposeController

    }
    func updateUIViewController(_ uiViewController: MFMailComposeViewController, context: Context) {
        
    }
    func makeCoordinator() -> MailComposerCoordinator {
        return MailComposerCoordinator(mailComposer: self)
    }
    
}
class MailComposerCoordinator: NSObject, MFMailComposeViewControllerDelegate {
     var mailComposer: DatabilityWithdrawMailComposer

    init(mailComposer: DatabilityWithdrawMailComposer) {
        self.mailComposer = mailComposer
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        if result == .sent {
            UserDefaults.standard.set(0.0, forKey: "totalMoneyEarnedLocal")

            Firestore.firestore().collection("users").document(Auth.auth().currentUser?.uid ?? "ERROR").updateData(["totalMoneyEarnedLocal":0])
            mailComposer.topView.databaseProfile?.totalMoneyEarnedLocal = 0.00
           
        }
        controller.dismiss(animated: true)
    }
    
}
struct DatabilityProfile_Previews: PreviewProvider {
    static var previews: some View {
        DatabilityProfile(dataVC: ViewController())
    }
}

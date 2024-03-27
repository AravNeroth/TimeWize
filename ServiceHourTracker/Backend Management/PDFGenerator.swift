//
//  PDFGenerator.swift
//  ServiceHourTracker
//
//  Created by neroth_927927 on 3/24/24.
//

import Foundation
import SwiftUI
import PDFKit
import Firebase
import FirebaseAuth
import MessageUI

class PDFGenerator {
    static func generatePDF(completion: @escaping (Data?) -> Void) {
        let userEmail = "dontoliver@gmail.com" // easier testing 
        let db = Firestore.firestore()
        let userInfoRef = db.collection("userInfo").document(userEmail)
        
        userInfoRef.getDocument { document, error in
            if let document = document, document.exists {
                let data = document.data()
                let name = data?["displayName"] as? String ?? ""
                let hours = data?["hours"] as? Int ?? 0
                let pdfContent = "Name: \(name) | Hours: \(hours)"
                
                if let pdfData = generatePDFData(content: pdfContent) {
                    completion(pdfData)
                } else {
                    print("Failed to generate PDF data")
                    completion(nil)
                }
            } else {
                print("Document does not exist")
                completion(nil)
            }
        }
    }

    
    private static func generatePDFData(content: String) -> Data? {
        print("Starting to geneate PDF data")

        let pdfData = NSMutableData()
        let pageRect = CGRect(x: 0, y: 0, width: 612, height: 792)
        let format = UIGraphicsPDFRendererFormat()
        let renderer = UIGraphicsPDFRenderer(bounds: pageRect, format: format)
        
        let pdf = renderer.pdfData { context in
            context.beginPage()
            let attributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 24)
            ]
            let attributedString = NSAttributedString(string: content, attributes: attributes)
            attributedString.draw(in: pageRect)
        }
        
        pdfData.append(pdf)
        print("Data Generated")

        return pdfData as Data
    }
    
    
}

struct ContentView: View {
    @State private var pdfDocument: PDFDocument?
    let mailDelegate = MailDelegate()
    
    var body: some View {
        VStack {
            Text("Preview of Report")
                .font(.largeTitle)
                .bold()
            
            Button("Generate PDF") {
                generatePDFButtonTapped()
            }
            .padding()
            
            Button("Email Report") {
//                
//                if let pdfData = pdfDocument?.dataRepresentation() {
//                    emailReport(pdfData: pdfData)
//                } else {
//                    print("No PDF data available")
//                }
                // tnis for testing bc my email isnt set up on simulator
                if let pdfDocument = pdfDocument {
                        // Displaying content instead of sending email
                        displayPDFDocument(pdfDocument: pdfDocument)
                    } else {
                        print("No PDF available")
                    }
            }
            .padding()
            
            if let pdfDocument = pdfDocument {
                PDFKitView(document: pdfDocument)
                    .frame(width: 390, height: 350)
            } else {
                Text("No PDF available")
                    .foregroundColor(.red)
            }
            
            

        }
    }
    
    // Function to generate PDF when the button is tapped
    func generatePDFButtonTapped() {
        PDFGenerator.generatePDF { data in
            print("inside pdfbuttontapped")
            
            if let data = data {
                let document = PDFDocument(data: data)
                DispatchQueue.main.async {
                    self.pdfDocument = document
                }
            } else {
                print("Failed to generate PDF")
            }
        }
    }
    
    
    func emailReport(pdfData: Data) {
        guard let currentUser = Auth.auth().currentUser else {
            print("User is not authenticated")
            return
        }
        
        //let userEmail = currentUser.email ?? "example@gmail.com"
        
        let userEmail = "2findmyemail@gmail.com"
        
        guard MFMailComposeViewController.canSendMail() else {
            print("Mail services are not available")
            return
        }
        
        let mailComposer = MFMailComposeViewController()
        mailComposer.mailComposeDelegate = mailDelegate
        mailComposer.setToRecipients([userEmail])
        mailComposer.setSubject("TimeWize Report")
        mailComposer.addAttachmentData(pdfData, mimeType: "application/pdf", fileName: "ServiceHourReport.pdf")
        
        if let rootViewController = UIApplication.shared.windows.first?.rootViewController {
            rootViewController.present(mailComposer, animated: true, completion: nil)
        }
        
        
        
        
    }
    
    // Function to display PDF document
    func displayPDFDocument(pdfDocument: PDFDocument) {
        // Create a PDFView to display the document
        let pdfView = PDFView()
        pdfView.document = pdfDocument
        
        // Create a UIViewController to host the PDFView
        let pdfViewController = UIViewController()
        pdfViewController.view = pdfView
        
        // Present the PDFViewController
        if let rootViewController = UIApplication.shared.windows.first?.rootViewController {
            rootViewController.present(pdfViewController, animated: true, completion: nil)
        }
    }
    
    }

class MailDelegate: NSObject, MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}



struct PDFKitView: UIViewRepresentable {
    let document: PDFDocument

    func makeUIView(context: Context) -> PDFView {
        let pdfView = PDFView()
        pdfView.document = document
        return pdfView
    }

    func updateUIView(_ uiView: PDFView, context: Context) {}
}

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
                let pdfContent = "Name: \(name), Hours:\(hours)"
                
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

    var body: some View {
        VStack {
            Button("Generate PDF") {
                generatePDFButtonTapped()
            }
            .padding()
            
            if let pdfDocument = pdfDocument {
                PDFKitView(document: pdfDocument)
                    .frame(width: 300, height: 400)
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

//
//  ImagePicker.swift
//  ServiceHourTracker
//
//  Created by kalsky_953982 on 2/4/24.
// reference: https://youtu.be/FFWP7eXn0ck?si=RR9tnucXXxDhFcDQ

import Foundation
import SwiftUI
struct ImagePicker: UIViewControllerRepresentable{
    @Binding var image: UIImage?
    
    
    private let controller = UIImagePickerController()
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }
    
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
        
        let parent: ImagePicker
        init(parent: ImagePicker) {
            self.parent = parent
        }
        //when picked an image
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            parent.image = info[.originalImage] as? UIImage
            picker.dismiss(animated: true)
            
        }
        // when cancelled the process
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true)
        }
        
        
    }
    
    func makeUIViewController(context: Context) -> some UIViewController {
        controller.delegate = context.coordinator
        return controller
        
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
}


/*
 //
 //  ImagePicker.swift
 //  ServiceHourTracker
 //
 //  Created by kalsky_953982 on 2/4/24.
 // reference: https://youtu.be/FFWP7eXn0ck?si=RR9tnucXXxDhFcDQ

 import Foundation
 import SwiftUI

 struct ImagePicker: UIViewControllerRepresentable{
     @Binding var image: UIImage?
     @State private var isImagePickerPresented = false
     
     private let controller = UIImagePickerController()
     
     func makeCoordinator() -> Coordinator {
         return Coordinator(parent: self)
     }
     
     
     class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
         
         let parent: ImagePicker
         init(parent: ImagePicker) {
             self.parent = parent
         }
         //when picked an image
         func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
             if let selection = info[.originalImage] as? UIImage{
                 presentActivityViewController(image: selection )
             }
             picker.dismiss(animated: true)
         }
         // when cancelled the process
         func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
             picker.dismiss(animated: true)
         }
         
         @objc func clearImage(){
             parent.image = nil
         }
         
         func presentActivityViewController(image: UIImage){
             guard let data = image.jpegData(compressionQuality: 1.0) else{return}
                 
             let activityViewController = UIActivityViewController(activityItems: [data], applicationActivities: nil)
             activityViewController.completionWithItemsHandler = { [weak self] _, _, _, _ in
                 
                     self?.parent.image = image
                 }
                 parent.presentViewController(activityViewController)
             }
     }
     
     
             
     func presentViewController(_ viewController: UIViewController) {
             isImagePickerPresented = false
             UIApplication.shared.windows.first?.rootViewController?.present(viewController, animated: true, completion: nil)
     }
     func makeUIViewController(context: Context) -> some UIViewController {
         controller.delegate = context.coordinator
         let trash = UIBarButtonItem(
             barButtonSystemItem: .trash,
             target: context.coordinator,
             action: #selector(Coordinator.clearImage))
         
         return controller
         
     }
     
     func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
         
     }
 }

 */

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

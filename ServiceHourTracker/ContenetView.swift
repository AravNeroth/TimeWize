import SwiftUI

struct SquareCropImageView: View {
    let image: Image
    @State private var scaleFactor: CGFloat = 1.0
    @State private var offset: CGSize = .zero
    @State private var previousScale: CGFloat = 1.0
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Rectangle()
                    .fill(Color.black)
                
                image
                    
                    .resizable()
                    .frame(width: 80,height: 80)
                    .scaledToFill()
                    .scaleEffect(scaleFactor)
                    .offset(offset)
                    
            }
            .gesture(
                MagnificationGesture()
                    .onChanged { scale in
                        self.scaleFactor = scale * self.previousScale
                    }
                    .onEnded { scale in
                        self.previousScale = scale * self.previousScale
                    }
            )
            .gesture(
                DragGesture()
                    .onChanged { value in
                        let xTranslation = value.translation.width
                        let yTranslation = value.translation.height
                        
                        offset.width = xTranslation
                        offset.height = yTranslation
                    }
                    .onEnded { value in
                        let xTranslation = value.translation.width
                        let yTranslation = value.translation.height
                        
                        offset.width += xTranslation
                        offset.height += yTranslation
                    }
            )
            .frame(width: min(geometry.size.width, geometry.size.height),
                   height: min(geometry.size.width, geometry.size.height))
            .clipped()
            .onAppear {
                let imageSize = UIImage(resource: .image3).size
                let scaleFactor = min(geometry.size.width, geometry.size.height) / max(imageSize.width, imageSize.height)
                self.scaleFactor = scaleFactor
            }
        }
    }
}

struct ContenetView: View {
    @State private var showPicker = false
    @State private var selectedImage = UIImage(resource: .image3)
    @State private var newPfp = UIImage(systemName: "person")
    @State var image: Image = Image(.image3)
    @State var image2 = Image(.image3)
    var body: some View {
        ScrollView {
            Image(.image3).scaleEffect(0.5)
            Image(.image3).scaleEffect(0.1).offset(CGSize(width: 50, height: 10.0))
            image2
            SquareCropImageView(image: Image(uiImage: selectedImage))
                .clipShape(Circle()).frame(width: 80, height: 80)
            Button{
                showPicker = true
                let render = ImageRenderer(content: image2.scaleEffect(10).offset(CGSize(width: 50, height: 10.0)))
                if let image = render.cgImage {
                    selectedImage =  UIImage(cgImage: image)
                }
                
            }label: {
                Text("Pick an Image")
            }.padding()
            
        }
        .onAppear{
            let render = ImageRenderer(content: image2.scaleEffect(0.1).offset(CGSize(width: 50, height: 10.0)))
            
            if let image = render.cgImage {
                image2 = Image(uiImage: UIImage(cgImage: image))
            }
            
            
        }
        .sheet(isPresented: $showPicker, content: {
            ImagePicker(image: $newPfp)
        }).onDisappear{
            showPicker = false
            let render = ImageRenderer(content: image2.scaleEffect(0.1).offset(CGSize(width: 50, height: 10.0)))
            if let image = render.cgImage {
                image2 = Image(uiImage: UIImage(cgImage: image))
            }
        }
        .onChange(of: newPfp) { oldValue, newValue in
            if let newPfp = newPfp{
                selectedImage = newPfp
            }
        }
    }
}

struct ImageModifier: ViewModifier {
    let scale: CGFloat
    let offset: CGSize

    func body(content: Content) -> some View {
        content
            .scaleEffect(scale)
            .offset(offset)
    }
}


struct ContenetView_Previews: PreviewProvider {
    static var previews: some View {
        ContenetView()
    }
}

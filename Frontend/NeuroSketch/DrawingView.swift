//
//  DrawingView.swift
//  NeuroSketch
//
//  Created by 아우신얀 on 8/23/25.
//


import SwiftUI
import PencilKit
import UIKit

struct DrawingView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var drawing = PKDrawing()
    @State private var selectedTool: DrawingTool = .pen
        
    var body: some View {
        NavigationView {
            VStack {
                GeometryReader { geometry in
                    CanvasView(
                        drawing: $drawing,
                        tool: $selectedTool,
                        canvasSize: geometry.size
                    )
                    .background(Color.white)
                }
            }
            .navigationBarTitle("Drawing", displayMode: .inline)
            .navigationBarItems(
                leading: Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                },
                trailing: Button("Save") {
                    saveDrawingToPhotos()
                    presentationMode.wrappedValue.dismiss()
                }
            )
        }
    }
    
    private func saveDrawingToPhotos() {
        guard let image = drawing.asImage(size: UIScreen.main.bounds.size) else { return }
        
        saveImageToDocuments(image: image)
    }
    
    private func saveImageToDocuments(image: UIImage) {
        guard let data = image.pngData() else { return }
        
        let fileName = "drawing_\(Date().timeIntervalSince1970).png"
        let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileURL = documentsPath.appendingPathComponent(fileName)
        
        do {
            try data.write(to: fileURL)
            print("Drawing saved to: \(fileURL.path)")
        } catch {
            print("Error saving drawing: \(error)")
        }
    }
}

// MARK: - PKDrawing to UIImage Helper
extension PKDrawing {
    func asImage(size: CGSize) -> UIImage? {
        let bounds = CGRect(origin: .zero, size: size)
        return self.image(from: bounds, scale: UIScreen.main.scale)
    }
}

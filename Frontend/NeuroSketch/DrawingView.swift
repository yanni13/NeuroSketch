//
//  DrawingView.swift
//  NeuroSketch
//
//  Created by 아우신얀 on 8/23/25.
//

import PencilKit
import SwiftUI
import UIKit

struct DrawingView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var drawing = PKDrawing()
    @State private var selectedTool: DrawingTool = .pen

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            
            Spacer().frame(height: 12)
            
            VStack(alignment: .leading, spacing: 3) {
                Text("나무와 집을 그려보세요")
                    .lineSpacing(34)
                    .font(.headline)
                
                Text("그림을 분석해 현재 상태를 알려드릴게요")
                    .lineSpacing(34)
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 10)
            
            Divider()
            
            GeometryReader { geometry in
                CanvasView(
                    drawing: $drawing,
                    tool: $selectedTool,
                    canvasSize: geometry.size
                )
                .background(Color.white)
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }, label: {
                    Image(systemName: "chevron.left")
                        .foregroundStyle(.black)
                })
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    saveDrawingToPhotos()
                    presentationMode.wrappedValue.dismiss()
                }, label: {
                    Text("완료")
                        .foregroundStyle(.black)
                })
            }
        }
        .navigationBarBackButtonHidden()
    }

    private func saveDrawingToPhotos() {
        guard let image = drawing.asImage(size: UIScreen.main.bounds.size)
        else { return }

        saveImageToDocuments(image: image)
    }

    private func saveImageToDocuments(image: UIImage) {
        guard let data = image.pngData() else { return }

        let fileName = "drawing_\(Date().timeIntervalSince1970).png"
        let documentsPath = FileManager.default.urls(
            for: .documentDirectory,
            in: .userDomainMask
        )[0]
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

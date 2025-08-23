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
    @StateObject private var viewModel = DrawingViewModel()
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
                    
                    presentationMode.wrappedValue.dismiss()
                    
                    viewModel.analyzeDrawing(drawing) { success in
                        if success {
                            presentationMode.wrappedValue.dismiss()
                            //TODO: 분석 화면 이동 구현
                        }
                    }
                }, label: {
                    Text("완료")
                        .foregroundStyle(.black)
                })
            }
        }
        .navigationBarBackButtonHidden()
    }
}

// MARK: - PKDrawing to UIImage Helper
extension PKDrawing {
    func asImage(size: CGSize) -> UIImage? {
        let bounds = CGRect(origin: .zero, size: size)
        return self.image(from: bounds, scale: UIScreen.main.scale)
    }
}

//
//  DrawingViewModel.swift
//  NeuroSketch
//
//  Created by Claude on 8/23/25.
//

import Foundation
import PencilKit

class DrawingViewModel: ObservableObject {
    @Published var isAnalyzing = false//분석 중인지 여부
    
    func analyzeDrawing(_ drawing: PKDrawing, completion: @escaping (Bool) -> Void) {
        guard let image = drawing.asImage(size: UIScreen.main.bounds.size),
              let pngData = image.pngData() else {
            print("Failed to convert drawing to PNG data")
            completion(false)
            return
        }
        
        isAnalyzing = true
        
        let request = ImageAnalysisRequestDto(
            imageData: pngData,
            analysisType: "drawing_analysis"
        )
        
        //TODO: 나중에 요청 예정(api 미완성)
//        ImageService.shared.analyzeImage(request: request) { [weak self] result in
//            DispatchQueue.main.async {
//                self?.isAnalyzing = false
//                
//                switch result {
//                case .success:
//                    print("Image analysis request sent successfully")
//                    completion(true)
//                case .failure(let error):
//                    print("Image analysis failed: \(error)")
//                    completion(false)
//                }
//            }
//        }
    }
}

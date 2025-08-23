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
    @Published var drawing = PKDrawing()
    @Published var analysisResult: DrawingAnalysisModel?//분석 완료 후 데이터
    
    func analyzeDrawing(completion: @escaping (Bool) -> Void) {
        guard let image = drawing.asImage(size: UIScreen.main.bounds.size),
              let pngData = image.jpegData(compressionQuality: 0.8) else {
            print("Failed to convert drawing to JPEG data")
            completion(false)
            return
        }
        
        if ((UserDefaults.standard.string(forKey: "uid")?.isEmpty) == nil) {
            UserDefaults.standard.set(UUID().uuidString, forKey: "uid")
        }
        
        isAnalyzing = true
        
        let userId = UserDefaults.standard.string(forKey: "uid") ?? ""
        let request = ImageAnalysisRequestDto(
            userId: userId,
            file: pngData
        )
        
        print("[DrawingViewModel] - Image 분석 요청")
        
        ImageService.shared.analyzeImage(request: request) { [weak self] result in
            DispatchQueue.main.async {
                self?.isAnalyzing = false
                switch result {
                case .success(let dto):
                    print("Image analysis request sent successfully")
                    self?.analysisResult = DrawingAnalysisModel(from: dto)
                    completion(true)
                case .failure(let error):
                    print("Image analysis failed: \(error)")
                    self?.analysisResult = nil
                    completion(false)
                }
            }
        }
    }
}

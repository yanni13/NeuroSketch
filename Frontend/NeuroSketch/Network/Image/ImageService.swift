//
//  ImageService.swift
//  NeuroSketch
//
//  Created by 최희진 on 8/23/25.
//

import Alamofire
import Foundation

/// 이미지 분석 API 통신을 담당하는 싱글톤 서비스
final class ImageService {
    static let shared = ImageService()
    private init() {}

    func analyzeImage(
        request: ImageAnalysisRequestDto,
        completion: @escaping (Result<DrawingAnalysisResponseDto, Error>) -> Void
    ) {
        AF.upload(
            multipartFormData: { multipartFormData in
                multipartFormData.append(
                    request.file,
                    withName: "file",
                    fileName: "drawing.jpeg",
                    mimeType: "multipart/form-data"
                )
            },
            with: ImageRouter.analyzeImage(request: request)
        )
        .validate()
        .response { response in
            switch response.result {
            case .success(let data):
                if let data = data as? Data {
                    
                    do {
                        let analysisResult = try DrawingAnalysisResponseDto.decode(from: data ?? Data())
                        
                        // 디버깅용 로그
                        if let json = String(data: data, encoding: .utf8) {
                            print("📦 서버 응답 성공:\n\(json)")
                        }
                        completion(.success(analysisResult))
                        
                    } catch {
                        print("❌ JSON 파싱 실패: \(error)")
                        if let json = String(data: data, encoding: .utf8) {
                            print("📦 원본 JSON:\n\(json)")
                        }
                        completion(.failure(error))
                    }
                }
            case .failure(let error):
                if let data = response.data,
                   let json = String(data: data, encoding: .utf8)
                {
                    print("📦 서버 응답 원본:\n\(json)")
                }
                completion(.failure(error))
            }
        }
    }
}

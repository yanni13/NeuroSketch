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
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        let router = ImageRouter.analyzeImage(request: request)

        AF.request(router)
            .validate()
            .response { response in
                switch response.result {
                case .success:
                    // 응답 파싱은 제외하고 요청 성공만 처리
                    completion(.success(()))
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

//
//  ImageRouter.swift
//  NeuroSketch
//
//  Created by 최희진 on 8/23/25.
//


import SwiftUI
import Alamofire

/// Image 분석 API 요청을 위한 라우터(enum)
enum ImageRouter: URLRequestConvertible {
    case analyzeImage(request: ImageAnalysisRequestDto)

    var baseURL: URL {
        switch self {
        case .analyzeImage:
            return ApiConstants.baseUrl
        }
    }

    var method: HTTPMethod {
        return .post
    }
    
    var path: String {
        switch self {
        case .analyzeImage(_):
            return ApiConstants.imageAnalysisPath
        }
    }

    func asURLRequest() throws -> URLRequest {
        let url = baseURL.appendingPathComponent(path)
        var request = try URLRequest(url: url, method: method)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        switch self {
        case let .analyzeImage(requestDto):
            let data = try JSONEncoder().encode(requestDto)
            request.httpBody = data
        }

        return request
    }
}

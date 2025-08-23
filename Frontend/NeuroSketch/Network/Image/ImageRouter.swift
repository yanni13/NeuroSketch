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
        return ApiConstants.baseUrl
    }
    
    var method: HTTPMethod {
        return .post
    }
    
    var path: String {
        return ApiConstants.imageAnalysisPath
    }
    
    func asURLRequest() throws -> URLRequest {
        var components = URLComponents(url: baseURL.appendingPathComponent(path), resolvingAgainstBaseURL: false)!
        
        switch self {
        case .analyzeImage(let request):
            components.queryItems = [
                URLQueryItem(name: "userId", value: request.userId)
            ]
        }
        
        guard let url = components.url else {
            throw AFError.invalidURL(url: baseURL)
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.method = method
        
        return urlRequest
    }
}

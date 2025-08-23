//
//  UserRouter.swift
//  NeuroSketch
//
//  Created by 최희진 on 8/23/25.
//

import SwiftUI
import Alamofire

/// User 관련 API 요청을 위한 라우터(enum)
enum UserRouter: URLRequestConvertible {
    case signup(request: SignupRequestDto)

    var baseURL: URL {
        switch self {
        case .signup:
            return ApiConstants.baseUrl
        }
    }

    var method: HTTPMethod {
        return .post
    }

    var path: String {
        switch self {
        case .signup(_):
            return ApiConstants.userSignupPath
        }
    }

    func asURLRequest() throws -> URLRequest {
        let url = baseURL.appendingPathComponent(path)
        var request = try URLRequest(url: url, method: method)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        switch self {
        case let .signup(requestDto):
            let data = try JSONEncoder().encode(requestDto)
            request.httpBody = data
        }

        return request
    }
}

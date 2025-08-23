//
//  UserService.swift
//  NeuroSketch
//
//  Created by 최희진 on 8/23/25.
//

import Alamofire
import Foundation

/// 사용자 관련 API 통신을 담당하는 싱글톤 서비스
final class UserService {
    static let shared = UserService()
    private init() {}

    func signup(
        request: SignupRequestDto,
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        let router = UserRouter.signup(request: request)

        AF.request(router)
            .validate()
            .response { response in
                switch response.result {
                case .success:
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
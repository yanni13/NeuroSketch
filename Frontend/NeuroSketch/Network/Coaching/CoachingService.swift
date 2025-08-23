//
//  CoachingService.swift
//  NeuroSketch
//
//  Created by Claude on 8/23/25.
//

import Alamofire
import Foundation

final class CoachingService {
    static let shared = CoachingService()
    private init() {}
    
    // MARK: - 투두리스트 조회
    func fetchTodoList(
        uid: String,
        completion: @escaping (Result<TodoListResponseDto, Error>) -> Void
    ) {
        let router = CoachingRouter.fetchTodoList(uid: uid)
        
        AF.request(router)
            .validate()
            .responseData { response in
                switch response.result {
                case .success(let data):
                    if let json = String(data: data, encoding: .utf8) {
                        print("📦 투두리스트 조회 성공 응답:\n\(json)")
                    }
                    
                    do {
                        // 직접 배열로 디코딩
                        let todoList = try JSONDecoder().decode(TodoListResponseDto.self, from: data)
                        completion(.success(todoList))
                    } catch {
                        print("❌ JSON 디코딩 실패: \(error)")
                        if let decodingError = error as? DecodingError {
                            print("🔍 디코딩 에러 상세: \(decodingError)")
                        }
                        completion(.failure(error))
                    }
                    
                case .failure(let error):
                    if let data = response.data,
                       let json = String(data: data, encoding: .utf8) {
                        print("📦 투두리스트 조회 실패 응답:\n\(json)")
                    }
                    print("❌ 네트워크 오류: \(error)")
                    completion(.failure(error))
                }
            }
    }
    
    // MARK: - 투두리스트 완료
    func completeTodo(
        uid: String,
        todoId: Int,
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        let router = CoachingRouter.completeTodo(uid: uid, todoId: todoId)
        
        AF.request(router)
            .validate()
            .response { response in
                switch response.result {
                case .success:
                    print("투두리스트 완료 처리 성공")
                    completion(.success(()))
                case .failure(let error):
                    if let data = response.data,
                       let json = String(data: data, encoding: .utf8) {
                        print("📦 투두리스트 완료 실패 응답:\n\(json)")
                    }
                    completion(.failure(error))
                }
            }
    }
    
    // MARK: - 다음 주제 조회
    func fetchNextTopic(
        uid: String,
        completion: @escaping (Result<NextTopicResponseDto, Error>) -> Void
    ) {
        let router = CoachingRouter.fetchNextTopic(uid: uid)
        
        AF.request(router)
            .validate()
            .responseData { response in
                switch response.result {
                case .success(let data):
                    if let json = String(data: data, encoding: .utf8) {
                        print("📦 다음 주제  조회 성공 응답:\n\(json)")
                    }
                    
                    do {
                        let todoList = try JSONDecoder().decode(NextTopicResponseDto.self, from: data)
                        completion(.success(todoList))
                    } catch {
                        print("❌ JSON 디코딩 실패: \(error)")
                        completion(.failure(error))
                    }
                    
                case .failure(let error):
                    print("❌ 네트워크 오류: \(error)")
                    
                    // 404 에러 상세 정보
                    if let httpResponse = response.response {
                        print("📊 HTTP 상태: \(httpResponse.statusCode)")
                        print("🌐 요청 URL: \(httpResponse.url?.absoluteString ?? "nil")")
                    }
                    
                    completion(.failure(error))
                }
            }
    }
}

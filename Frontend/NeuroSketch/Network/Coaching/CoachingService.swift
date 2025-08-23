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
            .responseDecodable(of: TodoListResponseDto.self) { response in
                switch response.result {
                case .success(let todoList):
                    completion(.success(todoList))
                case .failure(let error):
                    if let data = response.data,
                       let json = String(data: data, encoding: .utf8) {
                        print("📦 투두리스트 조회 실패 응답:\n\(json)")
                    }
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
            .responseDecodable(of: NextTopicResponseDto.self) { response in
                switch response.result {
                case .success(let topic):
                    completion(.success(topic))
                case .failure(let error):
                    if let data = response.data,
                       let json = String(data: data, encoding: .utf8) {
                        print("📦 다음 주제 조회 실패 응답:\n\(json)")
                    }
                    completion(.failure(error))
                }
            }
    }
}
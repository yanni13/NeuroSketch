//
//  CoachingRouter.swift
//  NeuroSketch
//
//  Created by Claude on 8/23/25.
//

import SwiftUI
import Alamofire

enum CoachingRouter: URLRequestConvertible {
    case fetchTodoList(uid: String)
    case completeTodo(uid: String, todoId: Int)
    case fetchNextTopic(uid: String)
    
    var baseURL: URL {
        return ApiConstants.baseUrl
    }
    
    var method: HTTPMethod {
        switch self {
        case .fetchTodoList, .fetchNextTopic:
            return .get
        case .completeTodo:
            return .delete
        }
    }
    
    var path: String {
        switch self {
        case .fetchTodoList(let uid):
            return "/api/users/\(uid)/todos"
        case .completeTodo(let uid, let todoId):
            return "/api/users/\(uid)/todos/\(todoId)"
        case .fetchNextTopic:
            return "/api/coaching/topic/next"
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        var components = URLComponents(url: baseURL.appendingPathComponent(path), resolvingAgainstBaseURL: false)!
        
        switch self {
        case .fetchNextTopic(let uid):
            components.queryItems = [
                URLQueryItem(name: "uid", value: uid)
            ]
        default:
            break
        }
        
        guard let url = components.url else {
            throw AFError.invalidURL(url: baseURL)
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.method = method
        
        return urlRequest
    }
}
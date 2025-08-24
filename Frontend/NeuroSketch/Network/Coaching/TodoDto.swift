//
//  TodoDto.swift
//  NeuroSketch
//
//  Created by Claude on 8/23/25.
//

import Foundation

// MARK: - Todo Item Response DTO
struct TodoItemResponseDto: Codable {
    let id: Int
    let userId: String
    let activity: String
    let done: Bool  // isDone → done으로 변경
    let createdAt: String
    let updatedAt: String
    
    // UI에서 사용할 computed property
    var isDone: Bool {
        return done
    }
}

// MARK: - Todo List Response DTO
typealias TodoListResponseDto = [TodoItemResponseDto]

// MARK: - Todo Complete Request DTO
struct TodoCompleteRequestDto: Codable {
    let uid: String
    let todoId: Int
}

// MARK: - Todo Complete Response DTO
struct TodoCompleteResponseDto: Codable {
    let success: Bool
    let message: String?
}

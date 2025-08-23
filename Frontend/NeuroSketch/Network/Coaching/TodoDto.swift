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
    let content: String
    let completed: Bool
}

// MARK: - Todo List Response DTO
struct TodoListResponseDto: Codable {
    let todos: [TodoItemResponseDto]
}

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

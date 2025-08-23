//
//  ContentViewModel.swift
//  NeuroSketch
//
//  Created by Claude on 8/23/25.
//

import Foundation

class ContentViewModel: ObservableObject {
    @Published var todoItems: [TodoItemResponseDto] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    var pendingTodos: [TodoItemResponseDto] {
        return todoItems.filter { !$0.isDone }
    }
    
    var completedTodos: [TodoItemResponseDto] {
        return todoItems.filter { $0.isDone }
    }
    
    func fetchTodoList() {
        guard let uid = UserDefaults.standard.string(forKey: "uid"), !uid.isEmpty else {
            print("UID가 없습니다.")
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        CoachingService.shared.fetchTodoList(uid: uid) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                
                switch result {
                case .success(let response):
//                    print("투두리스트 조회 성공: \(response.todos.count)개")
                    self?.todoItems = response
                    self?.errorMessage = nil
                case .failure(let error):
                    print("투두리스트 조회 실패: \(error)")
                    self?.errorMessage = error.localizedDescription
                    self?.todoItems = []
                }
            }
        }
    }
    
    func completeTodo(todoId: Int, completion: @escaping (Bool) -> Void) {
        guard let uid = UserDefaults.standard.string(forKey: "uid"), !uid.isEmpty else {
            print("UID가 없습니다.")
            completion(false)
            return
        }
        
        CoachingService.shared.completeTodo(uid: uid, todoId: todoId) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    print("투두 완료 처리 성공")
                    self?.fetchTodoList() // 목록 새로고침
                    completion(true)
                case .failure(let error):
                    print("투두 완료 API 호출 실패: \(error)")
                    completion(false)
                }
            }
        }
    }
}

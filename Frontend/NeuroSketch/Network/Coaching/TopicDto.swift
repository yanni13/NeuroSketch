//
//  TopicDto.swift
//  NeuroSketch
//
//  Created by Claude on 8/23/25.
//

import Foundation

// MARK: - Next Topic Response DTO
struct NextTopicResponseDto: Codable {
    let id: Int
    let userId: String
    let content: String
    let createdAt: String
}

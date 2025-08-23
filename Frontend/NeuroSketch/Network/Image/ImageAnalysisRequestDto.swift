//
//  ImageAnalysisRequestDto.swift
//  NeuroSketch
//
//  Created by 최희진 on 8/23/25.
//

import Foundation


// TODO: 수정 필요
struct ImageAnalysisRequestDto: Codable {
    let imageData: Data
    let analysisType: String
    
    enum CodingKeys: String, CodingKey {
        case imageData = "image_data"
        case analysisType = "analysis_type"
    }
}

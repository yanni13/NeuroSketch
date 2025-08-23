//
//  EmotionUtils.swift
//  NeuroSketch
//
//  Created by Claude on 8/24/25.
//

import Foundation

class EmotionUtils {
    static func getKoreanEmotion(for emotion: String) -> String {
        switch emotion.uppercased() {
        case "PEACE":
            return "평온"
        case "ANGER":
            return "분노"
        case "JOY", "HAPPINESS":
            return "기쁨"
        case "SADNESS":
            return "슬픔"
        case "FEAR":
            return "두려움"
        case "SURPRISE":
            return "놀람"
        case "DISGUST":
            return "혐오"
        case "CALM":
            return "평온"
        default:
            return emotion // 이미 한국어인 경우 그대로 반환
        }
    }
    
    static func getEmotionEmoji(for emotion: String) -> String {
        switch emotion.lowercased() {
        case "기쁨", "행복", "joy", "happiness":
            return "😊"
        case "분노", "화남", "anger":
            return "😡"
        case "슬픔", "sadness":
            return "😢"
        case "두려움", "fear":
            return "😨"
        case "놀람", "surprise":
            return "😮"
        case "혐오", "disgust":
            return "🤢"
        case "평온", "calm", "peace":
            return "😌"
        default:
            return "😐"
        }
    }
}
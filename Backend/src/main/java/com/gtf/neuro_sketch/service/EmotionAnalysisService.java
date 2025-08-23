package com.gtf.neuro_sketch.service;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.gtf.neuro_sketch.model.EmotionalState;
import lombok.Getter;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
@Slf4j
public class EmotionAnalysisService {

    private final SolarAIService solarAIService;
    private final ObjectMapper objectMapper;

    public EmotionalState analyzeEmotion(String imageAnalysisResult) {
        String emotionAnalysisPrompt = buildEmotionAnalysisPrompt(imageAnalysisResult);
        String aiResponse = solarAIService.generateResponse(emotionAnalysisPrompt);

        return parseEmotionAnalysisResult(aiResponse);
    }

    private String buildEmotionAnalysisPrompt(String imageAnalysisResult) {
        return String.format("""
                다음 그림 분석 결과를 바탕으로 사용자의 감정 상태를 분석하여 JSON 형태로 정확하게 답변해주세요:
                
                그림 분석 결과:
                %s
                
                다음 형식으로 감정 분석 결과를 반환하세요:
                {
                    "primaryEmotion": "HAPPINESS/SADNESS/ANGER/ANXIETY/PEACE 중 하나",
                    "intensity": "1-10 사이의 감정 강도",
                    "confidence": "0.0-1.0 사이의 분석 신뢰도",
                    "reasoning": "이 감정으로 분석한 구체적인 근거와 이유"
                }
                
                분석 기준:
                - HAPPINESS: 밝은 색상, 균형잡힌 구성, 완성도 높은 그림
                - SADNESS: 어두운 색조, 낮은 밝기, 미완성된 느낌
                - ANGER: 강한 선, 대비가 높은 색상, 불균형한 구성
                - ANXIETY: 혼재된 특성, 무질서한 구성, 불일정한 선
                - PEACE: 중성 색온도, 체계적 구성, 보통 강도의 특성
                
                반드시 ```json ```으로 감싸지 말고 JSON 형식으로 반환하세요.
                """, imageAnalysisResult);
    }

    private EmotionalState parseEmotionAnalysisResult(String aiResponse) {
        try {
            log.info("Parsing emotion analysis result: {}", aiResponse);
            EmotionAnalysisResult result = objectMapper.readValue(aiResponse, EmotionAnalysisResult.class);

            EmotionalState emotionalState = new EmotionalState();
            emotionalState.setPrimaryEmotion(result.getPrimaryEmotion());
            emotionalState.setIntensity(result.getIntensity());
            emotionalState.setConfidence(result.getConfidence());
            emotionalState.setReasoning(result.getReasoning());
            emotionalState.setTimestamp(System.currentTimeMillis());

            return emotionalState;
        } catch (JsonProcessingException e) {
            log.error("Failed to parse emotion analysis result", e);
            return createDefaultEmotionalState();
        }
    }

    private EmotionalState createDefaultEmotionalState() {
        return new EmotionalState("PEACE", 5, 0.5, "분석 실패로 인한 기본값", System.currentTimeMillis());
    }

    @Getter
    private static class EmotionAnalysisResult {
        public String primaryEmotion;
        public int intensity;
        public double confidence;
        public String reasoning;

    }
}
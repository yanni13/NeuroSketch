package com.gtf.neuro_sketch.model;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class CoachingResponse {
    // 기존 필드들
    private EmotionalState analyzedEmotion;
    private AgentDecision agentDecision;
    private String personalizedMessage;
    private List<String> recommendations;
    private String nextDrawingTheme;
    private boolean requiresFollowUp;
    private long timestamp;
    
    // 새로 추가된 필드들
    private CareStatus careStatus;  // 케어 상태
    private ImageAnalysisResult imageAnalysis;  // 상세 그림 분석 결과
    private PsychologicalInterpretation psychologicalInterpretation;  // 심리학적 해석
    private String aiAdvice;  // AI 조언
    private List<String> recommendedActivities;  // 추천 활동
    private String nextDrawingThemeDescription;  // 다음 그림 주제 추천 문구
}
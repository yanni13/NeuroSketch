package com.gtf.neuro_sketch.model;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class PsychologicalInterpretation {
    private String overallPsychologicalAssessment;
    private List<ArtTherapyInsight> artTherapyInsights;
    private String emotionalExpressionAnalysis;
    private String developmentalIndicators;
    private String traumaOrStressIndicators;
    private String resilienceIndicators;
    private String communicationStyle;
    
    @Data
    @NoArgsConstructor
    @AllArgsConstructor
    public static class ArtTherapyInsight {
        private String element;  // 색상, 형태, 배치 등
        private String observation;  // 관찰된 특성
        private String psychologicalMeaning;  // 심리학적 의미
        private String artTherapyContext;  // 미술치료적 맥락
    }
}
package com.gtf.neuro_sketch.document;

import com.gtf.neuro_sketch.model.PsychologicalInterpretation;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

import java.util.List;

@Document(collection = "psychological_interpretations")
@Data
@AllArgsConstructor
@NoArgsConstructor
public class PsychologicalInterpretationDocument {
    @Id
    private String id;
    private String userId;
    private String overallPsychologicalAssessment;
    private List<PsychologicalInterpretationDocument.ArtTherapyInsight> artTherapyInsights;
    private String emotionalExpressionAnalysis;
    private String developmentalIndicators;
    private String traumaOrStressIndicators;
    private String resilienceIndicators;
    private String communicationStyle;
    private long createdAt;

    public static PsychologicalInterpretationDocument from(PsychologicalInterpretation interpretation, String userId) {
        PsychologicalInterpretationDocument document = new PsychologicalInterpretationDocument();
        document.setUserId(userId);
        document.setOverallPsychologicalAssessment(interpretation.getOverallPsychologicalAssessment());
        document.setArtTherapyInsights(interpretation.getArtTherapyInsights());
        document.setEmotionalExpressionAnalysis(interpretation.getEmotionalExpressionAnalysis());
        document.setDevelopmentalIndicators(interpretation.getDevelopmentalIndicators());
        document.setTraumaOrStressIndicators(interpretation.getTraumaOrStressIndicators());
        document.setResilienceIndicators(interpretation.getResilienceIndicators());
        document.setCommunicationStyle(interpretation.getCommunicationStyle());
        document.setCreatedAt(System.currentTimeMillis());
        return document;
    }

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
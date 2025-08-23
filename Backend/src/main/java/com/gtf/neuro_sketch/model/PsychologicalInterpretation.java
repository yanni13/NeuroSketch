package com.gtf.neuro_sketch.model;

import com.gtf.neuro_sketch.document.PsychologicalInterpretationDocument;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class PsychologicalInterpretation {
    private String overallPsychologicalAssessment;
    private List<PsychologicalInterpretationDocument.ArtTherapyInsight> artTherapyInsights;
    private String emotionalExpressionAnalysis;
    private String developmentalIndicators;
    private String traumaOrStressIndicators;
    private String resilienceIndicators;
    private String communicationStyle;
}
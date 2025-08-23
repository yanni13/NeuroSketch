package com.gtf.neuro_sketch.event;

import com.gtf.neuro_sketch.model.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class CoachingDataSaveEvent {
    private String userId;
    private EmotionalState emotionalState;
    private ImageAnalysisResult imageAnalysisResult;
    private PsychologicalInterpretation psychologicalInterpretation;
    private AgentDecision agentDecision;
    private CareStatus careStatus;
    private String personalizedMessage;
    private List<String> recommendations;
    private String aiAdvice;
    private List<String> recommendedActivities;
    private String nextThemeDescription;
    private long timestamp;
}
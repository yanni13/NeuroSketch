package com.gtf.neuro_sketch.model;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class CoachingResponse {
    private EmotionalState analyzedEmotion;
    private AgentDecision agentDecision;
    private String personalizedMessage;
    private List<String> recommendations;
    private String nextDrawingTheme;
    private boolean requiresFollowUp;
    private long timestamp;
}
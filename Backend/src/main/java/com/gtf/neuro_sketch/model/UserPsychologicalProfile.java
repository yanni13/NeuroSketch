package com.gtf.neuro_sketch.model;

import lombok.Data;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Data
public class UserPsychologicalProfile {
    private String userId;
    private List<EmotionalState> emotionalHistory;
    private Map<String, Double> emotionalPatterns;
    private Map<String, Object> personalityTraits;
    private List<String> stressFactors;
    private List<String> copingStrategies;
    private int resilience;
    private long lastAnalyzed;

    public UserPsychologicalProfile(String userId) {
        this.userId = userId;
        this.emotionalHistory = new ArrayList<>();
        this.emotionalPatterns = new HashMap<>();
        this.personalityTraits = new HashMap<>();
        this.stressFactors = new ArrayList<>();
        this.copingStrategies = new ArrayList<>();
        this.resilience = 5;
        this.lastAnalyzed = System.currentTimeMillis();
    }

    public void addEmotionalState(EmotionalState state) {
        this.emotionalHistory.add(state);
        this.lastAnalyzed = System.currentTimeMillis();
    }

    public EmotionalState getLatestEmotionalState() {
        if (emotionalHistory.isEmpty()) {
            return null;
        }
        return emotionalHistory.getLast();
    }
}
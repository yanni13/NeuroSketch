package com.gtf.neuro_sketch.model;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class EmotionalState {
    private String primaryEmotion;
    private int intensity;
    private double confidence;
    private String reasoning;
    private long timestamp;
    
    public enum Emotion {
        HAPPINESS("행복"), 
        SADNESS("슬픔"), 
        ANGER("분노"), 
        ANXIETY("불안"), 
        PEACE("평온");
        
        private final String korean;
        
        Emotion(String korean) {
            this.korean = korean;
        }
        
        public String getKorean() {
            return korean;
        }
    }
}
package com.gtf.neuro_sketch.model;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class AgentDecision {
    private String decisionType;
    private String reasoning;
    private int urgencyLevel;
    private List<String> recommendedActions;
    private String nextDrawingTheme;
    private boolean requiresImmediate;
    private long timestamp;
    
    public enum DecisionType {
        ENCOURAGE("격려"),
        REDIRECT("전환"),
        SUPPORT("지지"),
        CHALLENGE("도전"),
        MONITOR("관찰"),
        INTERVENTION("개입");
        
        private final String korean;
        
        DecisionType(String korean) {
            this.korean = korean;
        }
        
        public String getKorean() {
            return korean;
        }
    }
}
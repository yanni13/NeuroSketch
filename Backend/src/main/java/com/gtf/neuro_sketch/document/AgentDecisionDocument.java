package com.gtf.neuro_sketch.document;

import com.gtf.neuro_sketch.model.AgentDecision;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

import java.util.List;

@Document(collection = "agent_decisions")
@Data
@AllArgsConstructor
@NoArgsConstructor
public class AgentDecisionDocument {
    @Id
    private String id;
    private String userId;
    private String decisionType;
    private String reasoning;
    private int urgencyLevel;
    private List<String> recommendedActions;
    private String nextDrawingTheme;
    private boolean requiresImmediate;
    private long decisionTimestamp;
    private long createdAt;

    public static AgentDecisionDocument from(AgentDecision decision, String userId) {
        AgentDecisionDocument document = new AgentDecisionDocument();
        document.setUserId(userId);
        document.setDecisionType(decision.getDecisionType());
        document.setReasoning(decision.getReasoning());
        document.setUrgencyLevel(decision.getUrgencyLevel());
        document.setRecommendedActions(decision.getRecommendedActions());
        document.setNextDrawingTheme(decision.getNextDrawingTheme());
        document.setRequiresImmediate(decision.isRequiresImmediate());
        document.setDecisionTimestamp(decision.getTimestamp());
        document.setCreatedAt(System.currentTimeMillis());
        return document;
    }
}
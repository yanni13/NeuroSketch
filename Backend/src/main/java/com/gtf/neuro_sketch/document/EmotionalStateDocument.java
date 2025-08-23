package com.gtf.neuro_sketch.document;

import com.gtf.neuro_sketch.model.EmotionalState;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

@Document(collection = "emotional_states")
@Data
@AllArgsConstructor
@NoArgsConstructor
public class EmotionalStateDocument {
    @Id
    private String id;
    private String userId;
    private String primaryEmotion;
    private int intensity;
    private double confidenceScore;
    private String reasoning;
    private long timestamp;
    private long createdAt;

    public static EmotionalStateDocument from(EmotionalState emotionalState, String userId) {
        EmotionalStateDocument document = new EmotionalStateDocument();
        document.setUserId(userId);
        document.setPrimaryEmotion(emotionalState.getPrimaryEmotion());
        document.setIntensity(emotionalState.getIntensity());
        document.setConfidenceScore(emotionalState.getConfidence());
        document.setReasoning(emotionalState.getReasoning());
        document.setTimestamp(emotionalState.getTimestamp());
        document.setCreatedAt(System.currentTimeMillis());
        return document;
    }
}
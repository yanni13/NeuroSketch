package com.gtf.neuro_sketch.document;

import com.gtf.neuro_sketch.model.CareStatus;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

@Document(collection = "care_statuses")
@Data
@AllArgsConstructor
@NoArgsConstructor
public class CareStatusDocument {
    @Id
    private String id;
    private String userId;
    private String level;
    private String description;
    private int urgencyScore;
    private String recommendation;
    private long assessmentTimestamp;
    private long createdAt;

    public static CareStatusDocument from(CareStatus careStatus, String userId) {
        CareStatusDocument document = new CareStatusDocument();
        document.setUserId(userId);
        document.setLevel(careStatus.getLevel());
        document.setDescription(careStatus.getDescription());
        document.setUrgencyScore(careStatus.getUrgencyScore());
        document.setRecommendation(careStatus.getRecommendedAction());
        document.setAssessmentTimestamp(System.currentTimeMillis());
        document.setCreatedAt(System.currentTimeMillis());
        return document;
    }
}
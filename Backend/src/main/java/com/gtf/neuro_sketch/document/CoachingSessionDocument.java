package com.gtf.neuro_sketch.document;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

import java.util.List;

@Document(collection = "coaching_sessions")
@Data
@AllArgsConstructor
@NoArgsConstructor
public class CoachingSessionDocument {
    @Id
    private String id;
    private String userId;
    private String personalizedMessage;
    private List<String> recommendations;
    private String aiAdvice;
    private List<String> recommendedActivities;
    private String nextThemeDescription;
    private long timestamp;
    private long createdAt = System.currentTimeMillis();
}
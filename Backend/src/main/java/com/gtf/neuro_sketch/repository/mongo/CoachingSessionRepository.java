package com.gtf.neuro_sketch.repository.mongo;

import com.gtf.neuro_sketch.document.CoachingSessionDocument;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface CoachingSessionRepository extends MongoRepository<CoachingSessionDocument, String> {
    List<CoachingSessionDocument> findByUserIdOrderByTimestampDesc(String userId);
    List<CoachingSessionDocument> findByUserIdAndTimestampBetween(String userId, long startTime, long endTime);
}
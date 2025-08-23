package com.gtf.neuro_sketch.repository.mongo;

import com.gtf.neuro_sketch.document.EmotionalStateDocument;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface EmotionalStateRepository extends MongoRepository<EmotionalStateDocument, String> {
    List<EmotionalStateDocument> findByUserIdOrderByTimestampDesc(String userId);
    List<EmotionalStateDocument> findByUserIdAndTimestampBetween(String userId, long startTime, long endTime);
}
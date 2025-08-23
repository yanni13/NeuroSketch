package com.gtf.neuro_sketch.repository.mongo;

import com.gtf.neuro_sketch.document.CareStatusDocument;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface CareStatusRepository extends MongoRepository<CareStatusDocument, String> {
    List<CareStatusDocument> findByUserIdOrderByAssessmentTimestampDesc(String userId);
    List<CareStatusDocument> findByUserIdAndAssessmentTimestampBetween(String userId, long startTime, long endTime);
    List<CareStatusDocument> findByLevel(String level);
}
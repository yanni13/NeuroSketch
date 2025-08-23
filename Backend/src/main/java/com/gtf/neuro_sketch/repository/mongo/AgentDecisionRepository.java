package com.gtf.neuro_sketch.repository.mongo;

import com.gtf.neuro_sketch.document.AgentDecisionDocument;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface AgentDecisionRepository extends MongoRepository<AgentDecisionDocument, String> {
    List<AgentDecisionDocument> findByUserIdOrderByDecisionTimestampDesc(String userId);
    List<AgentDecisionDocument> findByUserIdAndDecisionTimestampBetween(String userId, long startTime, long endTime);
    List<AgentDecisionDocument> findByDecisionType(String decisionType);
}
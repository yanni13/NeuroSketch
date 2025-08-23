package com.gtf.neuro_sketch.repository.mongo;

import com.gtf.neuro_sketch.document.PsychologicalInterpretationDocument;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface PsychologicalInterpretationRepository extends MongoRepository<PsychologicalInterpretationDocument, String> {
    List<PsychologicalInterpretationDocument> findByUserIdOrderByCreatedAtDesc(String userId);

    List<PsychologicalInterpretationDocument> findByUserIdAndCreatedAtBetween(String userId, long startTime, long endTime);
}
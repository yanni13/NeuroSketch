package com.gtf.neuro_sketch.repository.mongo;

import com.gtf.neuro_sketch.document.ImageAnalysisDocument;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface ImageAnalysisRepository extends MongoRepository<ImageAnalysisDocument, String> {
    List<ImageAnalysisDocument> findByUserIdOrderByCreatedAtDesc(String userId);

    List<ImageAnalysisDocument> findByUserIdAndCreatedAtBetween(String userId, long startTime, long endTime);
}
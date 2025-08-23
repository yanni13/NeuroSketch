package com.gtf.neuro_sketch.controller;

import com.gtf.neuro_sketch.model.ImageAnalysisResult;
import com.gtf.neuro_sketch.service.ImageAnalysisService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;

@RestController
@RequestMapping("/api")
@RequiredArgsConstructor
public class ImageAnalysisController {

    private final ImageAnalysisService imageAnalysisService;

    @PostMapping("/analyze")
    public ResponseEntity<ImageAnalysisResult> analyzeImage(@RequestBody MultipartFile file) {
        String contentType = file.getContentType();
//        if (!"image/png".equals(contentType)) {
//            return ResponseEntity.badRequest().body("PNG 파일만 허용됩니다.");
//        }

        try {
            ImageAnalysisResult analysisResult = imageAnalysisService.analyzeImage(file);
            return ResponseEntity.ok(analysisResult);
        } catch (IOException e) {
            throw new RuntimeException("이미지 분석 중 오류가 발생했습니다: " + e.getMessage(), e);
        }
    }
}
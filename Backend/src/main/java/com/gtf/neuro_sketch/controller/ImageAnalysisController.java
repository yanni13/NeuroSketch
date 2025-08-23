package com.gtf.neuro_sketch.controller;

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
    public ResponseEntity<String> analyzeImage(@RequestBody MultipartFile file) {
        String contentType = file.getContentType();
//        if (!"image/png".equals(contentType)) {
//            return ResponseEntity.badRequest().body("PNG 파일만 허용됩니다.");
//        }

        try {
            String analysisResult = imageAnalysisService.analyzeImage(file);
            return ResponseEntity.ok(analysisResult);
        } catch (IOException e) {
            return ResponseEntity.internalServerError().body("이미지 처리 중 오류가 발생했습니다.");
        }
    }
}
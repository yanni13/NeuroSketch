package com.gtf.neuro_sketch.controller;

import com.gtf.neuro_sketch.model.CoachingResponse;
import com.gtf.neuro_sketch.service.AutonomousCoachingService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;

@RestController
@RequestMapping("/api/coaching")
@RequiredArgsConstructor
public class AutonomousCoachingController {

    private final AutonomousCoachingService coachingService;

    @PostMapping("/analyze")
    public ResponseEntity<CoachingResponse> analyzeImageAndCoach(
            @RequestParam("userId") String userId,
            @RequestBody MultipartFile file) {

        try {
            CoachingResponse response = coachingService.processImageAndProvideCoaching(userId, file);
            return ResponseEntity.ok(response);
        } catch (IOException e) {
            return ResponseEntity.internalServerError().build();
        }
    }

    @GetMapping("/guidance/{userId}")
    public ResponseEntity<CoachingResponse> getPersonalizedGuidance(@PathVariable String userId) {
        CoachingResponse response = coachingService.getPersonalizedGuidance(userId);
        return ResponseEntity.ok(response);
    }
}
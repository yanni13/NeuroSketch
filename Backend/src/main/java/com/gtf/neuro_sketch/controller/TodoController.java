package com.gtf.neuro_sketch.controller;

import com.gtf.neuro_sketch.model.RecommendedActivity;
import com.gtf.neuro_sketch.model.ThemeDescription;
import com.gtf.neuro_sketch.service.AutonomousCoachingService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/users")
@RequiredArgsConstructor
@Slf4j
public class TodoController {

    private final AutonomousCoachingService coachingService;

    @GetMapping("/{user_id}/todos")
    public ResponseEntity<List<RecommendedActivity>> getTodos(@PathVariable("user_id") String userId) {
        log.info("Getting todos for user: {}", userId);
        List<RecommendedActivity> todos = coachingService.getAllRecommendedActivities(userId);
        return ResponseEntity.ok(todos);
    }

    @DeleteMapping("/{user_id}/todos/{todo_id}")
    public ResponseEntity<Void> completeTodo(
            @PathVariable("user_id") String userId,
            @PathVariable("todo_id") Long todoId) {
        
        log.info("Completing todo for user: {}, todoId: {}", userId, todoId);
        
        coachingService.markActivityAsDone(todoId);
        
        return ResponseEntity.ok().build();
    }

    @GetMapping("/{user_id}/topics/next")
    public ResponseEntity<ThemeDescription> getNextTopic(@PathVariable("user_id") String userId) {
        log.info("Getting next topic for user: {}", userId);
        ThemeDescription nextTopic = coachingService.getLatestThemeDescription(userId);
        
        if (nextTopic == null) {
            return ResponseEntity.notFound().build();
        }
        
        return ResponseEntity.ok(nextTopic);
    }
}
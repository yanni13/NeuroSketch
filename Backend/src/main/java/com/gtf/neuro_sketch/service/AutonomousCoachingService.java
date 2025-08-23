package com.gtf.neuro_sketch.service;

import com.gtf.neuro_sketch.model.AgentDecision;
import com.gtf.neuro_sketch.model.CoachingResponse;
import com.gtf.neuro_sketch.model.EmotionalState;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.List;

@Service
@RequiredArgsConstructor
@Slf4j
public class AutonomousCoachingService {

    private final ImageAnalysisService imageAnalysisService;
    private final EmotionAnalysisService emotionAnalysisService;
    private final PsychologicalProfileService profileService;
    private final AIAgentService agentService;

    public CoachingResponse processImageAndProvideCoaching(String userId, MultipartFile imageFile) throws IOException {
        log.info("Starting autonomous coaching process for user: {}", userId);

        String imageAnalysisResult = imageAnalysisService.analyzeImage(imageFile);
        log.info("Image analysis completed for user: {}", userId);

        EmotionalState emotionalState = emotionAnalysisService.analyzeEmotion(imageAnalysisResult);
        log.info("Emotion analysis completed - emotion: {}, intensity: {}",
                emotionalState.getPrimaryEmotion(), emotionalState.getIntensity());

        profileService.updateUserProfile(userId, emotionalState);
        log.info("User profile updated for user: {}", userId);

        AgentDecision decision = agentService.makeAutonomousDecision(userId, emotionalState);
        log.info("Agent decision made - type: {}, urgency: {}",
                decision.getDecisionType(), decision.getUrgencyLevel());

        String personalizedMessage = agentService.generatePersonalizedMessage(userId, decision, emotionalState);
        log.info("Personalized message generated for user: {}", userId);

        List<String> recommendations = profileService.getRecommendations(userId);

        CoachingResponse response = new CoachingResponse(
                emotionalState,
                decision,
                personalizedMessage,
                recommendations,
                decision.getNextDrawingTheme(),
                decision.isRequiresImmediate(),
                System.currentTimeMillis()
        );

        log.info("Coaching response completed for user: {} - requires follow-up: {}",
                userId, response.isRequiresFollowUp());

        return response;
    }

    public CoachingResponse getPersonalizedGuidance(String userId) {
        log.info("Generating personalized guidance for user: {}", userId);

        EmotionalState latestState = profileService.getUserProfile(userId).getLatestEmotionalState();

        if (latestState == null) {
            return createWelcomeResponse(userId);
        }

        AgentDecision decision = agentService.makeAutonomousDecision(userId, latestState);
        String personalizedMessage = agentService.generatePersonalizedMessage(userId, decision, latestState);
        List<String> recommendations = profileService.getRecommendations(userId);

        return new CoachingResponse(
                latestState,
                decision,
                personalizedMessage,
                recommendations,
                decision.getNextDrawingTheme(),
                decision.isRequiresImmediate(),
                System.currentTimeMillis()
        );
    }

    private CoachingResponse createWelcomeResponse(String userId) {
        EmotionalState defaultState = new EmotionalState("PEACE", 5, 0.8, "새로운 사용자 환영", System.currentTimeMillis());

        AgentDecision welcomeDecision = new AgentDecision(
                "ENCOURAGE",
                "새로운 사용자에게 동기부여와 안내 제공",
                3,
                List.of("그림을 통해 현재 기분을 표현해보세요", "편안한 마음으로 시작해보세요"),
                "현재 기분을 자유롭게 표현하는 그림",
                false,
                System.currentTimeMillis()
        );

        String welcomeMessage = "안녕하세요! 그림을 통해 당신의 감정을 이해하고 성장을 돕는 AI 코치입니다. " +
                "첫 번째 그림을 그려서 현재 기분을 자유롭게 표현해보세요. 어떤 색깔이든, 어떤 형태든 상관없어요.";

        return new CoachingResponse(
                defaultState,
                welcomeDecision,
                welcomeMessage,
                welcomeDecision.getRecommendedActions(),
                welcomeDecision.getNextDrawingTheme(),
                false,
                System.currentTimeMillis()
        );
    }
}
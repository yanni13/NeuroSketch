package com.gtf.neuro_sketch.service;

import com.gtf.neuro_sketch.model.*;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@Service
@RequiredArgsConstructor
@Slf4j
public class AutonomousCoachingService {

    private final ImageAnalysisService imageAnalysisService;
    private final EmotionAnalysisService emotionAnalysisService;
    private final PsychologicalProfileService profileService;
    private final AIAgentService agentService;
    private final PsychologicalInterpretationService interpretationService;
    private final CareStatusService careStatusService;

    public CoachingResponse processImageAndProvideCoaching(String userId, MultipartFile imageFile) throws IOException {
        log.info("Starting autonomous coaching process for user: {}", userId);

        // 이미지 분석
        ImageAnalysisResult imageAnalysisResult = imageAnalysisService.analyzeImage(imageFile);
        log.info("Image analysis completed for user: {}", userId);

        // 감정 상태 분석
        EmotionalState emotionalState = emotionAnalysisService.analyzeEmotion(imageAnalysisResult);
        log.info("Emotion analysis completed - emotion: {}, intensity: {}",
                emotionalState.getPrimaryEmotion(), emotionalState.getIntensity());

        // 심리학적 해석 생성
        PsychologicalInterpretation psychInterpretation = interpretationService.generateInterpretation(imageAnalysisResult);
        log.info("Psychological interpretation completed for user: {}", userId);

        // 사용자 프로필 업데이트
        profileService.updateUserProfile(userId, emotionalState);
        log.info("User profile updated for user: {}", userId);
        
        // 케어 상태 평가
        UserPsychologicalProfile profile = profileService.getUserProfile(userId);
        CareStatus careStatus = careStatusService.assessCareStatus(userId, emotionalState, profile);
        log.info("Care status assessed - level: {}, urgency: {}", careStatus.getLevel(), careStatus.getUrgencyScore());

        // AI 에이전트 의사결정
        AgentDecision decision = agentService.makeAutonomousDecision(userId, emotionalState);
        log.info("Agent decision made - type: {}, urgency: {}",
                decision.getDecisionType(), decision.getUrgencyLevel());

        // 개인화된 메시지 생성
        String personalizedMessage = agentService.generatePersonalizedMessage(userId, decision, emotionalState);
        log.info("Personalized message generated for user: {}", userId);

        // AI 조언 생성
        String aiAdvice = generateAIAdvice(emotionalState, careStatus, psychInterpretation);
        
        // 추천 활동 생성
        List<String> recommendations = profileService.getRecommendations(userId);
        List<String> recommendedActivities = generateRecommendedActivities(emotionalState, careStatus);
        
        // 다음 그림 주제 상세 설명
        String nextThemeDescription = generateNextDrawingThemeDescription(decision.getNextDrawingTheme(), emotionalState);

        // 종합 응답 생성
        CoachingResponse response = new CoachingResponse(
                emotionalState,
                decision,
                personalizedMessage,
                recommendations,
                decision.getNextDrawingTheme(),
                decision.isRequiresImmediate(),
                System.currentTimeMillis(),
                careStatus,
                imageAnalysisResult,
                psychInterpretation,
                aiAdvice,
                recommendedActivities,
                nextThemeDescription
        );

        log.info("Coaching response completed for user: {} - requires follow-up: {}",
                userId, response.isRequiresFollowUp());

        return response;
    }
    
    private String generateAIAdvice(EmotionalState emotionalState, CareStatus careStatus, PsychologicalInterpretation interpretation) {
        StringBuilder advice = new StringBuilder();
        
        // 기본 AI 조언
        advice.append("그림을 통한 번리스러운 감정 표현을 보여주셨네요. ");
        
        switch (emotionalState.getPrimaryEmotion()) {
            case "HAPPINESS" -> advice.append("현재의 긍정적인 에너지를 유지하며, 새로운 창작 활동에 도전해보세요.");
            case "SADNESS" -> advice.append("슬픔 감정도 소중한 자신의 일부입니다. 따뜻한 색갈을 사용한 그림으로 마음을 달래보세요.");
            case "ANGER" -> advice.append("강렬한 감정도 그림을 통해 건설적으로 표현할 수 있습니다. 차가운 색조로 마음을 진정시켜보세요.");
            case "ANXIETY" -> advice.append("불안한 마음을 그림으로 표현하는 것 자체가 치유의 시작입니다. 심호흡과 함께 차분한 그림에 집중해보세요.");
            case "PEACE" -> advice.append("평온한 마음 상태가 잘 표현되었네요. 이 안정감을 유지하며 더 깊이 자신을 탐구해보세요.");
        }
        
        // 케어 상태에 따른 추가 조언
        if (careStatus.getUrgencyScore() >= 7) {
            advice.append(" 현재 감정 관리가 중요한 시기이니, 자신을 돌보는 시간을 충분히 가져주세요.");
        }
        
        return advice.toString();
    }
    
    private List<String> generateRecommendedActivities(EmotionalState emotionalState, CareStatus careStatus) {
        List<String> activities = new ArrayList<>();
        
        // 감정 상태에 따른 추천 활동
        switch (emotionalState.getPrimaryEmotion()) {
            case "HAPPINESS" -> {
                activities.add("다채로운 색상으로 축제 장면 그리기");
                activities.add("친구나 가족과 함께 하는 단체 그리기 활동");
                activities.add("새로운 그리기 기법이나 재료 도전하기");
            }
            case "SADNESS" -> {
                activities.add("따뜻한 색갈로 자연 풍경 그리기");
                activities.add("좋았던 추억이나 꿈을 그림으로 표현하기");
                activities.add("부드러운 파스텔 키으로 추상화 그리기");
            }
            case "ANGER" -> {
                activities.add("대형 캠버스에 다이내믹한 선 그리기");
                activities.add("감정을 색깔로 표현하는 추상화 작업");
                activities.add("점토나 조각 등 입체적 작업 도전");
            }
            case "ANXIETY" -> {
                activities.add("반복적 패턴이나 만다라 그리기");
                activities.add("자연의 고요함을 주제로 한 그림 그리기");
                activities.add("단순한 도형이나 선으로 기본부터 시작하기");
            }
            case "PEACE" -> {
                activities.add("명상적 장면이나 고요한 풍경 그리기");
                activities.add("수채화로 투명하고 중첩된 색감 표현");
                activities.add("더 깊이 있는 주제나 철학적 사고 표현하기");
            }
        }
        
        // 케어 레벨에 따른 추가 추천
        if (careStatus.getLevel().equals("즉시_관리_필요")) {
            activities.add("전문가와 함께 하는 그룹 미술치료 참여");
            activities.add("안전한 환경에서 진행하는 자유로운 표현 시간");
        }
        
        return activities;
    }
    
    private String generateNextDrawingThemeDescription(String theme, EmotionalState emotionalState) {
        if (theme == null || theme.trim().isEmpty()) {
            theme = "자유로운 표현";
        }
        
        StringBuilder description = new StringBuilder();
        description.append("다음 그림 주제로 '").append(theme).append("을(를) 제안드립니다. ");
        
        // 주제에 따른 상세 안내
        if (theme.contains("희망") || theme.contains("미래")) {
            description.append("밝은 색상과 상승하는 이미지로 긍정적인 에너지를 표현해보세요.");
        } else if (theme.contains("자연") || theme.contains("풍경")) {
            description.append("자연의 아름다움을 통해 내면의 평안을 찾아보세요.");
        } else if (theme.contains("가족") || theme.contains("친구")) {
            description.append("소중한 사람들과의 관계를 따뜻하게 표현해보세요.");
        } else {
            description.append("자신만의 독특한 시각과 감성으로 자유롭게 표현해보세요.");
        }
        
        // 현재 감정 상태에 따른 추가 안내
        switch (emotionalState.getPrimaryEmotion()) {
            case "SADNESS" -> description.append(" 지금 시기에는 따뜻한 색감과 부드러운 선을 사용하는 것이 도움이 될 것 같아요.");
            case "ANXIETY" -> description.append(" 마음이 진정될 수 있도록 규칙적인 패턴이나 대칭적 구성을 시도해보세요.");
            case "ANGER" -> description.append(" 강한 감정을 건설적으로 표현할 수 있도록 다이내믹한 선과 대비를 활용해보세요.");
            case "HAPPINESS" -> description.append(" 지금의 긍정적 에너지를 마음께 표현하며, 새로운 기법에도 도전해보세요.");
        }
        
        return description.toString();
    }

    public CoachingResponse getPersonalizedGuidance(String userId) {
        log.info("Generating personalized guidance for user: {}", userId);

        UserPsychologicalProfile profile = profileService.getUserProfile(userId);
        EmotionalState latestState = profile.getLatestEmotionalState();

        if (latestState == null) {
            return createWelcomeResponse(userId);
        }

        // 기본 분석 및 결정
        AgentDecision decision = agentService.makeAutonomousDecision(userId, latestState);
        String personalizedMessage = agentService.generatePersonalizedMessage(userId, decision, latestState);
        List<String> recommendations = profileService.getRecommendations(userId);
        
        // 케어 상태 평가
        CareStatus careStatus = careStatusService.assessCareStatus(userId, latestState, profile);
        
        // 추가 정보 생성
        String aiAdvice = generateAIAdvice(latestState, careStatus, null);
        List<String> recommendedActivities = generateRecommendedActivities(latestState, careStatus);
        String nextThemeDescription = generateNextDrawingThemeDescription(decision.getNextDrawingTheme(), latestState);

        return new CoachingResponse(
                latestState,
                decision,
                personalizedMessage,
                recommendations,
                decision.getNextDrawingTheme(),
                decision.isRequiresImmediate(),
                System.currentTimeMillis(),
                careStatus,
                null,  // 이미지 분석 결과는 없음
                null,  // 심리학적 해석도 없음
                aiAdvice,
                recommendedActivities,
                nextThemeDescription
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
                System.currentTimeMillis(),
                new CareStatus("양호함", "새로운 사용자를 위한 기본 케어 상태", 2, "새로운 사용자", "그림을 통해 자신을 표현해보세요"),
                null,  // 이미지 분석 결과 없음
                null,  // 심리학적 해석 없음
                "그림을 통한 여정을 시작하는 것을 환영합니다. 어떤 색깔이든 어떤 형태든 자유롭게 표현해보세요.",
                List.of("기본적인 도형 그리기로 시작하기", "좋아하는 색깔 사용해보기", "간단한 패턴이나 선 그리기"),
                "첫 번째 그림에서는 특별한 규칙 없이 마음가는 대로 그려보세요. 지금 이 순간의 느낌을 색깔과 선으로 표현해보는 것만으로도 충분합니다. 완벽할 필요는 전혀 없어요!"
        );
    }
}
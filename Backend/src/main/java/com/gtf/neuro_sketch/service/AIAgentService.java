package com.gtf.neuro_sketch.service;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.gtf.neuro_sketch.model.AgentDecision;
import com.gtf.neuro_sketch.model.EmotionalState;
import com.gtf.neuro_sketch.model.UserPsychologicalProfile;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Arrays;
import java.util.List;

@Service
@RequiredArgsConstructor
@Slf4j
public class AIAgentService {

    private final SolarAIService solarAIService;
    private final PsychologicalProfileService profileService;
    private final ObjectMapper objectMapper;

    public AgentDecision makeAutonomousDecision(String userId, EmotionalState currentState) {
        UserPsychologicalProfile profile = profileService.getUserProfile(userId);

        String decisionPrompt = buildDecisionPrompt(currentState, profile);
        String aiResponse = solarAIService.generateResponse(decisionPrompt);
        log.info("Solar AI Service response: {}", aiResponse);

        AgentDecision decision = parseAgentDecision(aiResponse);

        if (profileService.isInterventionNeeded(userId)) {
            decision.setRequiresImmediate(true);
            decision.setUrgencyLevel(Math.max(decision.getUrgencyLevel(), 8));
        }

        return decision;
    }

    private String buildDecisionPrompt(EmotionalState currentState, UserPsychologicalProfile profile) {
        StringBuilder contextInfo = new StringBuilder();

        contextInfo.append("현재 감정 상태: ").append(currentState.getPrimaryEmotion())
                .append(" (강도: ").append(currentState.getIntensity()).append("/10)\n");

        contextInfo.append("분석 근거: ").append(currentState.getReasoning()).append("\n");

        contextInfo.append("사용자 회복력: ").append(profile.getResilience()).append("/10\n");

        if (!profile.getEmotionalHistory().isEmpty()) {
            contextInfo.append("최근 감정 패턴: ");
            profile.getEmotionalPatterns().forEach((key, value) ->
                    contextInfo.append(key).append(": ").append(String.format("%.2f", value)).append(", ")
            );
            contextInfo.append("\n");
        }

        contextInfo.append("현재 시간: ").append(LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm"))).append("\n");

        return String.format("""
                당신은 심리 상담 전문가이자 자율적 AI Agent입니다. 
                다음 사용자 정보를 분석하여 최적의 개입 방식을 결정하고 JSON 형태로 답변해주세요:
                
                %s
                
                다음 형식으로 의사결정 결과를 반환하세요:
                {
                    "decisionType": "ENCOURAGE/REDIRECT/SUPPORT/CHALLENGE/MONITOR/INTERVENTION 중 하나",
                    "reasoning": "이 결정을 내린 구체적인 이유와 근거",
                    "urgencyLevel": "1-10 사이의 개입 긴급도",
                    "recommendedActions": ["구체적인 행동 제안 배열"],
                    "nextDrawingTheme": "다음에 그릴 것을 제안하는 주제",
                    "requiresImmediate": "즉시 개입이 필요한지 여부 (true/false)"
                }
                
                의사결정 기준:
                - ENCOURAGE: 긍정적 상태 유지 및 강화
                - REDIRECT: 부정적 감정에서 건설적 방향으로 전환
                - SUPPORT: 어려운 상황에서 지지와 공감 제공
                - CHALLENGE: 성장을 위한 새로운 도전 제시
                - MONITOR: 상황 지켜보며 추가 정보 수집 필요
                - INTERVENTION: 즉시 전문적 개입 필요
                
                반드시 ```json ```으로 감싸지 말고 JSON 형식으로 반환하세요.
                """, contextInfo.toString());
    }

    private AgentDecision parseAgentDecision(String aiResponse) {
        try {
            AgentDecisionResult result = objectMapper.readValue(aiResponse, AgentDecisionResult.class);

            AgentDecision decision = new AgentDecision();
            decision.setDecisionType(result.getDecisionType());
            decision.setReasoning(result.getReasoning());
            decision.setUrgencyLevel(result.getUrgencyLevel());
            decision.setRecommendedActions(result.getRecommendedActions());
            decision.setNextDrawingTheme(result.getNextDrawingTheme());
            decision.setRequiresImmediate(result.isRequiresImmediate());
            decision.setTimestamp(System.currentTimeMillis());

            return decision;
        } catch (JsonProcessingException e) {
            log.error("Failed to parse agent decision result", e);
            return createDefaultDecision();
        }
    }

    private AgentDecision createDefaultDecision() {
        return new AgentDecision(
                "MONITOR",
                "분석 실패로 인한 기본 모니터링 모드",
                5,
                Arrays.asList("현재 상태를 관찰합니다", "추가 정보가 필요합니다"),
                "자유로운 주제로 그림을 그려보세요",
                false,
                System.currentTimeMillis()
        );
    }

    public String generatePersonalizedMessage(String userId, AgentDecision decision, EmotionalState emotionalState) {
        UserPsychologicalProfile profile = profileService.getUserProfile(userId);

        String messagePrompt = buildMessagePrompt(decision, emotionalState, profile);
        return solarAIService.generateResponse(messagePrompt);
    }

    private String buildMessagePrompt(AgentDecision decision, EmotionalState emotionalState, UserPsychologicalProfile profile) {
        return String.format("""
                        따뜻하고 공감적인 심리 코치로서 사용자에게 개인화된 메시지를 작성해주세요.
                        
                        현재 상황:
                        - 감정 상태: %s (강도: %d/10)
                        - Agent 결정: %s
                        - 개입 이유: %s
                        - 사용자 회복력: %d/10
                        
                        메시지 작성 가이드라인:
                        1. 따뜻하고 공감적인 톤으로 작성
                        2. 사용자의 감정을 인정하고 수용
                        3. 구체적이고 실행 가능한 조언 포함
                        4. 희망적이고 격려하는 메시지로 마무리
                        5. 길이는 2-4문장으로 간결하게
                        
                        JSON이나 다른 형식 없이 순수한 메시지 내용만 반환해주세요.
                        """,
                emotionalState.getPrimaryEmotion(),
                emotionalState.getIntensity(),
                decision.getDecisionType(),
                decision.getReasoning(),
                profile.getResilience()
        );
    }

    private static class AgentDecisionResult {
        public String decisionType;
        public String reasoning;
        public int urgencyLevel;
        public List<String> recommendedActions;
        public String nextDrawingTheme;
        public boolean requiresImmediate;

        public String getDecisionType() {
            return decisionType;
        }

        public String getReasoning() {
            return reasoning;
        }

        public int getUrgencyLevel() {
            return urgencyLevel;
        }

        public List<String> getRecommendedActions() {
            return recommendedActions;
        }

        public String getNextDrawingTheme() {
            return nextDrawingTheme;
        }

        public boolean isRequiresImmediate() {
            return requiresImmediate;
        }
    }
}
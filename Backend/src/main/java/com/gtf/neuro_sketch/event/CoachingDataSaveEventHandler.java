package com.gtf.neuro_sketch.event;

import com.gtf.neuro_sketch.document.*;
import com.gtf.neuro_sketch.service.CoachingDataStorageService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.context.event.EventListener;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Component;

@Component
@RequiredArgsConstructor
@Slf4j
public class CoachingDataSaveEventHandler {

    private final CoachingDataStorageService storageService;

    @Async
    @EventListener
    public void handleCoachingDataSaveEvent(CoachingDataSaveEvent event) {
        try {
            log.info("비동기 저장 시작 - 사용자: {}", event.getUserId());

            // 감정 상태 저장
            if (event.getEmotionalState() != null) {
                EmotionalStateDocument emotionalStateDoc = EmotionalStateDocument.from(event.getEmotionalState(), event.getUserId());
                storageService.saveEmotionalState(emotionalStateDoc);
            }

            // 이미지 분석 결과 저장
            if (event.getImageAnalysisResult() != null) {
                ImageAnalysisDocument imageAnalysisDoc = ImageAnalysisDocument.from(event.getImageAnalysisResult(), event.getUserId());
                storageService.saveImageAnalysis(imageAnalysisDoc);
            }

            // 심리학적 해석 저장
            if (event.getPsychologicalInterpretation() != null) {
                PsychologicalInterpretationDocument psychDoc = PsychologicalInterpretationDocument.from(event.getPsychologicalInterpretation(), event.getUserId());
                storageService.savePsychologicalInterpretation(psychDoc);
            }

            // 에이전트 결정 저장
            if (event.getAgentDecision() != null) {
                AgentDecisionDocument agentDoc = AgentDecisionDocument.from(event.getAgentDecision(), event.getUserId());
                storageService.saveAgentDecision(agentDoc);
            }

            // 케어 상태 저장
            if (event.getCareStatus() != null) {
                CareStatusDocument careDoc = CareStatusDocument.from(event.getCareStatus(), event.getUserId());
                storageService.saveCareStatus(careDoc);
            }

            // 통합 코칭 세션 저장
            CoachingSessionDocument sessionDoc = new CoachingSessionDocument();
            sessionDoc.setUserId(event.getUserId());
            sessionDoc.setPersonalizedMessage(event.getPersonalizedMessage());
            sessionDoc.setRecommendations(event.getRecommendations());
            sessionDoc.setAiAdvice(event.getAiAdvice());
            sessionDoc.setRecommendedActivities(event.getRecommendedActivities());
            sessionDoc.setNextThemeDescription(event.getNextThemeDescription());
            sessionDoc.setTimestamp(event.getTimestamp());

            storageService.saveCoachingSession(sessionDoc);

            log.info("비동기 저장 완료 - 사용자: {}", event.getUserId());
        } catch (Exception e) {
            log.error("비동기 저장 중 오류 발생 - 사용자: {}", event.getUserId(), e);
        }
    }
}
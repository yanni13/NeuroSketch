package com.gtf.neuro_sketch.service;

import com.gtf.neuro_sketch.document.*;
import com.gtf.neuro_sketch.repository.mongo.*;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
@Slf4j
public class CoachingDataStorageService {

    private final EmotionalStateRepository emotionalStateRepository;
    private final ImageAnalysisRepository imageAnalysisRepository;
    private final PsychologicalInterpretationRepository psychInterpretationRepository;
    private final AgentDecisionRepository agentDecisionRepository;
    private final CareStatusRepository careStatusRepository;
    private final CoachingSessionRepository coachingSessionRepository;

    public void saveEmotionalState(EmotionalStateDocument document) {
        try {
            emotionalStateRepository.save(document);
            log.debug("감정 상태 저장 완료 - 사용자: {}", document.getUserId());
        } catch (Exception e) {
            log.error("감정 상태 저장 실패 - 사용자: {}", document.getUserId(), e);
        }
    }

    public void saveImageAnalysis(ImageAnalysisDocument document) {
        try {
            imageAnalysisRepository.save(document);
            log.debug("이미지 분석 결과 저장 완료 - 사용자: {}", document.getUserId());
        } catch (Exception e) {
            log.error("이미지 분석 결과 저장 실패 - 사용자: {}", document.getUserId(), e);
        }
    }

    public void savePsychologicalInterpretation(PsychologicalInterpretationDocument document) {
        try {
            psychInterpretationRepository.save(document);
            log.debug("심리학적 해석 저장 완료 - 사용자: {}", document.getUserId());
        } catch (Exception e) {
            log.error("심리학적 해석 저장 실패 - 사용자: {}", document.getUserId(), e);
        }
    }

    public void saveAgentDecision(AgentDecisionDocument document) {
        try {
            agentDecisionRepository.save(document);
            log.debug("에이전트 결정 저장 완료 - 사용자: {}", document.getUserId());
        } catch (Exception e) {
            log.error("에이전트 결정 저장 실패 - 사용자: {}", document.getUserId(), e);
        }
    }

    public void saveCareStatus(CareStatusDocument document) {
        try {
            careStatusRepository.save(document);
            log.debug("케어 상태 저장 완료 - 사용자: {}", document.getUserId());
        } catch (Exception e) {
            log.error("케어 상태 저장 실패 - 사용자: {}", document.getUserId(), e);
        }
    }

    public void saveCoachingSession(CoachingSessionDocument document) {
        try {
            coachingSessionRepository.save(document);
            log.debug("코칭 세션 저장 완료 - 사용자: {}", document.getUserId());
        } catch (Exception e) {
            log.error("코칭 세션 저장 실패 - 사용자: {}", document.getUserId(), e);
        }
    }

    public List<EmotionalStateDocument> getUserEmotionalStates(String userId) {
        return emotionalStateRepository.findByUserIdOrderByTimestampDesc(userId);
    }

    public List<ImageAnalysisDocument> getUserImageAnalyses(String userId) {
        return imageAnalysisRepository.findByUserIdOrderByCreatedAtDesc(userId);
    }

    public List<PsychologicalInterpretationDocument> getUserPsychologicalInterpretations(String userId) {
        return psychInterpretationRepository.findByUserIdOrderByCreatedAtDesc(userId);
    }

    public List<AgentDecisionDocument> getUserAgentDecisions(String userId) {
        return agentDecisionRepository.findByUserIdOrderByDecisionTimestampDesc(userId);
    }

    public List<CareStatusDocument> getUserCareStatuses(String userId) {
        return careStatusRepository.findByUserIdOrderByAssessmentTimestampDesc(userId);
    }

    public List<CoachingSessionDocument> getUserCoachingSessions(String userId) {
        return coachingSessionRepository.findByUserIdOrderByTimestampDesc(userId);
    }
}
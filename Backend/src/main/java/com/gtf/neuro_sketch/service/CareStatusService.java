package com.gtf.neuro_sketch.service;

import com.gtf.neuro_sketch.model.CareStatus;
import com.gtf.neuro_sketch.model.EmotionalState;
import com.gtf.neuro_sketch.model.UserPsychologicalProfile;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.util.Arrays;
import java.util.List;

@Service
@RequiredArgsConstructor
@Slf4j
public class CareStatusService {

    public CareStatus assessCareStatus(String userId, EmotionalState currentEmotion, UserPsychologicalProfile profile) {
        log.info("Assessing care status for user: {} with emotion: {}", userId, currentEmotion.getPrimaryEmotion());

        // 긴급도 점수 계산
        int urgencyScore = calculateUrgencyScore(currentEmotion, profile);
        
        // 케어 레벨 결정
        String careLevel = determineCareLevel(urgencyScore, currentEmotion, profile);
        
        // 상세 설명 생성
        String description = generateCareDescription(careLevel, currentEmotion, profile);
        
        // 판단 근거 생성
        String reason = generateCareReason(urgencyScore, currentEmotion, profile);
        
        // 권장 조치사항 생성
        String recommendedAction = generateRecommendedAction(careLevel, currentEmotion);

        CareStatus careStatus = new CareStatus(
            careLevel,
            description,
            urgencyScore,
            reason,
            recommendedAction
        );

        log.info("Care status assessed - Level: {}, Urgency: {}", careLevel, urgencyScore);
        return careStatus;
    }

    private int calculateUrgencyScore(EmotionalState emotion, UserPsychologicalProfile profile) {
        int baseScore = 3; // 기본 점수
        
        // 감정 강도에 따른 점수
        if (emotion.getIntensity() >= 8) {
            baseScore += 3;
        } else if (emotion.getIntensity() >= 6) {
            baseScore += 2;
        } else if (emotion.getIntensity() >= 4) {
            baseScore += 1;
        }
        
        // 부정적 감정에 대한 추가 점수
        List<String> negativeEmotions = Arrays.asList("SADNESS", "ANGER", "ANXIETY");
        if (negativeEmotions.contains(emotion.getPrimaryEmotion())) {
            baseScore += 2;
        }
        
        // 회복력이 낮은 경우 추가 점수
        if (profile.getResilience() <= 3) {
            baseScore += 2;
        }
        
        // 최근 패턴을 고려한 조정
        if (profile.getEmotionalPatterns().containsKey("emotional_volatility")) {
            Double volatility = profile.getEmotionalPatterns().get("emotional_volatility");
            if (volatility != null && volatility > 0.7) {
                baseScore += 1;
            }
        }
        
        return Math.min(10, Math.max(1, baseScore)); // 1-10 범위로 제한
    }

    private String determineCareLevel(int urgencyScore, EmotionalState emotion, UserPsychologicalProfile profile) {
        if (urgencyScore >= 8) {
            return "즉시_관리_필요";
        } else if (urgencyScore >= 6) {
            return "주의_관찰";
        } else if (urgencyScore >= 4) {
            return "안정적";
        } else {
            return "양호함";
        }
    }

    private String generateCareDescription(String careLevel, EmotionalState emotion, UserPsychologicalProfile profile) {
        return switch (careLevel) {
            case "즉시_관리_필요" -> String.format(
                "현재 %s 감정이 매우 강하게 나타나고 있어 즉시 관리가 필요한 상태입니다. " +
                "감정의 강도가 %d로 높고, 안정감을 찾기 위한 적극적인 개입이 권장됩니다.",
                translateEmotion(emotion.getPrimaryEmotion()), emotion.getIntensity()
            );
            case "주의_관찰" -> String.format(
                "%s 감정 상태를 주의 깊게 관찰해야 하는 단계입니다. " +
                "감정 강도 %d로 관리가 필요하며, 예방적 접근을 통해 안정화를 도모해야 합니다.",
                translateEmotion(emotion.getPrimaryEmotion()), emotion.getIntensity()
            );
            case "안정적" -> String.format(
                "%s 감정 상태로 전반적으로 안정적인 상태입니다. " +
                "현재의 긍정적 상태를 유지하며 지속적인 성장을 위한 활동이 도움될 것입니다.",
                translateEmotion(emotion.getPrimaryEmotion())
            );
            case "양호함" -> String.format(
                "%s 감정으로 매우 양호한 심리 상태를 보이고 있습니다. " +
                "현재의 긍정적 에너지를 활용하여 새로운 도전이나 창작 활동을 시도해보시기 바랍니다.",
                translateEmotion(emotion.getPrimaryEmotion())
            );
            default -> "현재 심리 상태를 종합적으로 관찰하고 있습니다.";
        };
    }

    private String generateCareReason(int urgencyScore, EmotionalState emotion, UserPsychologicalProfile profile) {
        StringBuilder reason = new StringBuilder();
        
        reason.append("긴급도 점수 ").append(urgencyScore).append("점 기준: ");
        
        if (emotion.getIntensity() >= 7) {
            reason.append("높은 감정 강도(").append(emotion.getIntensity()).append("), ");
        }
        
        List<String> negativeEmotions = Arrays.asList("SADNESS", "ANGER", "ANXIETY");
        if (negativeEmotions.contains(emotion.getPrimaryEmotion())) {
            reason.append("부정적 감정 상태, ");
        }
        
        if (profile.getResilience() <= 3) {
            reason.append("낮은 회복력 지수(").append(profile.getResilience()).append("), ");
        }
        
        if (profile.getEmotionalPatterns().containsKey("emotional_volatility")) {
            Double volatility = profile.getEmotionalPatterns().get("emotional_volatility");
            if (volatility != null && volatility > 0.7) {
                reason.append("높은 감정 변동성, ");
            }
        }
        
        // 마지막 쉼표 제거
        String result = reason.toString();
        if (result.endsWith(", ")) {
            result = result.substring(0, result.length() - 2);
        }
        
        return result;
    }

    private String generateRecommendedAction(String careLevel, EmotionalState emotion) {
        return switch (careLevel) {
            case "즉시_관리_필요" -> switch (emotion.getPrimaryEmotion()) {
                case "ANXIETY" -> "심호흡이나 점진적 근육 이완법을 통해 즉시 안정을 취하시고, 필요시 전문가의 도움을 받으시기 바랍니다.";
                case "SADNESS" -> "신뢰할 수 있는 사람과의 대화나 따뜻한 환경에서의 휴식을 통해 감정을 달래시기 바랍니다.";
                case "ANGER" -> "안전한 공간에서 신체 활동이나 창작 활동을 통해 감정을 건설적으로 표출하시기 바랍니다.";
                default -> "현재 상태를 안정화하기 위한 즉시 조치가 필요합니다. 편안한 환경에서 휴식을 취하시기 바랍니다.";
            };
            case "주의_관찰" -> "일정한 루틴을 유지하면서 감정 변화를 관찰하고, 스트레스 관리 기법을 실천하시기 바랍니다.";
            case "안정적" -> "현재의 안정적 상태를 유지하며, 취미 활동이나 새로운 관심사 탐색을 통해 성장을 도모하시기 바랍니다.";
            case "양호함" -> "현재의 긍정적 에너지를 활용하여 새로운 목표 설정이나 창의적 활동에 도전해보시기 바랍니다.";
            default -> "지속적인 자기 관찰과 건강한 생활 습관을 유지하시기 바랍니다.";
        };
    }

    private String translateEmotion(String emotion) {
        return switch (emotion) {
            case "HAPPINESS" -> "행복";
            case "SADNESS" -> "슬픔";
            case "ANGER" -> "분노";
            case "ANXIETY" -> "불안";
            case "PEACE" -> "평온";
            default -> "알 수 없는 감정";
        };
    }
}
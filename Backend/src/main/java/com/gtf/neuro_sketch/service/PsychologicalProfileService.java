package com.gtf.neuro_sketch.service;

import com.gtf.neuro_sketch.model.EmotionalState;
import com.gtf.neuro_sketch.model.UserPsychologicalProfile;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.time.ZoneId;
import java.util.*;
import java.util.concurrent.ConcurrentHashMap;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
@Slf4j
public class PsychologicalProfileService {

    private final Map<String, UserPsychologicalProfile> userProfiles = new ConcurrentHashMap<>();

    public UserPsychologicalProfile getUserProfile(String userId) {
        return userProfiles.computeIfAbsent(userId, UserPsychologicalProfile::new);
    }

    public void updateUserProfile(String userId, EmotionalState emotionalState) {
        UserPsychologicalProfile profile = getUserProfile(userId);
        profile.addEmotionalState(emotionalState);
        analyzeEmotionalPatterns(profile);
        updatePersonalityTraits(profile);
        assessRisk(profile);
    }

    private void analyzeEmotionalPatterns(UserPsychologicalProfile profile) {
        List<EmotionalState> recentStates = getRecentStates(profile.getEmotionalHistory(), 7);

        Map<String, Double> patterns = new HashMap<>();

        Map<String, Long> emotionCounts = recentStates.stream()
                .collect(Collectors.groupingBy(
                        EmotionalState::getPrimaryEmotion,
                        Collectors.counting()
                ));

        double totalStates = recentStates.size();
        emotionCounts.forEach((emotion, count) -> {
            patterns.put(emotion + "_frequency", count / totalStates);
        });

        double averageIntensity = recentStates.stream()
                .mapToInt(EmotionalState::getIntensity)
                .average()
                .orElse(5.0);
        patterns.put("average_intensity", averageIntensity);

        double volatility = calculateEmotionalVolatility(recentStates);
        patterns.put("emotional_volatility", volatility);

        profile.setEmotionalPatterns(patterns);
    }

    private void updatePersonalityTraits(UserPsychologicalProfile profile) {
        Map<String, Object> traits = new HashMap<>();

        Double volatility = profile.getEmotionalPatterns().get("emotional_volatility");
        if (volatility != null) {
            if (volatility < 0.3) {
                traits.put("stability", "high");
            } else if (volatility > 0.7) {
                traits.put("stability", "low");
            } else {
                traits.put("stability", "moderate");
            }
        }

        Double sadnessFreq = profile.getEmotionalPatterns().get("SADNESS_frequency");
        Double anxietyFreq = profile.getEmotionalPatterns().get("ANXIETY_frequency");

        if (sadnessFreq != null && anxietyFreq != null) {
            double negativeRatio = sadnessFreq + anxietyFreq;
            traits.put("optimism_level", negativeRatio < 0.3 ? "high" : negativeRatio > 0.6 ? "low" : "moderate");
        }

        profile.setPersonalityTraits(traits);
    }

    private void assessRisk(UserPsychologicalProfile profile) {
        List<EmotionalState> recentStates = getRecentStates(profile.getEmotionalHistory(), 3);

        long negativeCount = recentStates.stream()
                .filter(state -> Arrays.asList("SADNESS", "ANGER", "ANXIETY").contains(state.getPrimaryEmotion()))
                .count();

        double averageIntensity = recentStates.stream()
                .filter(state -> Arrays.asList("SADNESS", "ANGER", "ANXIETY").contains(state.getPrimaryEmotion()))
                .mapToInt(EmotionalState::getIntensity)
                .average()
                .orElse(0.0);

        int resilience = profile.getResilience();

        if (negativeCount >= 2 && averageIntensity >= 7) {
            resilience = Math.max(1, resilience - 1);
        } else if (negativeCount == 0 || averageIntensity <= 3) {
            resilience = Math.min(10, resilience + 1);
        }

        profile.setResilience(resilience);
    }

    private double calculateEmotionalVolatility(List<EmotionalState> states) {
        if (states.size() < 2) return 0.0;

        List<Integer> intensities = states.stream()
                .map(EmotionalState::getIntensity)
                .toList();

        double mean = intensities.stream().mapToInt(Integer::intValue).average().orElse(0.0);

        double variance = intensities.stream()
                .mapToDouble(intensity -> Math.pow(intensity - mean, 2))
                .average()
                .orElse(0.0);

        return Math.sqrt(variance) / 10.0;
    }

    private List<EmotionalState> getRecentStates(List<EmotionalState> allStates, int days) {
        long cutoffTime = LocalDateTime.now().minusDays(days)
                .atZone(ZoneId.systemDefault())
                .toInstant()
                .toEpochMilli();

        return allStates.stream()
                .filter(state -> state.getTimestamp() > cutoffTime)
                .collect(Collectors.toList());
    }

    public boolean isInterventionNeeded(String userId) {
        UserPsychologicalProfile profile = getUserProfile(userId);

        if (profile.getResilience() <= 3) {
            return true;
        }

        List<EmotionalState> recentStates = getRecentStates(profile.getEmotionalHistory(), 2);

        long criticalCount = recentStates.stream()
                .filter(state -> Arrays.asList("SADNESS", "ANGER", "ANXIETY").contains(state.getPrimaryEmotion())
                        && state.getIntensity() >= 8)
                .count();

        return criticalCount >= 2;
    }

    public List<String> getRecommendations(String userId) {
        UserPsychologicalProfile profile = getUserProfile(userId);
        List<String> recommendations = new ArrayList<>();

        EmotionalState latestState = profile.getLatestEmotionalState();
        if (latestState == null) {
            recommendations.add("그림을 통해 현재 감정을 표현해보세요");
            return recommendations;
        }

        switch (latestState.getPrimaryEmotion()) {
            case "ANXIETY" -> {
                if (latestState.getIntensity() >= 7) {
                    recommendations.add("심호흡이나 명상을 통해 마음을 진정시켜보세요");
                    recommendations.add("차분한 색상으로 평온한 풍경을 그려보는 것은 어떨까요?");
                }
            }
            case "SADNESS" -> {
                if (latestState.getIntensity() >= 7) {
                    recommendations.add("따뜻한 색상을 사용해서 희망적인 이미지를 그려보세요");
                    recommendations.add("자연이나 밝은 장면을 그려 기분을 전환해보세요");
                }
            }
            case "ANGER" -> {
                if (latestState.getIntensity() >= 7) {
                    recommendations.add("감정을 건설적으로 표현할 수 있는 그림을 그려보세요");
                    recommendations.add("차가운 색조로 평온한 이미지를 그려 마음을 가라앉혀보세요");
                }
            }
            case "HAPPINESS" -> {
                recommendations.add("긍정적인 에너지를 유지하며 더 창의적인 작품에 도전해보세요");
            }
            default -> {
                recommendations.add("현재 기분을 더 깊이 탐구해보는 그림을 그려보세요");
            }
        }

        return recommendations;
    }
}
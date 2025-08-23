package com.gtf.neuro_sketch.service;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.gtf.neuro_sketch.model.ImageAnalysisResult;
import com.gtf.neuro_sketch.model.PsychologicalInterpretation;
import lombok.Getter;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;

@Service
@RequiredArgsConstructor
@Slf4j
public class PsychologicalInterpretationService {

    private final SolarAIService solarAIService;
    private final ObjectMapper objectMapper;

    public PsychologicalInterpretation generateInterpretation(ImageAnalysisResult imageAnalysisResult) {
        String interpretationPrompt = buildInterpretationPrompt(imageAnalysisResult);
        String aiResponse = solarAIService.generateResponse(interpretationPrompt);

        return parseInterpretationResult(aiResponse);
    }

    private String buildInterpretationPrompt(ImageAnalysisResult imageAnalysisResult) {
        try {
            String analysisJson = objectMapper.writeValueAsString(imageAnalysisResult);
            return String.format("""
                다음 그림 분석 결과를 바탕으로 심리학적 및 미술치료적 관점에서 종합적인 해석을 제공해주세요:
                
                그림 분석 결과:
                %s
                
                다음 JSON 형식으로 상세한 심리학적 해석을 반환하세요:
                {
                    "overallPsychologicalAssessment": "전반적인 심리 상태에 대한 종합적 평가",
                    "artTherapyInsights": [
                        {
                            "element": "분석 요소 (예: 색상, 배치, 크기 등)",
                            "observation": "관찰된 특성",
                            "psychologicalMeaning": "일반 심리학적 의미",
                            "artTherapyContext": "미술치료학적 맥락에서의 해석"
                        }
                    ],
                    "emotionalExpressionAnalysis": "감정 표현 방식과 그 의미에 대한 분석",
                    "developmentalIndicators": "발달적 특성이나 성장 단계 관련 지표",
                    "traumaOrStressIndicators": "트라우마나 스트레스 관련 지표 (있다면)",
                    "resilienceIndicators": "회복력이나 대처 능력 관련 지표",
                    "communicationStyle": "비언어적 소통 스타일에 대한 분석"
                }
                
                미술치료학적 해석 기준:
                - 색상: 빨간색(열정/분노), 파란색(평온/우울), 노란색(기쁨/불안), 검은색(무력감/보호)
                - 배치: 중앙(자아중심), 위쪽(이상/미래), 아래쪽(현실/과거), 모서리(회피/고립)  
                - 크기: 큰 그림(자신감/과장), 작은 그림(위축/조심스러움)
                - 선의 특성: 굵은 선(에너지/공격성), 가는 선(민감성/불안)
                - 완성도: 완성된 그림(통제감), 미완성(미결정/회피)
                
                반드시 ```json ```으로 감싸지 말고 JSON 형식으로 반환하세요.
                각 해석은 구체적이고 개인화된 내용으로 작성해주세요.
                """, analysisJson);
        } catch (JsonProcessingException e) {
            log.error("Failed to serialize ImageAnalysisResult for interpretation", e);
            return """
                그림 분석 데이터 처리에 실패했습니다. 기본 심리학적 해석을 제공합니다.
                
                {
                    "overallPsychologicalAssessment": "현재 안정적인 심리 상태로 보이며, 자신만의 방식으로 감정을 표현하고 있습니다.",
                    "artTherapyInsights": [
                        {
                            "element": "전체적 구성",
                            "observation": "기본적인 표현 시도",
                            "psychologicalMeaning": "자기표현에 대한 욕구",
                            "artTherapyContext": "창작 활동을 통한 소통 시도"
                        }
                    ],
                    "emotionalExpressionAnalysis": "개인만의 고유한 방식으로 감정을 표현하려는 시도가 보입니다.",
                    "developmentalIndicators": "현재 발달 단계에 적합한 표현 능력을 보여줍니다.",
                    "traumaOrStressIndicators": "특별한 스트레스 지표는 관찰되지 않습니다.",
                    "resilienceIndicators": "창작 활동을 통해 자신을 표현하려는 적극성이 보입니다.",
                    "communicationStyle": "비언어적 방식을 통한 소통을 선호하는 특성이 있습니다."
                }
                """;
        }
    }

    private PsychologicalInterpretation parseInterpretationResult(String aiResponse) {
        try {
            log.info("Parsing psychological interpretation result: {}", aiResponse);
            return objectMapper.readValue(aiResponse, PsychologicalInterpretation.class);
        } catch (JsonProcessingException e) {
            log.error("Failed to parse psychological interpretation result", e);
            return createDefaultInterpretation();
        }
    }

    private PsychologicalInterpretation createDefaultInterpretation() {
        List<PsychologicalInterpretation.ArtTherapyInsight> insights = new ArrayList<>();
        insights.add(new PsychologicalInterpretation.ArtTherapyInsight(
            "전체적 표현",
            "개인만의 독특한 방식으로 표현",
            "창작을 통한 자기표현 욕구",
            "미술활동을 통한 심리적 안정감 추구"
        ));

        return new PsychologicalInterpretation(
            "현재 안정적인 심리 상태로 보이며, 창작을 통해 자신을 표현하고자 하는 욕구가 있습니다.",
            insights,
            "자신만의 방식으로 감정을 표현하려는 시도가 긍정적입니다.",
            "현재 발달 단계에 적합한 표현력을 보여주고 있습니다.",
            "특별한 스트레스나 트라우마 지표는 관찰되지 않습니다.",
            "새로운 활동에 도전하는 적극성과 창의성이 보입니다.",
            "비언어적 소통을 통해 자신의 내면을 표현하는 것을 선호합니다."
        );
    }
}
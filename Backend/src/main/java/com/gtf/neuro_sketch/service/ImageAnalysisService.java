package com.gtf.neuro_sketch.service;

import com.fasterxml.jackson.annotation.JsonInclude;
import com.fasterxml.jackson.annotation.JsonProperty;
import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.Data;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.reactive.function.client.WebClient;

import java.io.IOException;
import java.util.Base64;
import java.util.List;
import java.util.Map;

@Slf4j
@Service
@RequiredArgsConstructor
public class ImageAnalysisService {

    private final WebClient.Builder webClientBuilder;
    private final ObjectMapper objectMapper;

    @Value("${openai.api.key}")
    private String apiKey;

    @Value("${openai.api.url}")
    private String apiUrl;

    public String analyzeImage(MultipartFile imageFile) throws IOException {
        String analysisPrompt = buildAnalysisPrompt();
        String base64Image = Base64.getEncoder().encodeToString(imageFile.getBytes());

        ChatGPTRequest request = new ChatGPTRequest();
        request.setModel("gpt-4o");

        ChatGPTMessage message = new ChatGPTMessage();
        message.setRole("user");
        message.setContent(List.of(
                new ContentPart("text", analysisPrompt),
                new ContentPart("image_url", Map.of("url", "data:image/png;base64," + base64Image))
        ));

        request.setMessages(List.of(message));

        WebClient webClient = webClientBuilder
                .baseUrl(apiUrl)
                .defaultHeader("Authorization", "Bearer " + apiKey)
                .defaultHeader("Content-Type", "application/json")
                .build();

        ChatGPTResponse response = webClient.post()
                .bodyValue(request)
                .retrieve()
                .bodyToMono(ChatGPTResponse.class)
                .block();
        log.info("ChatGPT response: {}", response);

        if (response != null) {
            return response.getChoices().getFirst().getMessage().getContent();
        }
        return "";
    }

    private String buildAnalysisPrompt() {
        return """
                이 그림을 객관적으로 분석하여 다음 정보를 JSON 형태로 정확하게 추출하세요:
                
                {
                    "detected_objects": ["실제로 그림에서 발견되는 객체들의 배열"],
                    "object_details": [
                        {
                            "object_name": "객체명",
                            "position": {
                                "location": "왼쪽상단/왼쪽중앙/왼쪽하단/중앙상단/중앙/중앙하단/오른쪽상단/오른쪽중앙/오른쪽하단",
                                "relative_size": "매우큰/큰/보통/작은/매우작은",
                                "prominence": "매우두드러짐/두드러짐/보통/미미함"
                            },
                            "visual_characteristics": {
                                "colors": ["해당 객체에 사용된 색상들"],
                                "line_style": "굵음/가늘음/일정하지않음/혼재",
                                "detail_level": "매우세밀/세밀/보통/단순/매우단순",
                                "completion_state": "완성/미완성/스케치수준"
                            },
                            "spatial_relationships": {
                                "connection_to_others": "연결됨/분리됨/겹침/인접함",
                                "interaction_type": "상호작용있음/독립적/부분적연결",
                                "relative_placement": "전경/중경/배경"
                            },
                            "symbolic_indicators": {
                                "traditional_meaning": "해당 객체의 일반적 상징적 의미",
                                "art_therapy_significance": "그림치료에서 이 객체가 시사하는 심리적 의미",
                                "contextual_meaning": "이 그림 내에서의 맥락적 의미",
                                "emotional_expression": "이 객체가 표현하는 감정적 뉘앙스"
                            }
                        }
                    ],
                    "colors_used": ["그림에서 사용된 주요 색상들"],
                    "dominant_colors": ["가장 많이 사용된 상위 3개 색상"],
                    "composition": {
                        "balance": "균형잡힌/왼쪽치우침/오른쪽치우침/위쪽치우침/아래쪽치우침/중앙집중/산만함 중 하나",
                        "space_usage": "전체적으로사용/한쪽에치우침/중앙집중/모서리집중 중 하나",
                        "hierarchy": "명확한주객구분/혼재된구성/균등한배치"
                    },
                    "drawing_characteristics": {
                        "line_quality": "굵음/가늘음/일정하지않음/혼재 중 하나",
                        "drawing_style": "세밀함/거침/단순함/혼재 중 하나",
                        "pressure_intensity": "강함/보통/약함/혼재 중 하나"
                    },
                    "emotional_indicators": {
                        "color_temperature": "따뜻함/차가움/중성 중 하나",
                        "brightness_level": "밝음/보통/어두움 중 하나",
                        "contrast_level": "높음/보통/낮음 중 하나"
                    },
                    "technical_analysis": {
                        "completion_level": "완성도높음/보통/미완성 중 하나",
                        "detail_level": "매우세밀/보통/단순 중 하나",
                        "organization": "체계적/보통/무질서 중 하나"
                    },
                    "overall_impression": {
                        "narrative_quality": "이야기성있음/정적장면/추상적표현",
                        "emotional_tone": "긍정적/중립적/부정적/혼재",
                        "energy_level": "활동적/평온함/침체된/역동적"
                    }
                }
                
                반드시 ```json ```으로 감싸지 말고 JSON 형식으로 반환하시고, 실제 그림에서 관찰되는 내용만을 객관적으로 기술하세요.
                각 객체별로 위치, 시각적 특성, 공간 관계, 상징적 의미를 포함한 세부 분석을 제공하세요.
                그림치료학적 관점에서 각 요소가 갖는 심리적 의미도 포함해주세요.
                """;
    }

    @Data
    static class ChatGPTRequest {
        private String model;
        private List<ChatGPTMessage> messages;
    }

    @Data
    static class ChatGPTMessage {
        private String role;
        private Object content;
    }

    @Data
    @JsonInclude(JsonInclude.Include.NON_NULL)
    static class ContentPart {
        private String type;
        private String text;
        @JsonProperty("image_url")
        private ImageUrl imageUrl;

        public ContentPart(String type, Object content) {
            this.type = type;
            if ("text".equals(type)) {
                this.text = (String) content;
            } else if ("image_url".equals(type)) {
                this.imageUrl = new ImageUrl((String) ((Map<?, ?>) content).get("url"));
            }
        }
    }

    @Data
    static class ImageUrl {
        private String url;

        public ImageUrl(String url) {
            this.url = url;
        }
    }

    @Data
    static class ChatGPTResponse {
        private List<Choice> choices;
    }

    @Data
    static class Choice {
        private ChatGPTResponseMessage message;
    }

    @Data
    static class ChatGPTResponseMessage {
        private String content;
    }
}
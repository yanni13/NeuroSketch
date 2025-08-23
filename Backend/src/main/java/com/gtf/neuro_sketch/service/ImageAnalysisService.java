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
                    "colors_used": ["그림에서 사용된 주요 색상들"],
                    "dominant_colors": ["가장 많이 사용된 상위 3개 색상"],
                    "composition": {
                        "balance": "균형잡힌/왼쪽치우침/오른쪽치우침/위쪽치우침/아래쪽치우침/중앙집중/산만함 중 하나",
                        "space_usage": "전체적으로사용/한쪽에치우침/중앙집중/모서리집중 중 하나"
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
                    }
                }
                
                반드시 JSON 형식만 반환하고, 실제 그림에서 관찰되는 내용만을 객관적으로 기술하세요.
                추측이나 해석을 포함하지 말고, 시각적으로 확인 가능한 사실만 기록하세요.
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
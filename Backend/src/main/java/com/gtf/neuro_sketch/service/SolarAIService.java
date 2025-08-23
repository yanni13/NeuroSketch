package com.gtf.neuro_sketch.service;

import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.Data;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.reactive.function.client.WebClient;

import java.util.List;

@Slf4j
@Service
@RequiredArgsConstructor
public class SolarAIService {

    private final WebClient.Builder webClientBuilder;
    private final ObjectMapper objectMapper;

    @Value("${solar.api.key}")
    private String apiKey;

    @Value("${solar.api.url:https://api.upstage.ai/v1/chat/completions}")
    private String apiUrl;

    public String generateResponse(String prompt) {
        SolarRequest request = new SolarRequest();
        request.setModel("solar-pro2");

        SolarMessage message = new SolarMessage();
        message.setRole("user");
        message.setContent(prompt);
        request.setMessages(List.of(message));

        WebClient webClient = webClientBuilder
                .baseUrl("")
                .defaultHeader("Authorization", "Bearer " + apiKey)
                .defaultHeader("Content-Type", "application/json")
                .build();

        SolarResponse response = webClient.post()
                .uri(apiUrl)
                .bodyValue(request)
                .retrieve()
                .bodyToMono(SolarResponse.class)
                .block();
        log.info("Solar response: {}", response);

        if (response != null && !response.getChoices().isEmpty()) {
            return response.getChoices().getFirst().getMessage().getContent();
        }
        return "";
    }

    @Data
    static class SolarRequest {
        private String model;
        private List<SolarMessage> messages;
        private boolean stream = false;
    }

    @Data
    static class SolarMessage {
        private String role;
        private String content;
    }

    @Data
    static class SolarResponse {
        private List<SolarChoice> choices;
    }

    @Data
    static class SolarChoice {
        private SolarResponseMessage message;
    }

    @Data
    static class SolarResponseMessage {
        private String content;
    }
}
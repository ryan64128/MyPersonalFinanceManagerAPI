package com.example.config;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import javax.annotation.PostConstruct;

@Component
public class ApiKeyLogger {

    @Value("${spring.openai.api-key}")
    private String apiKey;

    @PostConstruct
    public void logApiKey() {
        System.out.println("Configured OpenAI API Key: " + apiKey);
    }
}

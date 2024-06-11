package com.example.config;


import org.springframework.ai.openai.OpenAiAudioSpeechModel;
import org.springframework.ai.openai.OpenAiAudioTranscriptionModel;
import org.springframework.ai.openai.OpenAiChatModel;
import org.springframework.ai.openai.OpenAiEmbeddingModel;
import org.springframework.ai.openai.OpenAiImageModel;
import org.springframework.ai.openai.api.OpenAiApi;
import org.springframework.ai.openai.api.OpenAiAudioApi;
import org.springframework.ai.openai.api.OpenAiImageApi;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class OpenAiAutoConfiguration {

    @Value("${spring.openai.api-key}")
    private OpenAiApi apiKey;
    
    @Value("${spring.openai.api-key}")
    private OpenAiImageApi apiImageKey;
    
    @Value("${spring.openai.api-key}")
    private OpenAiAudioApi apiAudioKey;
    
    @Value("${spring.openai.api-key}")
    private OpenAiAudioApi apiSpeechKey;

    @Bean
    OpenAiChatModel openAiChatModel() {
        if (apiKey == null) {
            throw new IllegalArgumentException("OpenAI API key must be set");
        }
        return new OpenAiChatModel(apiKey);
    }
    
    @Bean
    OpenAiEmbeddingModel openAiEmbeddingModel() {
        System.out.println("Inside OpenAiAutoConfiguration - OpenAI API Key for Embedding Model: " + apiKey);
        if (apiKey == null) {
            throw new IllegalArgumentException("OpenAI API key must be set");
        }
        return new OpenAiEmbeddingModel(apiKey);
    }
    
    @Bean
    OpenAiImageModel openAiImageModel() {
        System.out.println("Inside OpenAiAutoConfiguration - OpenAI API Key for Image Model: " + apiImageKey);
        if (apiKey == null) {
            throw new IllegalArgumentException("OpenAI API key must be set");
        }
        return new OpenAiImageModel(apiImageKey);
    }
    
    @Bean
    OpenAiAudioTranscriptionModel openAiAudioTranscriptionModel() {
        System.out.println("Inside OpenAiAutoConfiguration - OpenAI API Key for Audio Model: " + apiAudioKey);
        if (apiKey == null) {
            throw new IllegalArgumentException("OpenAI API key must be set");
        }
        return new OpenAiAudioTranscriptionModel(apiAudioKey);
    }
    
    @Bean
    OpenAiAudioSpeechModel openAiAudioSpeechModel() {
        System.out.println("Inside OpenAiAutoConfiguration - OpenAI API Key for Audio Speech Model: " + apiSpeechKey);
        if (apiKey == null) {
            throw new IllegalArgumentException("OpenAI API key must be set");
        }
        return new OpenAiAudioSpeechModel(apiSpeechKey);
    }
}


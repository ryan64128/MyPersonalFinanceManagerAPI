package com.example.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import com.example.dto.AuthenticationRequest;
import com.example.entity.UserEntity;
import com.example.repository.UserRepository;

@RestController
@RequestMapping("/api")
public class AuthController {

    @Autowired
    private UserRepository userRepository; // Assume you have a UserRepository for accessing user data


    @PostMapping("/register")
    public String register(@RequestBody UserEntity user) {
        
        return "User registered successfully";
    }

    @PostMapping("/authenticate")
    public String createAuthenticationToken(@RequestBody AuthenticationRequest authenticationRequest) throws Exception {

        
        return "jwt";
    }

    @PostMapping("/logout")
    public String logout() {
        // Implement logout logic if needed
        return "User logged out successfully";
    }
}

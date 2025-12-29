package com.gpsplit.backend.web;

import com.gpsplit.backend.model.User;
import com.gpsplit.backend.repo.UserRepo;
import lombok.Data;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

@RestController
@RequestMapping("/api/auth")
@CrossOrigin(origins = "*")
public class AuthController {

    private final UserRepo users;

    public AuthController(UserRepo users) {
        this.users = users;
    }

    @PostMapping("/register")
    public ResponseEntity<?> register(@RequestBody RegisterReq req) {
        if (req.getUsername() == null || req.getUsername().isBlank()
                || req.getPassword() == null || req.getPassword().isBlank()) {
            return ResponseEntity.badRequest().body(Map.of("error", "username and password are required"));
        }

        if (users.findByUsername(req.getUsername()).isPresent()) {
            return ResponseEntity.badRequest().body(Map.of("error", "username already exists"));
        }

        User u = User.builder()
                .username(req.getUsername())
                .passwordHash(req.getPassword()) // NOTE: plain text for demo only
                .email(req.getEmail())
                .build();
        users.save(u);

        return ResponseEntity.ok(Map.of(
                "user", Map.of("id", u.getId(), "username", u.getUsername()),
                "token", "demo-token"
        ));
    }

    @PostMapping("/login")
    public ResponseEntity<?> login(@RequestBody LoginReq req) {
        if (req.getUsername() == null || req.getPassword() == null) {
            return ResponseEntity.status(401).body(Map.of("error", "invalid"));
        }

        return users.findByUsername(req.getUsername())
                .filter(u -> req.getPassword().equals(u.getPasswordHash()))
                .<ResponseEntity<?>>map(u -> ResponseEntity.ok(Map.of(
                        "user", Map.of("id", u.getId(), "username", u.getUsername()),
                        "token", "demo-token"
                )))
                .orElseGet(() -> ResponseEntity.status(401).body(Map.of("error", "invalid")));
    }

    @PostMapping("/forgot")
    public Map<String, String> forgot(@RequestBody ForgotReq req) {
        // For this project we don't actually send email.
        // Just always respond success so frontend can show "Check your email".
        return Map.of("status", "ok");
    }

    @PostMapping("/seed")
    public Map<String, String> seed() {
        if (users.findByUsername("demo").isEmpty()) {
            User u = User.builder().username("demo").passwordHash("demo123").build();
            users.save(u);
        }
        return Map.of("status", "ok");
    }

    @Data
    static class LoginReq {
        private String username;
        private String password;
    }

    @Data
    static class RegisterReq {
        private String username;
        private String email;
        private String password;
    }

    @Data
    static class ForgotReq {
        private String email;
    }
}

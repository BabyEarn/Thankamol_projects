package com.gpsplit.backend.repo;

import com.gpsplit.backend.model.User;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.jdbc.AutoConfigureTestDatabase;
import org.springframework.boot.test.autoconfigure.jdbc.AutoConfigureTestDatabase.Replace;
import org.springframework.boot.test.autoconfigure.orm.jpa.DataJpaTest;

import static org.assertj.core.api.Assertions.assertThat;

@DataJpaTest
@AutoConfigureTestDatabase(replace = Replace.ANY)
class UserRepoTest {

    @Autowired
    private UserRepo userRepo;

    @Test
    void saveAndFindByUsername_shouldWork() {
        User u = new User();
        u.setUsername("demo_user");
        u.setEmail("demo@example.com");
        u.setPasswordHash("hashed-pass");

        User saved = userRepo.save(u);

        assertThat(saved.getId()).isNotNull();

        User found = userRepo.findByUsername("demo_user").orElseThrow();
        assertThat(found.getEmail()).isEqualTo("demo@example.com");
    }
}

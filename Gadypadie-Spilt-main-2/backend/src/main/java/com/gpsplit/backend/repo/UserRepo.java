package com.gpsplit.backend.repo;
import java.util.Optional;
import org.springframework.data.jpa.repository.JpaRepository;
import com.gpsplit.backend.model.User;

public interface UserRepo extends JpaRepository<User, Long> {
    Optional<User> findByUsername(String username);
}

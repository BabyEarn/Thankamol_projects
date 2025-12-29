package com.gpsplit.backend.repo;
import org.springframework.data.jpa.repository.JpaRepository;
import com.gpsplit.backend.model.GroupEntity;

public interface GroupRepo extends JpaRepository<GroupEntity, Long> {
}

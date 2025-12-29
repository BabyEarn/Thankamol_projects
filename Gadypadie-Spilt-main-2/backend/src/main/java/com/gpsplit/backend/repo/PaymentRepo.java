package com.gpsplit.backend.repo;

import com.gpsplit.backend.model.Payment;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface PaymentRepo extends JpaRepository<Payment, Long> {
    List<Payment> findByGroup_Id(Long groupId);
}

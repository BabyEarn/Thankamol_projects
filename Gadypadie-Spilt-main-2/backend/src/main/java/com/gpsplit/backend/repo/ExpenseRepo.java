package com.gpsplit.backend.repo;
import org.springframework.data.jpa.repository.JpaRepository;
import com.gpsplit.backend.model.Expense;

public interface ExpenseRepo extends JpaRepository<Expense, Long> {
}

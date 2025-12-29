package com.gpsplit.backend.repo;

import com.gpsplit.backend.model.Expense;
import com.gpsplit.backend.model.GroupEntity;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.jdbc.AutoConfigureTestDatabase;
import org.springframework.boot.test.autoconfigure.jdbc.AutoConfigureTestDatabase.Replace;
import org.springframework.boot.test.autoconfigure.orm.jpa.DataJpaTest;

import java.math.BigDecimal;

import static org.assertj.core.api.Assertions.assertThat;

@DataJpaTest
@AutoConfigureTestDatabase(replace = Replace.ANY)
class ExpenseRepoTest {

    @Autowired
    private ExpenseRepo expenseRepo;

    @Autowired
    private GroupRepo groupRepo;

    @Test
    void saveAndFindExpense_shouldWork() {
        // create and persist a parent bill/group first (group_id is NOT NULL)
        GroupEntity group = GroupEntity.builder()
                .title("Repo Group")
                .baseCurrency("THB")
                .build();
        GroupEntity savedGroup = groupRepo.save(group);

        Expense e = new Expense();
        e.setDescription("Repo Test Expense");
        e.setCurrency("THB");
        e.setAmount(new BigDecimal("123.45"));
        e.setGroup(savedGroup);

        Expense saved = expenseRepo.save(e);

        assertThat(saved.getId()).isNotNull();

        Expense found = expenseRepo.findById(saved.getId()).orElseThrow();
        assertThat(found.getDescription()).isEqualTo("Repo Test Expense");
        assertThat(found.getGroup().getId()).isEqualTo(savedGroup.getId());
    }
}

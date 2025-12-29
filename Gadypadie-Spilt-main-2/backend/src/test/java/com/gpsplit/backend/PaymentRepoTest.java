package com.gpsplit.backend.repo;

import com.gpsplit.backend.model.GroupEntity;
import com.gpsplit.backend.model.Payment;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.jdbc.AutoConfigureTestDatabase;
import org.springframework.boot.test.autoconfigure.jdbc.AutoConfigureTestDatabase.Replace;
import org.springframework.boot.test.autoconfigure.orm.jpa.DataJpaTest;

import java.math.BigDecimal;

import static org.assertj.core.api.Assertions.assertThat;

@DataJpaTest
@AutoConfigureTestDatabase(replace = Replace.ANY)
class PaymentRepoTest {

    @Autowired
    private PaymentRepo paymentRepo;

    @Autowired
    private GroupRepo groupRepo;

    @Test
    void savePayment_shouldAssignId() {
        // create and persist a parent bill/group first (group_id is NOT NULL)
        GroupEntity group = GroupEntity.builder()
                .title("Pay Group")
                .baseCurrency("THB")
                .build();
        GroupEntity savedGroup = groupRepo.save(group);

        Payment p = new Payment();
        p.setFromMember("Alice");
        p.setToMember("Bob");
        p.setAmount(new BigDecimal("500"));
        p.setGroup(savedGroup);

        Payment saved = paymentRepo.save(p);

        assertThat(saved.getId()).isNotNull();
        assertThat(saved.getAmount()).isEqualByComparingTo("500");
        assertThat(saved.getGroup().getId()).isEqualTo(savedGroup.getId());
    }
}

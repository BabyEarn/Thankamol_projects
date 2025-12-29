package com.gpsplit.backend.repo;

import com.gpsplit.backend.model.GroupEntity;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.jdbc.AutoConfigureTestDatabase;
import org.springframework.boot.test.autoconfigure.jdbc.AutoConfigureTestDatabase.Replace;
import org.springframework.boot.test.autoconfigure.orm.jpa.DataJpaTest;

import static org.assertj.core.api.Assertions.assertThat;

@DataJpaTest
@AutoConfigureTestDatabase(replace = Replace.ANY)
class GroupRepoTest {

    @Autowired
    private GroupRepo groupRepo;

    @Test
    void saveAndFindGroup_shouldWork() {
        GroupEntity g = new GroupEntity();
        g.setTitle("Repo Trip");
        g.setBaseCurrency("THB");

        GroupEntity saved = groupRepo.save(g);

        assertThat(saved.getId()).isNotNull();

        GroupEntity found = groupRepo.findById(saved.getId()).orElseThrow();
        assertThat(found.getTitle()).isEqualTo("Repo Trip");
    }
}

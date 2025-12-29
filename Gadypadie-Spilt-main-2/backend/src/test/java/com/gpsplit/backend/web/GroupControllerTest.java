package com.gpsplit.backend.web;

import com.gpsplit.backend.model.GroupEntity;
import com.gpsplit.backend.repo.GroupRepo;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.junit.jupiter.api.Test;
import org.mockito.Mockito;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.http.MediaType;
import org.springframework.test.web.servlet.MockMvc;

import java.util.Collections;
import java.util.Optional;

import static org.hamcrest.Matchers.hasSize;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.when;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

@WebMvcTest(GroupController.class)
class GroupControllerTest {

    @Autowired
    private MockMvc mockMvc;

    @MockBean
    private GroupRepo groupRepo;

    @Autowired
    private ObjectMapper objectMapper;

    @Test
    void getAllGroups_shouldReturnList() throws Exception {
        GroupEntity g = new GroupEntity();
        g.setId(1L);
        g.setTitle("Friday Night");
        g.setBaseCurrency("THB");

        when(groupRepo.findAll()).thenReturn(Collections.singletonList(g));

        mockMvc.perform(get("/api/groups"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$", hasSize(1)))
                .andExpect(jsonPath("$[0].title").value("Friday Night"));
    }

    @Test
    void createGroup_shouldSaveAndReturnEntity() throws Exception {
        GroupEntity requestBody = new GroupEntity();
        requestBody.setTitle("Trip A");
        requestBody.setBaseCurrency("THB");

        GroupEntity saved = new GroupEntity();
        saved.setId(10L);
        saved.setTitle("Trip A");
        saved.setBaseCurrency("THB");

        when(groupRepo.save(any(GroupEntity.class))).thenReturn(saved);

        mockMvc.perform(post("/api/groups")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(requestBody)))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.id").value(10L))
                .andExpect(jsonPath("$.title").value("Trip A"));
    }

    @Test
    void getOneGroup_shouldReturnEntity() throws Exception {
        GroupEntity g = new GroupEntity();
        g.setId(5L);
        g.setTitle("Test Group");
        g.setBaseCurrency("THB");

        when(groupRepo.findById(5L)).thenReturn(Optional.of(g));

        mockMvc.perform(get("/api/groups/{id}", 5L))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.title").value("Test Group"));
    }
}

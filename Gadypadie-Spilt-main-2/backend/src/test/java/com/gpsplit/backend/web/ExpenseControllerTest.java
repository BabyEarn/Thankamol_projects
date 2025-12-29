package com.gpsplit.backend.web;

import com.gpsplit.backend.model.Expense;
import com.gpsplit.backend.repo.ExpenseRepo;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.http.MediaType;
import org.springframework.test.web.servlet.MockMvc;

import java.math.BigDecimal;
import java.util.Collections;

import static org.hamcrest.Matchers.hasSize;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.when;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

@WebMvcTest(ExpenseController.class)
class ExpenseControllerTest {

    @Autowired
    private MockMvc mockMvc;

    @MockBean
    private ExpenseRepo expenseRepo;

    @Autowired
    private ObjectMapper objectMapper;

    @Test
    void getAllExpenses_shouldReturnList() throws Exception {
        Expense e = new Expense();
        e.setId(1L);
        e.setDescription("Dinner");
        e.setCurrency("THB");
        e.setAmount(new BigDecimal("500"));

        when(expenseRepo.findAll()).thenReturn(Collections.singletonList(e));

        mockMvc.perform(get("/api/expenses"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$", hasSize(1)))
                .andExpect(jsonPath("$[0].description").value("Dinner"));
    }

    @Test
    void createExpense_shouldSaveAndReturnExpense() throws Exception {
        Expense req = new Expense();
        req.setDescription("Taxi");
        req.setCurrency("THB");
        req.setAmount(new BigDecimal("150"));

        Expense saved = new Expense();
        saved.setId(99L);
        saved.setDescription("Taxi");
        saved.setCurrency("THB");
        saved.setAmount(new BigDecimal("150"));

        when(expenseRepo.save(any(Expense.class))).thenReturn(saved);

        mockMvc.perform(post("/api/expenses")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(req)))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.id").value(99L))
                .andExpect(jsonPath("$.description").value("Taxi"));
    }
}

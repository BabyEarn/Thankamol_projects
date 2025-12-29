package com.gpsplit.backend.web;

import com.gpsplit.backend.model.Expense;
import com.gpsplit.backend.repo.ExpenseRepo;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/expenses")
@CrossOrigin(origins = "*")
public class ExpenseController {
    private final ExpenseRepo expenses;
    public ExpenseController(ExpenseRepo expenses){ this.expenses = expenses; }

    @GetMapping public List<Expense> all(){ return expenses.findAll(); }
    @PostMapping public Expense create(@RequestBody Expense e){ return expenses.save(e); }
}

package com.gpsplit.backend.web;

import com.gpsplit.backend.model.Expense;
import com.gpsplit.backend.model.GroupEntity;
import com.gpsplit.backend.model.Payment;
import com.gpsplit.backend.repo.ExpenseRepo;
import com.gpsplit.backend.repo.GroupRepo;
import com.gpsplit.backend.repo.PaymentRepo;
import lombok.Data;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.math.BigDecimal;
import java.time.Instant;
import java.util.ArrayList;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/bills")
@CrossOrigin(origins = "*")
public class BillController {

    private final GroupRepo groups;
    private final ExpenseRepo expenses;
    private final PaymentRepo payments;

    public BillController(GroupRepo groups, ExpenseRepo expenses, PaymentRepo payments) {
        this.groups = groups;
        this.expenses = expenses;
        this.payments = payments;
    }

    // -------- Bills --------

    @GetMapping
    public List<BillDto> allBills() {
        List<GroupEntity> all = groups.findAll();
        List<BillDto> out = new ArrayList<>();
        for (GroupEntity g : all) {
            out.add(toDto(g));
        }
        return out;
    }

    @PostMapping
    public BillDto createBill(@RequestBody CreateBillReq req) {
        GroupEntity g = GroupEntity.builder()
                .title(req.getTitle() == null || req.getTitle().isBlank() ? "Untitled bill" : req.getTitle())
                .baseCurrency(req.getBaseCurrency() == null || req.getBaseCurrency().isBlank() ? "THB" : req.getBaseCurrency())
                .recurring(req.getRecurring() != null && req.getRecurring())
                .recurringKey(req.getRecurringKey())
                .build();
        g = groups.save(g);
        return toDto(g);
    }

    @GetMapping("/{id}")
    public BillDto getBill(@PathVariable Long id) {
        GroupEntity g = groups.findById(id).orElseThrow();
        // Force init collections
        g.getMembers().size();
        if (g.getExpenses() != null) g.getExpenses().size();
        if (g.getPayments() != null) g.getPayments().size();
        return toDto(g);
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteBill(@PathVariable Long id) {
        if (groups.existsById(id)) {
            groups.deleteById(id);
        }
        return ResponseEntity.noContent().build();
    }

    // -------- Members --------

    @PostMapping("/{id}/members")
    public BillDto addMember(@PathVariable Long id, @RequestBody MemberReq req) {
        GroupEntity g = groups.findById(id).orElseThrow();
        if (req.getName() != null && !req.getName().isBlank()) {
            Set<String> members = g.getMembers();
            if (members == null) {
                members = new LinkedHashSet<>();
                g.setMembers(members);
            }
            members.add(req.getName());
        }
        g = groups.save(g);
        return toDto(g);
    }

    // -------- Expenses --------

    @PostMapping("/{id}/expenses")
    public BillDto addExpense(@PathVariable Long id, @RequestBody ExpenseReq req) {
        GroupEntity g = groups.findById(id).orElseThrow();
        Expense ex = Expense.builder()
                .group(g)
                .description(req.getDescription())
                .payer(req.getPayer())
                .participants(req.getParticipants() == null ? new LinkedHashSet<>() :
                        new LinkedHashSet<>(req.getParticipants()))
                .currency(req.getCurrency())
                .amount(req.getAmount())
                .amountBase(req.getAmountBase())
                .splitMode(req.getSplitMode())
                .receiptUrl(req.getReceiptUrl())
                .voiceUrl(req.getVoiceUrl())
                .build();
        expenses.save(ex);
        return getBill(id);
    }

    @PutMapping("/{billId}/expenses/{expenseId}")
    public BillDto updateExpense(@PathVariable Long billId,
                                 @PathVariable Long expenseId,
                                 @RequestBody ExpenseReq req) {
        GroupEntity g = groups.findById(billId).orElseThrow();
        Expense ex = expenses.findById(expenseId).orElseThrow();
        if (!ex.getGroup().getId().equals(billId)) {
            throw new IllegalArgumentException("Expense not in this bill");
        }
        ex.setDescription(req.getDescription());
        ex.setPayer(req.getPayer());
        ex.setParticipants(req.getParticipants() == null ? new LinkedHashSet<>() :
                new LinkedHashSet<>(req.getParticipants()));
        ex.setCurrency(req.getCurrency());
        ex.setAmount(req.getAmount());
        ex.setAmountBase(req.getAmountBase());
        ex.setSplitMode(req.getSplitMode());
        ex.setReceiptUrl(req.getReceiptUrl());
        ex.setVoiceUrl(req.getVoiceUrl());
        expenses.save(ex);
        // reload bill
        g = groups.findById(billId).orElseThrow();
        return toDto(g);
    }

    @DeleteMapping("/{billId}/expenses/{expenseId}")
    public BillDto deleteExpense(@PathVariable Long billId, @PathVariable Long expenseId) {
        GroupEntity g = groups.findById(billId).orElseThrow();
        Expense ex = expenses.findById(expenseId).orElse(null);
        if (ex != null && ex.getGroup().getId().equals(billId)) {
            expenses.delete(ex);
        }
        g = groups.findById(billId).orElseThrow();
        return toDto(g);
    }

    @PostMapping("/{id}/clear")
    public BillDto clear(@PathVariable Long id) {
        GroupEntity g = groups.findById(id).orElseThrow();
        if (g.getExpenses() != null) {
            g.getExpenses().clear();
        }
        if (g.getPayments() != null) {
            g.getPayments().clear();
        }
        groups.save(g);
        return getBill(id);
    }

    // -------- Payments --------

    @PostMapping("/{id}/payments")
    public PaymentDto addPayment(@PathVariable Long id, @RequestBody PaymentReq req) {
        GroupEntity g = groups.findById(id).orElseThrow();
        Payment p = Payment.builder()
                .group(g)
                .fromMember(req.getFrom())
                .toMember(req.getTo())
                .amount(req.getAmount() == null ? BigDecimal.ZERO : req.getAmount())
                .method(req.getMethod())
                .referenceCode(req.getReferenceCode())
                .payslipUrl(req.getPayslipUrl())
                .build();
        p = payments.save(p);
        return toDto(p);
    }

    @GetMapping("/{id}/payments")
    public List<PaymentDto> listPayments(@PathVariable Long id) {
        List<Payment> list = payments.findByGroup_Id(id);
        return list.stream().map(BillController::toDto).collect(Collectors.toList());
    }

    // -------- Mapping helpers / DTOs --------

    private static BillDto toDto(GroupEntity g) {
        List<String> members = new ArrayList<>();
        if (g.getMembers() != null) {
            members.addAll(g.getMembers());
        }
        List<ExpenseDto> exDtos = new ArrayList<>();
        if (g.getExpenses() != null) {
            for (Expense e : g.getExpenses()) {
                exDtos.add(toDto(e));
            }
        }
        return new BillDto(
                g.getId(),
                g.getTitle(),
                g.getBaseCurrency(),
                members,
                exDtos
        );
    }

    private static ExpenseDto toDto(Expense e) {
        List<String> participants = new ArrayList<>();
        if (e.getParticipants() != null) {
            participants.addAll(e.getParticipants());
        }
        return new ExpenseDto(
                e.getId(),
                e.getDescription(),
                e.getPayer(),
                participants,
                e.getCurrency(),
                e.getAmount(),
                e.getAmountBase(),
                e.getSplitMode(),
                e.getReceiptUrl(),
                e.getVoiceUrl(),
                e.getCreatedAt()
        );
    }

    private static PaymentDto toDto(Payment p) {
        return new PaymentDto(
                p.getId(),
                p.getFromMember(),
                p.getToMember(),
                p.getAmount(),
                p.getCreatedAt()
        );
    }

    // ----- DTO records / request bodies -----

    public record BillDto(
            Long id,
            String title,
            String baseCurrency,
            List<String> members,
            List<ExpenseDto> expenses
    ) {}

    public record ExpenseDto(
            Long id,
            String description,
            String payer,
            List<String> participants,
            String currency,
            BigDecimal amount,
            BigDecimal amountBase,
            String splitMode,
            String receiptUrl,
            String voiceUrl,
            Instant createdAt
    ) {}

    public record PaymentDto(
            Long id,
            String from,
            String to,
            BigDecimal amount,
            Instant createdAt
    ) {}

    @Data
    public static class CreateBillReq {
        private String title;
        private String baseCurrency;
        private Boolean recurring;
        private String recurringKey;
    }

    @Data
    public static class MemberReq {
        private String name;
    }

    @Data
    public static class ExpenseReq {
        private String description;
        private String payer;
        private List<String> participants;
        private String currency;
        private BigDecimal amount;
        private BigDecimal amountBase;
        private String splitMode;
        private String receiptUrl;
        private String voiceUrl;
    }

    @Data
    public static class PaymentReq {
        private String from;
        private String to;
        private BigDecimal amount;
        private String method;
        private String referenceCode;
        private String payslipUrl;
    }
}

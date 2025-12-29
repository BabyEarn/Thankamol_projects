package com.gpsplit.backend.model;

import jakarta.persistence.*;
import lombok.*;

import java.math.BigDecimal;
import java.time.Instant;
import java.util.LinkedHashSet;
import java.util.Set;

@Entity
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
@Table(name = "expenses")
public class Expense {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    // parent bill / group
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "group_id", nullable = false)
    private GroupEntity group;

    @Column(length = 255)
    private String description;

    @Column(length = 128)
    private String payer;              // simple string name

    @ElementCollection
    @CollectionTable(name = "expense_participants", joinColumns = @JoinColumn(name = "expense_id"))
    @Column(name = "participant_name")
    @Builder.Default
    private Set<String> participants = new LinkedHashSet<>();

    @Column(length = 8)
    private String currency;           // original currency (e.g. THB, USD)

    @Column(precision = 18, scale = 2)
    private BigDecimal amount;         // original amount

    @Column(precision = 18, scale = 2)
    private BigDecimal amountBase;     // converted to base (e.g. THB)

    @Column(length = 16)
    private String splitMode;          // EQUAL/AMOUNT/PERCENT/TAG

    @Column(length = 512)
    private String receiptUrl;

    @Column(length = 512)
    private String voiceUrl;

    @Column(nullable = false, updatable = false)
    @Builder.Default
    private Instant createdAt = Instant.now();
}

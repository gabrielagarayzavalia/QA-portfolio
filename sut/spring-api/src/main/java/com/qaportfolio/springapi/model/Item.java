package com.qaportfolio.springapi.model;

import java.time.Instant;
import java.util.UUID;

public record Item(
        UUID id,
        String name,
        String description,
        boolean active,
        Instant createdAt
) {}

package com.qaportfolio.springapi.model;

import java.util.List;

public record PagedItems(
        List<Item> content,
        int page,
        int size,
        long totalElements,
        int totalPages
) {}

package com.qaportfolio.springapi.service;

import com.qaportfolio.springapi.model.*;
import org.springframework.stereotype.Service;

import java.time.Instant;
import java.util.*;
import java.util.concurrent.ConcurrentHashMap;
import java.util.stream.Collectors;

@Service
public class ItemStore {
    private final Map<UUID, Item> items = new ConcurrentHashMap<>();

    public Item create(ItemCreateRequest req) {
        UUID id = UUID.randomUUID();
        Item item = new Item(
                id,
                req.name().trim(),
                req.description() != null ? req.description() : "",
                req.active() == null || req.active(),
                Instant.now()
        );
        items.put(id, item);
        return item;
    }

    public Optional<Item> findById(UUID id) {
        return Optional.ofNullable(items.get(id));
    }

    public Optional<Item> update(UUID id, ItemUpdateRequest req) {
        Item existing = items.get(id);
        if (existing == null) return Optional.empty();
        String name = req.name() != null ? req.name().trim() : existing.name();
        String description = req.description() != null ? req.description() : existing.description();
        boolean active = req.active() != null ? req.active() : existing.active();
        Item updated = new Item(id, name, description, active, existing.createdAt());
        items.put(id, updated);
        return Optional.of(updated);
    }

    public boolean delete(UUID id) {
        return items.remove(id) != null;
    }

    public PagedItems list(int page, int size, Boolean active) {
        List<Item> all = new ArrayList<>(items.values());
        if (active != null) {
            all = all.stream().filter(i -> i.active() == active).collect(Collectors.toList());
        }
        all.sort(Comparator.comparing(Item::createdAt).reversed());
        long total = all.size();
        int totalPages = total == 0 ? 0 : (int) Math.ceil((double) total / size);
        int from = page * size;
        List<Item> content = from >= all.size()
                ? List.of()
                : all.subList(from, Math.min(from + size, all.size()));
        return new PagedItems(content, page, size, total, totalPages);
    }
}

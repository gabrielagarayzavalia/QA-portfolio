package com.qaportfolio.springapi.web;

import com.qaportfolio.springapi.model.*;
import com.qaportfolio.springapi.service.ItemStore;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.UUID;

@RestController
@RequestMapping("/api/items")
public class ItemsController {
    private final ItemStore store;

    public ItemsController(ItemStore store) {
        this.store = store;
    }

    @GetMapping
    public PagedItems list(
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "20") int size,
            @RequestParam(required = false) Boolean active) {
        return store.list(page, size, active);
    }

    @PostMapping
    public ResponseEntity<?> create(@RequestBody ItemCreateRequest body) {
        if (body == null || body.name() == null || body.name().isBlank()) {
            return ResponseEntity.badRequest().body(new ErrorResponse("name is required and must not be empty"));
        }
        return ResponseEntity.status(HttpStatus.CREATED).body(store.create(body));
    }

    @GetMapping("/{id}")
    public ResponseEntity<?> get(@PathVariable UUID id) {
        return store.findById(id)
                .<ResponseEntity<?>>map(ResponseEntity::ok)
                .orElseGet(() -> ResponseEntity.status(HttpStatus.NOT_FOUND)
                        .body(new ErrorResponse("Item not found")));
    }

    @PutMapping("/{id}")
    public ResponseEntity<?> update(@PathVariable UUID id, @RequestBody ItemUpdateRequest body) {
        if (body != null && body.name() != null && body.name().isBlank()) {
            return ResponseEntity.badRequest().body(new ErrorResponse("name must not be empty when provided"));
        }
        return store.update(id, body != null ? body : new ItemUpdateRequest(null, null, null))
                .<ResponseEntity<?>>map(ResponseEntity::ok)
                .orElseGet(() -> ResponseEntity.status(HttpStatus.NOT_FOUND)
                        .body(new ErrorResponse("Item not found")));
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<?> delete(@PathVariable UUID id) {
        if (!store.delete(id)) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(new ErrorResponse("Item not found"));
        }
        return ResponseEntity.noContent().build();
    }
}

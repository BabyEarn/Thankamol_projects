package com.gpsplit.backend.web;

import com.gpsplit.backend.model.GroupEntity;
import com.gpsplit.backend.repo.GroupRepo;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/groups")
public class GroupController {

    private final GroupRepo groupRepo;

    public GroupController(GroupRepo groupRepo) {
        this.groupRepo = groupRepo;
    }

    @GetMapping
    public List<GroupEntity> getAllGroups() {
        return groupRepo.findAll();
    }

    @PostMapping
    public GroupEntity createGroup(@RequestBody GroupEntity group) {
        return groupRepo.save(group);
    }

    @GetMapping("/{id}")
    public ResponseEntity<GroupEntity> getOneGroup(@PathVariable("id") Long id) {
        return groupRepo.findById(id)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }
}

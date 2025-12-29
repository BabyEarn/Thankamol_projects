package com.gpsplit.backend.web;

import com.gpsplit.backend.model.GroupEntity;
import com.gpsplit.backend.repo.GroupRepo;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/groups")
@CrossOrigin(origins = "*")
public class GroupController {
    private final GroupRepo groups;
    public GroupController(GroupRepo groups) { this.groups = groups; }

    @GetMapping public List<GroupEntity> all(){ return groups.findAll(); }
    @PostMapping public GroupEntity create(@RequestBody GroupEntity g){ return groups.save(g); }
    @GetMapping("/{id}") public GroupEntity one(@PathVariable("id") Long id){ return groups.findById(id).orElseThrow(); }
}

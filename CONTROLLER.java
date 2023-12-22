package com.company.base.endpoint.rest.controller.health;

import com.company.base.PojaGenerated;
import com.company.base.service.SumService;
import java.math.BigInteger;
import lombok.AllArgsConstructor;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@PojaGenerated
@RestController
@AllArgsConstructor
public class SumController {
  private final SumService service;

  @GetMapping("/big-sum")
  public BigInteger sum(@RequestParam("a") int a, @RequestParam("b") int b) {
    return service.sum(a, b);
  }
}

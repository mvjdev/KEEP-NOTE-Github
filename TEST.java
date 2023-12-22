package com.company.base.endpoint.rest.controller;

import com.company.base.PojaGenerated;
import com.company.base.conf.FacadeIT;
import com.company.base.endpoint.rest.controller.health.SumController;
import java.math.BigInteger;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;

import static org.junit.jupiter.api.Assertions.assertEquals;

@PojaGenerated
class SumControllerIT extends FacadeIT {

  @Autowired
  SumController sumController;

  @Test
  void sum() {
    var expected = new BigInteger(String.valueOf(3));
    assertEquals(expected, sumController.sum(1, 2));
  }

}

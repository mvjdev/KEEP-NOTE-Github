package com.company.base.service;

import java.math.BigInteger;

public class SumService {
  public BigInteger sum(int a, int b) {
    var bigA = new BigInteger(String.valueOf(a));
    var bigB = new BigInteger(String.valueOf(b));
    return bigA.add(bigB);

  }

}

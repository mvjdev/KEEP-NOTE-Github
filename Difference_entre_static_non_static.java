package com.example.restaurationstd22082.model;

public class Menu {
 public static int test = 5;
 public int test2 ;

 public Menu(int test2) {
  this.test2 = test2;
 }
 public static void main(String[] args) {
  System.out.println(test);
  Menu testing = new Menu(3);
  System.out.println(testing.test2);
 }
}



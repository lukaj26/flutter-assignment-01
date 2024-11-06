import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

enum theCategory {
  transportation,
  housing,
  food,
  utilities,
  clothing,
  healthcare,
  personal,
  work,
  other
}

class Expense extends Equatable {
  Expense(
      {this.id,
      this.image,
      required this.name,
      this.description,
      required this.amount,
      required this.expenseDate,
      required this.category});
  String? id;
  String name;
  String? description;
  String amount;
  DateTime expenseDate;
  theCategory category;
  Image? image;

  @override
  // TODO: implement props
  List<Object?> get props =>
      [id, name, description, amount, expenseDate, category, image];
}

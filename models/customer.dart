class Customer {
  late String customerId;
  final String name;
  final String? imageURL;
  final String location;
  double installment;

  //TODO:initial this value from DB
  late bool havePreviousInstallment;

  Customer({
    required this.name,
    required this.imageURL,
    required this.installment,
    required this.location,
  });
}

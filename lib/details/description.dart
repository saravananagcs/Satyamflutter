import 'package:flutter/cupertino.dart';
import '../product/product.dart';

class Description extends StatelessWidget {
  const Description({
    Key key,
     this.product,
  }) : super(key: key);

  final Product product;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: Text(
        product.description,
        style: TextStyle(height: 1.5),
      ),
    );
  }
}
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shop/providers/orders.dart' as ord;
import 'package:intl/intl.dart';

class OrderItem extends StatefulWidget {
  final ord.OrderItem order;

  OrderItem(this.order);

  @override
  _OrderItemState createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  var _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10),
      child: Column(
        children: [
          ListTile(title: Text('\$${widget.order.amount}'),
            subtitle: Text(DateFormat('dd/MM/yyyy hh:mm').format(widget.order.dateTime)),
          trailing: IconButton(
            icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
            onPressed: () {
              setState(() {
                _expanded = !_expanded;
              });
            },),
          ),
          if(_expanded)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
              height: min(widget.order.products.length * 20 + 30, 180),
              child: ListView(
                children: widget.order.products.map((product) => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(product.title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
                    Text('${product.quantity} x \$${product.price}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.grey),),
                  ],
                )).toList()
              ),
            )
        ],
      ),
    );
  }
}

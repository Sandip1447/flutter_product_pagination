import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_product_pagination/model/product.dart';
import 'package:flutter_product_pagination/res/endpoints.dart';
import 'package:http/http.dart' as http;

class ProductPage extends StatefulWidget {
  const ProductPage({super.key});

  @override
  State<StatefulWidget> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  final _scrollController = ScrollController();

  final List<ProductElement> _products = [];
  bool _isLoading = false;
  bool _hasMore = true;

  int limit = 10;
  int skip = 0;

  int total = 10;

  @override
  void initState() {
    super.initState();

    fetchProductList();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent * 0.9 &&
          !_isLoading &&
          _hasMore) {
        fetchProductList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Products")),
      body: ListView.builder(
        itemCount: _products.length + (_hasMore ? 1 : 0),
        controller: _scrollController,
        itemBuilder: (context, index) {
          if (index < _products.length) {
            final product = _products[index];
            return Container(
              padding: EdgeInsets.all(16),
              child: Row(
                children: [
                  Image.network(product.thumbnail, width: 100, height: 100),
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.title,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(product.description, maxLines: 3),
                        Text(
                          "₹${product.price}",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }
          return Padding(
            padding: EdgeInsets.all(16),
            child: Center(child: CircularProgressIndicator()),
          );
        },
      ),
    );
  }

  Future<void> fetchProductList() async {
    try {
      if (_isLoading) return;

      setState(() {
        _isLoading = true;
      });

      final response = await http.get(
        Uri.parse(Endpoints.getProductUrl(skip: skip)),
      );
      if (response.statusCode == 200) {
        final data = Product.fromMap(jsonDecode(response.body));
        log(" ${data.total}");
        setState(() {
          _products.addAll(data.products);
          skip += limit;
          total = data.total;
          _hasMore = _products.length < total;
        });
      }
    } catch (error) {
      log("NETWORK FAILED");
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}

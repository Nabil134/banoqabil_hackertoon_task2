import 'dart:html';
import 'dart:js';

// Set to store product IDs that have been added to the cart
Set<String> addedProducts = Set();
Map<String, double> productPrices = {
  'product1': 10.00, // Add prices for all products here
  'product2': 60.00,
  'product3': 60.00,
  'product4': 20.00,
  'product5': 8.00,
  'product6': 30.00,
};

void main() {
  querySelectorAll('.add-to-cart').forEach((button) {
    button.onClick.listen((event) {
      var productId = button.getAttribute('data-product-id');
      var productName = button.parent?.querySelector('h3')?.text; // Add null checks
      if (productId != null && productName != null) {
        if (!addedProducts.contains(productId)) {
          addToCart(productId, productName); // Add product only if it's not already in the cart
          addedProducts.add(productId); // Add the product ID to the set
        } else {
          showDuplicateProductMessage(productName); // Show message if the product is already in the cart
        }
      } else {
        print('Error: Product ID or name is null');
      }
    });
  });
}

void addToCart(String productId, String productName) {
  // Implement your add to cart logic here
  print('Adding product $productId to cart');
  updateCartIconAndCount();
  showAddedToCartMessage(productName);
  updateTotalProducts(); // Update total products count
  updateTotalPriceAndProducts(); // Update total price and products list
}

void updateCartIconAndCount() {
  var cartIcon = querySelector('.fa-cart-shopping');
  var cartItemsCount = querySelector('#cartNum');
  
  if (cartItemsCount != null) {
    var currentCount = int.tryParse(cartItemsCount.text ?? ''); // Use tryParse to handle null or invalid string
    if (currentCount != null) {
      cartItemsCount.text = (currentCount + 1).toString();
    } else {
      print('Error: Unable to parse cartItemsCount.text');
    }
  }
}

void showAddedToCartMessage(String productName) {
  var message = '$productName has been added to cart.';
  context.callMethod('swal', [message]); // Display message using SweetAlert
}

void showDuplicateProductMessage(String productName) {
  var message = 'Product $productName is already in the cart.';
  context.callMethod('swal', [message]); // Display message using SweetAlert
}

void updateTotalProducts() {
  var totalNumElement = querySelector('#totalNum');
  if (totalNumElement != null) {
    totalNumElement.text = addedProducts.length.toString(); // Update total products count
  }
}

void updateTotalPriceAndProducts() {
  var totalPriceElement = querySelector('#totalPriceNum');
  var productsListElement = querySelector('#productsList');
  if (totalPriceElement != null && productsListElement != null) {
    double totalPrice = 0.0;
    productsListElement.innerHtml = ''; // Clear previous product details
    addedProducts.forEach((productId) {
      var productDetails = getProductDetails(productId);
      var productName = productDetails['name'];
      var productPrice = productDetails['price'];
      var productQuantity = getProductQuantity(productId);
      var productTotal = productPrice * productQuantity;
      productsListElement.appendHtml('<p>$productName - \$$productPrice x $productQuantity = \$$productTotal</p>');
      totalPrice += productTotal;
    });
    totalPriceElement.text = 'Total: \$$totalPrice'; // Update total price
  }
}

Map<String, dynamic> getProductDetails(String productId) {
  // Define the product names here instead of 'Product 1', 'Product 2', etc.
  Map<String, String> productNames = {
    'product1': 'Sweat Shirt',
    'product2': 'Cotton Shirt',
    'product3': 'T Shirt',
    'product4': 'Formal Shirt For Men',
    'product5': 'Latest Brand',
    'product6': 'Upcoming Brand',
  };

  return {
    'name': productNames[productId] ?? 'Unknown Product', // Get product name from the map
    'price': productPrices[productId] ?? 0.0,
  };
}

int getProductQuantity(String productId) {
  // Implement logic to get the quantity of the product in the cart
  // For simplicity, let's assume each product is added only once
  return 1;
}

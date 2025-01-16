$(document).ready(function () {
  // Shopping Cart functionality
  let cart;

  // Function to add item to cart (to be called from product pages)
  function addToCart(productCode, productName, size, price, imageUrl) {
    cart.addItem(productCode, productName, size, price, imageUrl);
  }

  class ShoppingCart {
    constructor() {
      this.cart = JSON.parse(localStorage.getItem("cart")) || [];
      this.couponCode = localStorage.getItem("cartCouponCode") || "";
      this.discount = parseInt(localStorage.getItem("cartDiscount")) || 0;
      this.maximumDiscountValue = Infinity;
      this.updateCartDisplay();
    }

    // Add item to cart
    addItem(productCode, productName, size, price, imageUrl) {
      const existingItem = this.cart.find(
        (item) => item.productCode === productCode && item.size == size
      );

      if (existingItem) {
        existingItem.quantity += 1;
      } else {
        this.cart.push({
          productCode,
          productName,
          size,
          price,
          imageUrl,
          quantity: 1,
        });
      }

      this.saveCart();
      this.updateCartDisplay();
    }

    // Remove item from cart
    removeItem(productCode, size) {
      this.cart = this.cart.filter(
        (item) => !(item.productCode === productCode && item.size == size)
      );
      this.updateCartDisplay();
    }

    // Update item quantity
    async updateQuantity(productCode, size, quantity) {
      console.log(this.cart, productCode, size, quantity);
      const item = this.cart.find(
        (item) => item.productCode === productCode && item.size == size
      );
      
      
      if (item && quantity > 0) {
        try {
          // Get product ID from the first part of the product code (before the first dash)
          const productId = productCode.split('-')[0];
          
          // Validate if the requested quantity is available
          const response = await fetch(`/api/products/${productId}/validate-quantity?size=${size}&quantity=${quantity}`);
          
          if (response.ok) {
            // Update quantity if available
            item.quantity = quantity;
            this.saveCart();
            this.updateCartDisplay();
          } else {
            // Show error message if not available
            const message = await response.text();
            toastr.error(message || "Số lượng yêu cầu không có sẵn");
            // Reset quantity input to previous value
            this.updateCartDisplay();
          }
        } catch (error) {
          console.error('Error:', error);
          toastr.error("Có lỗi xảy ra khi kiểm tra số lượng");
          this.updateCartDisplay();
        }
      }
    }

    // Save cart to localStorage
    saveCart() {
      localStorage.setItem("cart", JSON.stringify(this.cart));
      localStorage.setItem("cartCouponCode", this.couponCode);
      localStorage.setItem("cartDiscount", this.discount.toString());
      localStorage.setItem("cartMaximumDiscountValue", this.maximumDiscountValue.toString());
    }

    // Clear cart
    clearCart() {
      this.cart = [];
      this.couponCode = "";
      this.discount = 0;
      this.saveCart();
      this.updateCartDisplay();
    }

    // Apply coupon to entire cart
    async applyCoupon(couponCode) {
      try {
        // If coupon exists and button clicked, remove it
        if (this.couponCode) {
          this.couponCode = "";
          this.discount = 0;
          this.maximumDiscountValue = Infinity;
          this.saveCart();
          this.updateCartDisplay();
          return {
            success: true,
            message: "Đã gỡ mã giảm giá",
            action: "remove",
          };
        }

        // Otherwise try to apply new coupon
        const response = await fetch(
          "/api/check-hidden-promotion?code=" + couponCode,
          {
            method: "GET",
            headers: {
              "Content-Type": "application/json",
            },
          }
        );

        const result = await response.json();

        if (response.ok) {
          this.couponCode = couponCode;
          this.discount = result.discountValue;
          this.maximumDiscountValue = result.maximumDiscountValue;
          this.saveCart();
          this.updateCartDisplay();
          return {
            success: true,
            message: "Áp dụng mã giảm giá thành công",
            action: "apply",
          };
        } else {
          return {
            success: false,
            message: result.message || "Mã giảm giá không hợp lệ",
            action: "error",
          };
        }
      } catch (error) {
        console.error("Error applying coupon:", error);
        return {
          success: false,
          message: "Có lỗi xảy ra khi áp dụng mã giảm giá",
          action: "error",
        };
      }
    }

    // Calculate cart totals
    calculateTotals() {
      let subtotal = 0;
      this.cart.forEach((item) => {
        subtotal += item.price * item.quantity;
      });
      let discountValue = 0;
      if (this.couponCode) {
        discountValue = subtotal * this.discount / 100;
        discountValue = discountValue > 10000 ? 10000 : discountValue;
      }
      const total = subtotal - discountValue;
      return {
        subtotal,
        discount: discountValue,
        total: total > 0 ? total : 0,
      };
    }

    // Update cart display
    updateCartDisplay() {
      const cartContainer = document.querySelector(".cart-items");
      if (!cartContainer) return;

      const couponInput = document.getElementById("coupon-code");
      const couponButton = document.getElementById("apply-coupon");
      const couponMessage = document.getElementById("coupon-message");

      cartContainer.innerHTML = "";
      const totals = this.calculateTotals();

      // Update items
      this.cart.forEach((item) => {
        const itemHtml = `
          <div class="cart-item row align-items-center mb-3" data-product-code="${item.productCode}" data-size="${item.size}">
            <div class="col-2">
              <img src="${item.imageUrl}" alt="${item.productName}" class="img-fluid">
            </div>
            <div class="col-4">
              <h6 class="mb-1">${item.productName}</h6>
              <p class="mb-0">Size: ${item.size}</p>
              <p class="mb-0">Giá: ${this.formatPrice(item.price)}đ</p>
            </div>
            <div class="col-4 d-flex align-items-center">
              <div class="d-flex align-items-center">
                <button class="btn btn-sm btn-outline-secondary decrease-quantity">-</button>
                <input type="number" class="form-control form-control-sm mx-2 quantity-input mb-0" 
                  value="${item.quantity}" min="1" style="width: 60px; text-align: center;">
                <button class="btn btn-sm btn-outline-secondary increase-quantity">+</button>
              </div>
            </div>
            <div class="col-2">
              <button class="btn btn-sm btn-danger remove-item">
                <i class="fas fa-trash"></i>
              </button>
            </div>
          </div>
        `;
        cartContainer.insertAdjacentHTML("beforeend", itemHtml);
      });

      // Update totals
      document.getElementById("cart-subtotal").textContent = this.formatPrice(totals.subtotal);
      document.getElementById("cart-discount").textContent = this.formatPrice(totals.discount);
      document.getElementById("cart-total").textContent = this.formatPrice(totals.total);

      // Update coupon display
      if (couponInput && couponButton) {
        couponInput.value = this.couponCode;
        couponButton.textContent = this.couponCode ? "Gỡ mã giảm giá" : "Áp dụng";
      }

      // Update cart count
      const cartCount = document.querySelector(".cart-count");
      if (cartCount) {
        const totalItems = this.cart.reduce((sum, item) => sum + item.quantity, 0);
        cartCount.textContent = totalItems;
      }

      this.saveCart();

      // Add event listeners for cart item buttons
      document.querySelectorAll('.cart-item').forEach(item => {
        const productCode = item.dataset.productCode;
        const size = item.dataset.size;
        const quantityInput = item.querySelector('.quantity-input');

        item.querySelector('.decrease-quantity')?.addEventListener('click', () => {
          const newQuantity = parseInt(quantityInput.value) - 1;
          if (newQuantity >= 1) {
            this.updateQuantity(productCode, size, newQuantity);
          }
        });

        item.querySelector('.increase-quantity')?.addEventListener('click', () => {          
          const newQuantity = parseInt(quantityInput.value) + 1;
          this.updateQuantity(productCode, size, newQuantity);
        });

        item.querySelector('.remove-item')?.addEventListener('click', () => {
          this.removeItem(productCode, size);
        });

        quantityInput?.addEventListener('change', (e) => {
          const newQuantity = parseInt(e.target.value);
          if (newQuantity >= 1) {
            this.updateQuantity(productCode, size, newQuantity);
          } else {
            e.target.value = 1;
            this.updateQuantity(productCode, size, 1);
          }
        });
      });

      // Add event listener for coupon button
      couponButton?.addEventListener('click', async () => {
        const code = couponInput.value.trim();
        if (!code) {
          couponMessage.textContent = 'Vui lòng nhập mã giảm giá';
          couponMessage.style.color = '#dc3545';
          return;
        }

        const result = await this.applyCoupon(code);
        couponMessage.textContent = result.message;
        couponMessage.style.color = result.success ? '#28a745' : '#dc3545';
        
        if (result.success) {
          if (result.action === 'remove') {
            couponInput.value = '';
            couponButton.textContent = 'Áp dụng';
          } else {
            couponButton.textContent = 'Gỡ mã giảm giá';
          }
        }
      });
    }

    // Get cart data for order creation
    getOrderData() {
      const totals = this.calculateTotals();
      return {
        items: this.cart.map(item => ({
          productCode: item.productCode,
          size: item.size,
          quantity: item.quantity,
          price: item.price
        })),
        coupon_code: this.couponCode,
        discount: totals.discount
      };
    }

    // Create order
    createOrder() {
      // Check if cart is empty
      if (this.cart.length === 0) {
        alert("Giỏ hàng trống. Vui lòng thêm sản phẩm vào giỏ hàng.");
        return;
      }

      // Show order form if not visible
      const orderForm = document.getElementById("orderForm");
      if (!orderForm.classList.contains("show")) {
        orderForm.classList.add("show");
        
        // Auto-fill user information
        const receiverName = document.getElementById("receiver-name");
        const receiverPhone = document.getElementById("receiver-phone");
        const receiverAddress = document.getElementById("receiver-address");

        if (receiverName && !receiverName.value) {
          receiverName.value = receiverName.dataset.userFullname || '';
        }
        if (receiverPhone && !receiverPhone.value) {
          receiverPhone.value = receiverPhone.dataset.userPhone || '';
        }
        if (receiverAddress && !receiverAddress.value) {
          receiverAddress.value = receiverAddress.dataset.userAddress || '';
        }
        
        return;
      }

      // Get the form
      const form = document.getElementById("order-form");
      form.classList.add("was-validated");

      // Check form validity
      if (!form.checkValidity()) {
        return;
      }

      const orderData = this.getOrderData();

      orderData.receiverName = document.getElementById("receiver-name").value;
      orderData.receiverPhone = document.getElementById("receiver-phone").value;
      orderData.receiverAddress = document.getElementById("receiver-address").value;
      orderData.note = document.getElementById("order-note")?.value || "";

      fetch("/api/orders", {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
        },
        body: JSON.stringify(orderData),
      })
        .then((response) => {
          // if (!response.ok) {
          //   throw new Error('Network response was not ok');
          // }
          return response.json();
        })
        .then((data) => {
          // check error by html status and throw error
          if (data.error) {
            throw new Error(data.message);
          }
          // Clear cart after successful order creation
          this.clearCart();
          // Remove validation classes
          form.classList.remove("was-validated");
          // Reset form
          form.reset();
          // Hide form
          orderForm.classList.remove("show");
          // Redirect to first order's detail page
          if (data.orderId) {
            window.location.href = `/tai-khoan/lich-su-giao-dich/${data.orderId}`;
          } else {
            throw new Error("No order IDs returned");
          }
        })
        .catch((error) => {
          console.error("Error creating order:", error);
          toastr.error(error.message);
          // alert('Có lỗi xảy ra khi đặt hàng. Vui lòng thử lại.');
        });
    }

    formatPrice(price) {
      return `${Number(price).toLocaleString("en-US")} VNĐ`;
    }
  }

  // Initialize cart
  window.cart = new ShoppingCart();

  // Make addToCart function globally available
  window.addToCart = function (
    productCode,
    productName,
    size,
    price,
    imageUrl
  ) {
    window.cart.addItem(productCode, productName, size, price, imageUrl);
  };
});

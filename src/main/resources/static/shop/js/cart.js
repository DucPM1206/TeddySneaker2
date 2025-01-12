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
      this.updateCartDisplay();
    }

    // Add item to cart
    addItem(productCode, productName, size, price, imageUrl) {
      const existingItem = this.cart.find(
        (item) => item.productCode === productCode && item.size === size
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
          couponCode: "",
          discount: 0,
        });
      }

      this.saveCart();
      this.updateCartDisplay();
    }

    // Remove item from cart
    removeItem(productCode, size) {
      this.cart = this.cart.filter(
        (item) => !(item.productCode === productCode && item.size === size)
      );
      this.updateCartDisplay();
    }

    // Update item quantity
    updateQuantity(productCode, size, quantity) {
      const item = this.cart.find(
        (item) => item.productCode === productCode && item.size === size
      );
      if (item && quantity > 0) {
        item.quantity = quantity;
        this.updateCartDisplay();
      }
    }

    // Apply coupon to specific item
    async applyCoupon(productCode, size, couponCode) {
      try {
        const item = this.cart.find(
          (item) => item.productCode === productCode && item.size === size
        );

        // If coupon exists and button clicked, remove it
        if (item && item.couponCode) {
          item.couponCode = "";
          item.discount = 0;
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

        if (response.ok && item) {
          item.couponCode = couponCode;
          let discount = item.price * (result.discountValue / 100);
          if(discount > result.maximumDiscountValue) {
            discount = result.maximumDiscountValue;
          }
          item.discount = discount;
          this.saveCart();
          this.updateCartDisplay();
          return {
            success: true,
            message: "Mã giảm giá đã được áp dụng",
            action: "apply",
          };
        }
        return {
          success: false,
          message: result.message || "Mã giảm giá không hợp lệ",
          action: "error",
        };
      } catch (error) {
        console.error("Error applying coupon:", error);
        return {
          success: false,
          message: "Có lỗi xảy ra khi áp dụng mã giảm giá",
          action: "error",
        };
      }
    }

    // Calculate total price
    getTotalPrice() {
      return this.cart.reduce(
        (total, item) =>
          total + (item.price - (item.discount || 0)) * item.quantity,
        0
      );
    }

    // Get total items count
    getTotalItems() {
      return this.cart.reduce((total, item) => total + item.quantity, 0);
    }

    // Save cart to localStorage
    saveCart() {
      localStorage.setItem("cart", JSON.stringify(this.cart));
    }

    // Update cart display
    updateCartDisplay() {
      const cartCount = document.getElementById("cart-count");
      const cartItemsContainer = document.getElementById("cart-items");
      const cartTotalElement = document.getElementById("cart-total");
      const template = document.querySelector(".cart-item-template .cart-item");

      if (!cartItemsContainer || !template) return;

      // Clear existing items
      cartItemsContainer.innerHTML = "";

      let total = 0;

      // Add each item
      this.cart.forEach((item) => {
        // Clone template
        const clone = template.cloneNode(true);

        // Set item details
        const img = clone.querySelector(".product-image");
        img.src = item.imageUrl;
        img.alt = item.productName;

        clone.querySelector(".product-name").textContent = item.productName;
        clone.querySelector(".product-size span").textContent = item.size;
        clone.querySelector(".product-price").textContent = this.formatPrice(
          item.price - (item.discount || 0)
        );

        // Set quantity
        const quantityInput = clone.querySelector(".quantity-input");
        quantityInput.value = item.quantity;
        quantityInput.dataset.productCode = item.productCode;
        quantityInput.dataset.size = item.size;
        quantityInput.addEventListener("change", (e) => {
          const newQuantity = parseInt(e.target.value);
          if (newQuantity > 0) {
            this.updateQuantity(item.productCode, item.size, newQuantity);
          }
        });

        // Set coupon code if exists
        const couponInput = clone.querySelector(".coupon-input");
        const applyButton = clone.querySelector(".apply-coupon");
        couponInput.value = item.couponCode || "";
        couponInput.dataset.productCode = item.productCode;
        couponInput.dataset.size = item.size;

        // Update button text based on coupon status
        applyButton.textContent = item.couponCode ? "Gỡ" : "Áp dụng";

        // Add coupon apply handler
        const couponMessage = clone.querySelector(".coupon-message");

        applyButton.addEventListener("click", async () => {
          const result = await this.applyCoupon(
            item.productCode,
            item.size,
            couponInput.value
          );
          couponMessage.textContent = result.message;
          toastr[result.success ? "success" : "warning"](result.message);
          couponMessage.className = `coupon-message text-${
            result.success ? "success" : "danger"
          }`;
          applyButton.textContent =
            result.action === "apply" ? "Gỡ" : "Áp dụng";

          if (result.action === "remove") {
            couponInput.value = "";
          }
        });

        // Add remove handler
        const removeButton = clone.querySelector(".remove-item");
        removeButton.dataset.productCode = item.productCode;
        removeButton.dataset.size = item.size;
        removeButton.addEventListener("click", () => {
          this.removeItem(item.productCode, item.size);
        });

        cartItemsContainer.appendChild(clone);
        total += (item.price - (item.discount || 0)) * item.quantity;
      });

      if (cartCount) {
        cartCount.textContent = this.getTotalItems();
      }

      if (cartTotalElement) {
        cartTotalElement.textContent = this.formatPrice(total);
      }

      // Save cart state after any update
      this.saveCart();
    }

    // Clear cart
    clearCart() {
      this.cart = [];
      this.saveCart();
      this.updateCartDisplay();
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

      const orderData = {
        items: this.cart.map((item) => ({
          productCode: item.productCode,
          productName: item.productName,
          size: item.size,
          quantity: item.quantity,
          price: item.price,
          discount: item.discount,
          couponCode: item.couponCode,
        })),
        receiverName: document.getElementById("receiver-name").value,
        receiverPhone: document.getElementById("receiver-phone").value,
        receiverAddress: document.getElementById("receiver-address").value,
        note: document.getElementById("order-note")?.value || "",
      };

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

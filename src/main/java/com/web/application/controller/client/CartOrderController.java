package com.web.application.controller.client;

import com.web.application.entity.Order;
import com.web.application.entity.OrderDetail;
import com.web.application.entity.Product;
import com.web.application.entity.User;
import com.web.application.exception.NotFoundExp;
import com.web.application.model.request.CreateCartOrderRequest;
import com.web.application.model.request.CreateOrderRequest;
import com.web.application.repository.ProductRepository;
import com.web.application.security.CustomUserDetails;
import com.web.application.service.OrderService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.validation.Valid;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/orders")
public class CartOrderController {

    @Autowired
    private OrderService orderService;

    @Autowired
    private ProductRepository productRepository;

    @PostMapping
    public ResponseEntity<?> createOrder(@Valid @RequestBody CreateCartOrderRequest request) {
        // Get current user
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (!(authentication.getPrincipal() instanceof CustomUserDetails)) {
            return ResponseEntity.badRequest().body("User not authenticated");
        }
        User user = ((CustomUserDetails) authentication.getPrincipal()).getUser();
        long userId = user.getId();


        // Create single order with multiple items
        Order order = new Order();
        order.setReceiverName(request.getReceiverName());
        order.setReceiverPhone(request.getReceiverPhone());
        order.setReceiverAddress(request.getReceiverAddress());
        order.setNote(request.getNote());
        order.setBuyer(user);
        order.setStatus(0); // Initial status
        order.setCreatedAt(new Timestamp(System.currentTimeMillis()));
        order.setModifiedAt(new Timestamp(System.currentTimeMillis()));
        order.setCreatedBy(user);
        order.setModifiedBy(user);


        long totalOrderPrice = 0;
        List<OrderDetail> orderDetails = new ArrayList<>();

        // First check if all products are available
        for (CreateCartOrderRequest.CartItem item : request.getItems()) {
            Product product = productRepository.findByProductCode(item.getProductCode());
            if (product == null) {
                throw new NotFoundExp("Không tìm thấy sản phẩm với mã: " + item.getProductCode());
            }
            
            // Check if product is already in another active order
            int size = Integer.parseInt(item.getSize());
            boolean isProductAvailable = orderService.isProductAvailableForOrder(product.getId(), size);
            if (!isProductAvailable) {
                throw new NotFoundExp("Sản phẩm " + product.getName() + " với size " + item.getSize() + " hiện không có sẵn");
            }
        }
        
        // If all products are available, create order details
        for (CreateCartOrderRequest.CartItem item : request.getItems()) {
            Product product = productRepository.findByProductCode(item.getProductCode());
            System.out.println("product: " + item);
            OrderDetail detail = new OrderDetail();
            detail.setOrder(order);
            detail.setProduct(product);
            detail.setSize(Integer.parseInt(item.getSize()));
            detail.setQuantity(item.getQuantity());
            detail.setProductPrice(item.getPrice());
            detail.setCouponCode(item.getCouponCode() != null ? item.getCouponCode() : "");
            detail.setDiscount(item.getDiscount() != null ? item.getDiscount() : 0L);
            
            orderDetails.add(detail);
            totalOrderPrice += (item.getPrice() - (item.getDiscount() != null ? item.getDiscount() : 0)) * item.getQuantity();
        }
        
        order.setTotalPrice(totalOrderPrice);
        order.setOrderDetails(orderDetails);
        
        Order savedOrder = orderService.createOrder(order, userId);
        
        Map<String, Object> response = new HashMap<>();
        response.put("orderId", savedOrder.getId());
        return ResponseEntity.ok(response);
    }
}

package com.web.application.controller.admin;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import com.web.application.config.Contant;
import com.web.application.dto.OrderDetailDTO;
import com.web.application.dto.OrderInfoDTO;
import com.web.application.dto.ShortProductInfoDTO;
import com.web.application.entity.Order;
import com.web.application.entity.Promotion;
import com.web.application.entity.User;
import com.web.application.exception.BadRequestExp;
import com.web.application.model.request.CreateOrderRequest;
import com.web.application.model.request.UpdateDetailOrder;
import com.web.application.model.request.UpdateStatusOrderRequest;
import com.web.application.security.CustomUserDetails;
import com.web.application.service.OrderService;
import com.web.application.service.ProductService;
import com.web.application.service.PromotionService;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;

import javax.validation.Valid;
import java.util.List;
import java.util.Map;
import java.util.HashMap;
import java.util.stream.Collectors;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;

class ErrorResponse {
	private int code;
	private String message;

	public ErrorResponse(int code, String message) {
		this.code = code;
		this.message = message;
	}

	public int getCode() {
		return code;
	}

	public String getMessage() {
		return message;
	}
}

@Controller
public class OrderController {

	@Autowired
	private OrderService orderService;

	@Autowired
	private ProductService productService;

	@Autowired
	private PromotionService promotionService;

	@Autowired
	private ObjectMapper objectMapper;

	@GetMapping("/admin/orders")
	public String getListOrderPage(Model model, @RequestParam(defaultValue = "", required = false) String id,
			@RequestParam(defaultValue = "", required = false) String name,
			@RequestParam(defaultValue = "", required = false) String phone,
			@RequestParam(defaultValue = "", required = false) String status,
			@RequestParam(defaultValue = "", required = false) String product,
			@RequestParam(defaultValue = "1") Integer page) {

		// Lấy danh sách sản phẩm
		List<ShortProductInfoDTO> productList = productService.getListProduct();
		model.addAttribute("productList", productList);

		// Lấy danh sách đơn hàng
		Page<Order> orderPage = orderService.adminGetListOrders(id, name, phone, status, product, page);
		model.addAttribute("orderPage", orderPage.getContent());
		model.addAttribute("totalPages", orderPage.getTotalPages());
		model.addAttribute("currentPage", orderPage.getPageable().getPageNumber() + 1);

		return "admin/order/list";
	}

	@GetMapping("/admin/orders/create")
	public String createOrderPage(Model model) {

		// Get list product
		List<ShortProductInfoDTO> products = productService.getAvailableProducts();
		model.addAttribute("products", products);

		// Get list size
		model.addAttribute("sizeVn", Contant.SIZE_VN);

		// //Get list valid promotion
		List<Promotion> promotions = promotionService.getAllValidPromotion();
		model.addAttribute("promotions", promotions);
		return "admin/order/create";
	}

	@PostMapping("/api/admin/orders")
	public ResponseEntity<Object> createOrder(@Valid @RequestBody CreateOrderRequest createOrderRequest) {
		try {
			// Validate request
			if (createOrderRequest == null || createOrderRequest.getItems() == null || createOrderRequest.getItems().isEmpty()) {
				return ResponseEntity.badRequest()
						.body(new ErrorResponse(HttpStatus.BAD_REQUEST.value(), "Order must contain at least one product"));
			}

			// Get current admin user
			User user = ((CustomUserDetails) SecurityContextHolder.getContext().getAuthentication().getPrincipal())
					.getUser();

			// Create order
			Order order = orderService.createOrderAdmin(createOrderRequest, user.getId());

			// Return success response
			return ResponseEntity.ok(order.getId());
		} catch (BadRequestExp e) {
			return ResponseEntity.badRequest()
					.body(new ErrorResponse(HttpStatus.BAD_REQUEST.value(), e.getMessage()));
		} catch (Exception e) {
			return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
					.body(new ErrorResponse(HttpStatus.INTERNAL_SERVER_ERROR.value(),
							"Error creating order: " + e.getMessage()));
		}
	}

	@GetMapping("/admin/orders/update/{id}")
	public String updateOrderPage(Model model, @PathVariable long id) {
		Order order = orderService.findOrderById(id);
		model.addAttribute("order", order);

		// Convert order details to JSON string
		try {
			// Create a simplified version of order details for JSON
			List<Map<String, Object>> simplifiedDetails = order.getOrderDetails().stream()
					.map(detail -> {
						Map<String, Object> map = new HashMap<>();
						map.put("id", detail.getId());
						map.put("productId", detail.getProduct().getId());
						map.put("productName", detail.getProduct().getName());
						map.put("size", detail.getSize());
						map.put("quantity", detail.getQuantity());
						map.put("price", detail.getProductPrice());
						return map;
					})
					.collect(Collectors.toList());

			String orderDetailsJson = objectMapper.writeValueAsString(simplifiedDetails);
			model.addAttribute("orderDetailsJson", orderDetailsJson);
		} catch (JsonProcessingException e) {
			e.printStackTrace();
		}

		if (order.getStatus() == Contant.ORDER_STATUS) {
			// Get list product to select
			List<ShortProductInfoDTO> products = productService.getAvailableProducts();
			model.addAttribute("products", products);

			// Get list valid promotion
			List<Promotion> promotions = promotionService.getAllValidPromotion();
			model.addAttribute("promotions", promotions);

			// Check size availability for each product in the order
			if (order.getOrderDetails() != null && !order.getOrderDetails().isEmpty()) {
				List<Boolean> sizeAvailabilityList = order.getOrderDetails().stream()
						.map(detail -> productService.checkProductSizeAvailable(
								detail.getProduct().getId(),
								detail.getSize()))
						.toList();
				model.addAttribute("sizeAvailabilityList", sizeAvailabilityList);
			}

			// Add size range for product selection
			model.addAttribute("sizeVn", Contant.SIZE_VN);
		}

		return "admin/order/edit";
	}

	@PutMapping("/api/admin/orders/update-detail/{id}")
	public ResponseEntity<Object> updateDetailOrder(@Valid @RequestBody UpdateDetailOrder detailOrder,
			@PathVariable long id) {
		User user = ((CustomUserDetails) SecurityContextHolder.getContext().getAuthentication().getPrincipal())
				.getUser();
		orderService.updateDetailOrder(detailOrder, id, user.getId());
		return ResponseEntity.ok("Cập nhật thành công");
	}

	@PutMapping("/api/admin/orders/update-status/{id}")
	public ResponseEntity<Object> updateStatusOrder(
			@Valid @RequestBody UpdateStatusOrderRequest updateStatusOrderRequest, @PathVariable long id) {
		User user = ((CustomUserDetails) SecurityContextHolder.getContext().getAuthentication().getPrincipal())
				.getUser();
		orderService.updateStatusOrder(updateStatusOrderRequest, id, user.getId());
		return ResponseEntity.ok("Cập nhật trạng thái thành công");
	}

	@PutMapping("/api/admin/orders/{id}/status")
	public ResponseEntity<Object> updateOrderStatus(@PathVariable long id,
			@Valid @RequestBody UpdateStatusOrderRequest updateStatusOrderRequest) {
		User user = ((CustomUserDetails) SecurityContextHolder.getContext().getAuthentication().getPrincipal())
				.getUser();
		orderService.updateStatusOrder(updateStatusOrderRequest, id, user.getId());
		return ResponseEntity.ok("Cập nhật trạng thái thông");
	}

	@GetMapping("/tai-khoan/lich-su-giao-dich")
	public String getOrderHistoryPage(Model model) {

		// Get list order pending
		User user = ((CustomUserDetails) SecurityContextHolder.getContext().getAuthentication().getPrincipal())
				.getUser();
		List<OrderInfoDTO> orderList = orderService.getListOrderOfPersonByStatus(Contant.ORDER_STATUS, user.getId());
		model.addAttribute("orderList", orderList);

		return "shop/order_history";
	}

	@GetMapping("/api/get-order-list")
	public ResponseEntity<Object> getListOrderByStatus(@RequestParam int status) {
		// Validate status
		if (!Contant.LIST_ORDER_STATUS.contains(status)) {
			throw new BadRequestExp("Trạng thái đơn hàng không hợp lệ");
		}

		User user = ((CustomUserDetails) SecurityContextHolder.getContext().getAuthentication().getPrincipal())
				.getUser();
		List<OrderInfoDTO> orders = orderService.getListOrderOfPersonByStatus(status, user.getId());

		return ResponseEntity.ok(orders);
	}

	@GetMapping("/tai-khoan/lich-su-giao-dich/{id}")
	public String getDetailOrderPage(Model model, @PathVariable int id) {
		User user = ((CustomUserDetails) SecurityContextHolder.getContext().getAuthentication().getPrincipal())
				.getUser();
		OrderDetailDTO order = orderService.userGetDetailById(id, user.getId());
		if (order == null) {
			return "error/404";
		}
		System.out.println(order.getTotalPrice());
		model.addAttribute("order", order);

		if (order.getStatus() == Contant.ORDER_STATUS) {
			model.addAttribute("canCancel", true);
		} else {
			model.addAttribute("canCancel", false);
		}
		if (order.getStatus() == Contant.COMPLETED_STATUS) {
			model.addAttribute("canReturn", true);
		} else {
			model.addAttribute("canReturn", false);
		}
		return "shop/order-detail";
	}

	@PostMapping("/api/return-order/{id}")
	public ResponseEntity<Object> returnOrder(@PathVariable long id,
			@Valid @RequestBody UpdateStatusOrderRequest updateStatusOrderRequest) {
		User user = ((CustomUserDetails) SecurityContextHolder.getContext().getAuthentication().getPrincipal())
				.getUser();

		orderService.userReturnOrder(id, user.getId(), updateStatusOrderRequest);

		return ResponseEntity.ok("Trả đơn hàng thành công");
	}

	@PostMapping("/api/cancel-order/{id}")
	public ResponseEntity<Object> cancelOrder(@PathVariable long id,
			@Valid @RequestBody UpdateStatusOrderRequest updateStatusOrderRequest) {
		User user = ((CustomUserDetails) SecurityContextHolder.getContext().getAuthentication().getPrincipal())
				.getUser();

		orderService.userCancelOrder(id, user.getId(), updateStatusOrderRequest);

		return ResponseEntity.ok("Hủy đơn hàng thành công");
	}

	@DeleteMapping("/api/admin/orders/{orderId}/details/{detailId}")
	@ResponseBody
	public ResponseEntity<?> removeOrderDetail(@PathVariable long orderId, @PathVariable long detailId) {
		try {
			orderService.removeOrderDetail(orderId, detailId);
			return ResponseEntity.ok().build();
		} catch (Exception e) {
			return ResponseEntity.badRequest().body(e.getMessage());
		}
	}

}

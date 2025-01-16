package com.web.application.service.impl;

import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Component;

import com.web.application.config.Contant;
import com.web.application.dto.OrderDetailDTO;
import com.web.application.dto.OrderInfoDTO;
import com.web.application.entity.Order;
import com.web.application.entity.OrderDetail;
import com.web.application.entity.Product;
import com.web.application.entity.ProductSize;
import com.web.application.entity.Promotion;
import com.web.application.entity.Statistic;
import com.web.application.entity.User;
import com.web.application.exception.BadRequestExp;
import com.web.application.exception.InternalServerExp;
import com.web.application.exception.NotFoundExp;
import com.web.application.model.mapper.OrderMapper;
import com.web.application.model.request.CreateOrderRequest;
import com.web.application.model.request.UpdateDetailOrder;
import com.web.application.model.request.UpdateStatusOrderRequest;
import com.web.application.repository.OrderDetailRepository;
import com.web.application.repository.OrderRepository;
import com.web.application.repository.ProductRepository;
import com.web.application.repository.ProductSizeRepository;
import com.web.application.repository.StatisticRepository;
import com.web.application.service.OrderService;
import com.web.application.service.PromotionService;

@Component
public class OrderServiceImpl implements OrderService {

	@Autowired
	private ProductRepository productRepository;

	@Autowired
	private ProductSizeRepository productSizeRepository;

	@Autowired
	private OrderRepository orderRepository;

	@Autowired
	private PromotionService promotionService;

	@Autowired
	private StatisticRepository statisticRepository;

	@Autowired
	private OrderDetailRepository orderDetailRepository;

	@Override
	public Page<Order> adminGetListOrders(String id, String name, String phone, String status, String product,
			int page) {
		page--;
		if (page < 0) {
			page = 0;
		}
		Pageable pageable = PageRequest.of(page, Contant.LIMIT_ORDER);
		Page<Order> returnPage = orderRepository.adminGetListOrders(id, name, phone, status, product, pageable);
		// Return page
		System.out.println("returnPage: " + returnPage);
		// print params
		System.out.println("id: " + id);
		System.out.println("name: " + name);
		System.out.println("phone: " + phone);
		System.out.println("status: " + status);
		System.out.println("product: " + product);
		System.out.println("page: " + page);
		return returnPage;
	}

	@Override
	public Order createOrderAdmin(CreateOrderRequest createOrderRequest, long userId) {
		// Create new order
		Order order = new Order();

		// Set creator
		User creator = new User();
		creator.setId(userId);
		order.setCreatedBy(creator);
		order.setModifiedBy(creator);

		// Set timestamps
		Timestamp timestamp = new Timestamp(System.currentTimeMillis());
		order.setCreatedAt(timestamp);
		order.setModifiedAt(timestamp);

		// Set order details from request
		order.setReceiverName(createOrderRequest.getReceiverName());
		order.setReceiverPhone(createOrderRequest.getReceiverPhone());
		order.setReceiverAddress(createOrderRequest.getReceiverAddress());
		order.setNote(createOrderRequest.getNote());
		order.setStatus(Contant.COUNTER_STATUS);

		// Calculate total price
		long totalPrice = 0;
		List<OrderDetail> orderDetails = new ArrayList<>();

		// Process order items
		for (CreateOrderRequest.CartItem item : createOrderRequest.getItems()) {
			// Get product
			Optional<Product> product = productRepository.findById(item.getProductId());
			if (product.isEmpty()) {
				throw new BadRequestExp("Product " + item.getProductId() + " not found");
			}

			// Validate size
			int size = Integer.parseInt(item.getSize());
			ProductSize productSize = productSizeRepository.findByProductIdAndSize(product.get().getId(), size)
					.orElseThrow(() -> new BadRequestExp(
							"Size " + size + " not available for product " + product.get().getName()));

			if (productSize.getQuantity() < item.getQuantity()) {
				throw new BadRequestExp(
						"Không đủ số luong size " + size + " trong hệ thống cho sản phẩm " + product.get().getName());
			}

			// Create order detail
			OrderDetail orderDetail = new OrderDetail();
			orderDetail.setOrder(order);
			orderDetail.setProduct(product.get());
			orderDetail.setSize(Integer.parseInt(item.getSize()));
			orderDetail.setQuantity(item.getQuantity());
			orderDetail.setProductPrice(item.getPrice());
			// Update product size quantity
			productSize.setQuantity(productSize.getQuantity() - item.getQuantity());
			productSizeRepository.save(productSize);

			orderDetails.add(orderDetail);
		}

		// Apply promotion if exists
		if (createOrderRequest.getCouponCode() != null && !createOrderRequest.getCouponCode().isEmpty()) {
			Promotion promotion = promotionService.checkPromotion(createOrderRequest.getCouponCode());
			if (promotion != null) {
				order.setDiscount(createOrderRequest.getDiscount());
				order.setCouponCode(createOrderRequest.getCouponCode());
				order.setPromotion(promotion);
			}
		}

		order.setOrderDetails(orderDetails);

		// Save order with cascade
		order = orderRepository.save(order);

		// Calculate total price
		totalPrice = 0;
		for (OrderDetail detail : order.getOrderDetails()) {
			totalPrice += detail.getProductPrice()
					* detail.getQuantity();
		}
		order.setTotalPrice(totalPrice);
		orderRepository.save(order);

		return order;
	}

	@Override
	public Order createOrder(Order order, long userId) {
		// log info
		System.out.println("createOrderRequest: " + order);
		System.out.println("userId: " + userId);

		// Validate and get user
		User user = new User();
		user.setId(userId);

		// Set buyer and creator
		order.setCreatedBy(user);
		order.setBuyer(user);
		order.setStatus(Contant.PENDING_CONFIRM_STATUS);

		// Save order first to get order ID
		Order savedOrder = orderRepository.save(order);

		// find promotion
		if (order.getCouponCode() != null && !order.getCouponCode().isEmpty()) {
            Promotion promotion = promotionService.checkPromotion(order.getCouponCode());
            if (promotion != null) {
                order.setPromotion(promotion);
            }
        }
		System.out.println(order.getDiscount());
		System.out.println(order.getCouponCode());

		// Now validate and process each order detail
		for (OrderDetail detail : order.getOrderDetails()) {
			// Validate product exists
			Optional<Product> product = productRepository.findById(String.valueOf(detail.getProduct().getId()));
			if (product.isEmpty()) {
				throw new NotFoundExp("Sản phẩm không tồn tại!");
			}

			// Validate size
			ProductSize productSize = productSizeRepository.checkProductAndSizeAvailable(
					String.valueOf(detail.getProduct().getId()),
					detail.getSize());
			if (productSize == null) {
				throw new BadRequestExp("Size giày sản phẩm tạm hết, Vui lòng chọn sản phẩm khác!");
			}

			// Validate product price
			if (product.get().getSalePrice() != detail.getProductPrice()) {
				throw new BadRequestExp("Giá sản phẩm thay đổi, Vui lòng đặt hàng lại!");
			}

			// Set the saved order reference and validated product
			detail.setOrder(savedOrder);
			detail.setProduct(product.get());
		}

		// Save again to persist order details
		order = orderRepository.save(savedOrder);

		// Calculate total price
		long totalPrice = 0;
		for (OrderDetail detail : order.getOrderDetails()) {
			totalPrice += detail.getProductPrice() * detail.getQuantity();
		}

		// Apply discount if promotion exists
		if (order.getPromotion() != null) {
			totalPrice -= order.getDiscount();
		}

		order.setTotalPrice(totalPrice);
		orderRepository.save(order);

		return order;
	}

	@Override
	public void updateDetailOrder(UpdateDetailOrder updateDetailOrder, long id, long userId) {
		Optional<Order> rs = orderRepository.findById(id);
		if (rs.isEmpty()) {
			throw new NotFoundExp("Đơn hàng không tồn tại");
		}
		Order order = rs.get();

		if (order.getStatus() != Contant.ORDER_STATUS) {
			throw new BadRequestExp("Chỉ cập nhật đơn hàng ở trạng thái chờ lấy hàng");
		}

		// Validate product exists
		Optional<Product> product = productRepository.findById(updateDetailOrder.getProductId());
		if (product.isEmpty()) {
			throw new BadRequestExp("Sản phẩm không tồn tại");
		}

		// Validate product price
		if (product.get().getSalePrice() != updateDetailOrder.getProductPrice()) {
			throw new BadRequestExp("Giá sản phẩm thay đổi vui lòng đặt hàng lại");
		}

		// Validate product size
		ProductSize productSize = productSizeRepository.checkProductAndSizeAvailable(
				updateDetailOrder.getProductId(),
				updateDetailOrder.getSize());
		if (productSize == null) {
			throw new BadRequestExp("Size giày sản phẩm tạm hết, Vui lòng chọn sản phẩm khác");
		}

		// Handle promotion if provided
		if (updateDetailOrder.getCouponCode() != null && !updateDetailOrder.getCouponCode().isEmpty()) {
			Promotion promotion = promotionService.checkPromotion(updateDetailOrder.getCouponCode());
			if (promotion == null) {
				throw new NotFoundExp("Mã khuyến mãi không tồn tại hoặc chưa được kích hoạt");
			}
			order.setPromotion(promotion);
			order.setCouponCode(updateDetailOrder.getCouponCode());
			order.setDiscount(promotion.getDiscountValue());
		}

		// Update order details
		if (order.getOrderDetails().isEmpty()) {
			// Create new order detail if none exists
			OrderDetail detail = new OrderDetail();
			detail.setOrder(order);
			detail.setProduct(product.get());
			detail.setSize(updateDetailOrder.getSize());
			detail.setProductPrice(updateDetailOrder.getProductPrice());
			detail.setQuantity(1); // Default quantity
			detail.setSubtotal(updateDetailOrder.getProductPrice());

			List<OrderDetail> details = new ArrayList<>();
			details.add(detail);
			order.setOrderDetails(details);
		} else {
			// add new detail
			OrderDetail detail = new OrderDetail();
			detail.setOrder(order);
			detail.setProduct(product.get());
			detail.setSize(updateDetailOrder.getSize());
			detail.setProductPrice(updateDetailOrder.getProductPrice());
			detail.setQuantity(1);

			// save detail to db
			orderDetailRepository.save(detail);

			List<OrderDetail> details = order.getOrderDetails();
			details.add(detail);
			order.setOrderDetails(details);
		}

		// Save order to trigger price calculation
		orderRepository.save(order);

		// Update order
		order.setModifiedAt(new Timestamp(System.currentTimeMillis()));
		order.setTotalPrice(updateDetailOrder.getTotalPrice());
		order.setStatus(Contant.ORDER_STATUS);

		User user = new User();
		user.setId(userId);
		order.setModifiedBy(user);

		try {
			// calculate total price
			long totalPrice = 0;
			for (OrderDetail detail : order.getOrderDetails()) {
				totalPrice += detail.getSubtotal();
			}
			order.setTotalPrice(totalPrice);
			orderRepository.save(order);
		} catch (Exception e) {
			throw new InternalServerExp("Lỗi khi cập nhật");
		}
	}

	@Override
	public Order findOrderById(long id) {
		Order order = orderRepository.findById(id)
				.orElseThrow(() -> new NotFoundExp("Order not found with id " + id));
		order.getCouponCode();
		order.getPromotion();
		// Initialize the orderDetails collection and product for each detail
		order.getOrderDetails().forEach(detail -> {
			detail.getProduct().getName(); // Force initialization of product
		});

		return order;
	}

	@Override
	public void updateStatusOrder(UpdateStatusOrderRequest updateStatusOrderRequest, long orderId, long userId) {
		Optional<Order> rs = orderRepository.findById(orderId);
		if (rs.isEmpty()) {
			throw new NotFoundExp("Đơn hàng không tồn tại");
		}
		Order order = rs.get();

		// Kiểm tra trạng thái của đơn hàng
		boolean check = false;
		if (order.getStatus() == Contant.PENDING_CONFIRM_STATUS) {
			check = true;
			// Đơn hàng ở trạng thái chờ xác nhận
			if (updateStatusOrderRequest.getStatus() == Contant.PENDING_CONFIRM_STATUS) {
				// Không cần làm gì cả
			} else if (updateStatusOrderRequest.getStatus() == Contant.ORDER_STATUS) {
				// Chuyển sang trạng thái chờ lấy hàng
			} else if (updateStatusOrderRequest.getStatus() == Contant.CANCELED_STATUS) {
				// Hủy đơn hàng
			} else {
				throw new BadRequestExp("Không thể chuyển sang trạng thái này");
			}
		} else if (order.getStatus() == Contant.ORDER_STATUS) {
			check = true;
			// Đơn hàng ở trạng thái chờ lấy hàng
			if (updateStatusOrderRequest.getStatus() == Contant.ORDER_STATUS) {
				// Không cần làm gì cả
			} else if (updateStatusOrderRequest.getStatus() == Contant.DELIVERY_STATUS) {
				// Trừ đi một sản phẩm
				for (OrderDetail detail : order.getOrderDetails()) {
					productSizeRepository.minusOneProductBySize(
							String.valueOf(detail.getProduct().getId()),
							detail.getSize(), detail.getQuantity());
				}
			} else if (updateStatusOrderRequest.getStatus() == Contant.COMPLETED_STATUS) {
				// Trừ đi một sản phẩm và cộng một sản phẩm vào sản phẩm đã bán và cộng tiền
				for (OrderDetail detail : order.getOrderDetails()) {
					productSizeRepository.minusOneProductBySize(
							String.valueOf(detail.getProduct().getId()),
							detail.getSize(), detail.getQuantity());
					productRepository.plusOneProductTotalSold(detail.getProduct().getId());
				}
				statistic(order.getTotalPrice(), getTotalQuantity(order), order);
			} else if (updateStatusOrderRequest.getStatus() != Contant.CANCELED_STATUS) {
				throw new BadRequestExp("Không thế chuyển sang trạng thái này");
			}
		} else if (order.getStatus() == Contant.DELIVERY_STATUS) {
			check = true;
			// Đơn hàng ở trạng thái đang vận chuyển
			if (updateStatusOrderRequest.getStatus() == Contant.COMPLETED_STATUS) {
				// Cộng một sản phẩm vào sản phẩm đã bán và cộng tiền
				for (OrderDetail detail : order.getOrderDetails()) {
					productRepository.plusOneProductTotalSold(detail.getProduct().getId());
				}
				statistic(order.getTotalPrice(), getTotalQuantity(order), order);
			} else if (updateStatusOrderRequest.getStatus() == Contant.RETURNED_STATUS) {
				// Cộng một sản phẩm đã bị trừ
				for (OrderDetail detail : order.getOrderDetails()) {
					productSizeRepository.plusOneProductBySize(
							String.valueOf(detail.getProduct().getId()),
							detail.getSize(), detail.getQuantity());
				}
			} else if (updateStatusOrderRequest.getStatus() == Contant.CANCELED_STATUS) {
				// Cộng lại một sản phẩm đã bị trừ
				for (OrderDetail detail : order.getOrderDetails()) {
					productSizeRepository.plusOneProductBySize(
							String.valueOf(detail.getProduct().getId()),
							detail.getSize(), detail.getQuantity());
				}
			} else if (updateStatusOrderRequest.getStatus() != Contant.DELIVERY_STATUS) {
				throw new BadRequestExp("Không thế chuyển sang trạng thái này");
			}
		} else if (order.getStatus() == Contant.CANCELED_STATUS) {
			check = true;
			// Đơn hàng đang ở trạng thái đã hủy
			if (updateStatusOrderRequest.getStatus() == Contant.RETURNED_STATUS) {
				// Cộng một sản phẩm đã bị trừ và trừ đi một sản phẩm đã bán và trừ số tiền
				for (OrderDetail detail : order.getOrderDetails()) {
					productSizeRepository.plusOneProductBySize(
							String.valueOf(detail.getProduct().getId()),
							detail.getSize(), detail.getQuantity());
					productRepository.minusOneProductTotalSold(detail.getProduct().getId());
				}
				updateStatistic(order.getTotalPrice(), getTotalQuantity(order), order);
			} else if (updateStatusOrderRequest.getStatus() != Contant.COMPLETED_STATUS) {
				throw new BadRequestExp("Không thế chuyển sang trạng thái này");
			}
		}

		if (!check) {
			if (order.getStatus() != updateStatusOrderRequest.getStatus()) {
				throw new BadRequestExp("Không thế chuyển đơn hàng sang trạng thái này");
			}
		}

		User user = new User();
		user.setId(userId);
		order.setModifiedBy(user);
		order.setModifiedAt(new Timestamp(System.currentTimeMillis()));
		order.setNote(updateStatusOrderRequest.getNote());
		order.setStatus(updateStatusOrderRequest.getStatus());

		try {
			orderRepository.save(order);
		} catch (Exception e) {
			throw new InternalServerExp("Lỗi khi cập nhật trạng thái");
		}
	}

	@Override
	public List<OrderInfoDTO> getListOrderOfPersonByStatus(int status, long userId) {
		List<Object[]> list = orderRepository.getListOrderOfPersonByStatus(status, userId);
		List<OrderInfoDTO> result = OrderMapper.mapToOrderInfoDTO(list);
		return result;
	}

	@Override
	public OrderDetailDTO userGetDetailById(long id, long userId) {
		List<Object[]> list = orderRepository.userGetDetailById(id, userId);
		OrderDetailDTO order = OrderMapper.mapToOrderDetailDTO(list);
		if (order == null) {
			throw new NotFoundExp("Đơn hàng không tồn tại");
		}

		// Set status text based on order status
		switch (order.getStatus()) {
			case Contant.PENDING_CONFIRM_STATUS:
				order.getOrderItems().forEach(item -> item.setStatusText("Chờ xác nhận"));
				break;
			case Contant.ORDER_STATUS:
				order.getOrderItems().forEach(item -> item.setStatusText("Chờ lấy hàng"));
				break;
			case Contant.DELIVERY_STATUS:
				order.getOrderItems().forEach(item -> item.setStatusText("Đang giao hàng"));
				break;
			case Contant.COMPLETED_STATUS:
				order.getOrderItems().forEach(item -> item.setStatusText("Đã giao hàng"));
				break;
			case Contant.CANCELED_STATUS:
				order.getOrderItems().forEach(item -> item.setStatusText("Đã hủy"));
				break;
			case Contant.RETURNED_STATUS:
				order.getOrderItems().forEach(item -> item.setStatusText("Đã trả hàng"));
				break;
			default:
				order.getOrderItems().forEach(item -> item.setStatusText(""));
				break;
		}
		return order;
	}

	@Override
	public void userCancelOrder(long id, long userId, UpdateStatusOrderRequest updateStatusOrderRequest) {
		Optional<Order> rs = orderRepository.findById(id);
		if (rs.isEmpty()) {
			throw new NotFoundExp("Đơn hàng không tồn tại");
		}
		Order order = rs.get();
		if (order.getBuyer().getId() != userId) {
			throw new BadRequestExp("Bạn không phải chủ nhân đơn hàng");
		}
		if (order.getStatus() != Contant.PENDING_CONFIRM_STATUS && order.getStatus() != Contant.ORDER_STATUS) {
			throw new BadRequestExp(
					"Trạng thái đơn hàng không phù hợp để hủy. Vui lòng liên hệ với shop để được hỗ trợ");
		}
		order.setNote(updateStatusOrderRequest.getNote());
		order.setStatus(Contant.CANCELED_STATUS);
		orderRepository.save(order);
	}

	@Override
	public long getCountOrder() {
		return orderRepository.count();
	}

	public boolean isProductAvailableForOrder(String productId, int size) {
		// First check if the product has the requested size available
		Optional<ProductSize> productSize = productSizeRepository.findByProductIdAndSize(productId, size);
		System.out.println("productSize " + productSize);
		if (productSize.isEmpty() || productSize.get().getQuantity() <= 0) {
			return false;
		}
		System.out.println("productSize2 " + productSize);

		// Then check if the product is not in any active order (status = 0)
		List<OrderDetail> activeOrderDetails = orderDetailRepository.findByProductIdAndSizeAndOrderStatus(productId,
				size, 0);
		System.out.println("activeOrderDetails " + activeOrderDetails);
		if (!activeOrderDetails.isEmpty()) {
			// If the product is in active orders, check if there's still enough quantity
			int reservedQuantity = activeOrderDetails.stream()
					.mapToInt(OrderDetail::getQuantity)
					.sum();
			return productSize.get().getQuantity() > reservedQuantity;
		}
		System.out.println("productSize3 " + productSize);

		return true;
	}

	public void statistic(long amount, int quantity, Order order) {
		Statistic statistic = statisticRepository.findByCreatedAT();
		if (statistic != null) {
			statistic.setOrder(order);
			statistic.setSales(statistic.getSales() + amount);
			statistic.setQuantity(statistic.getQuantity() + quantity);

			// Calculate total cost from all order details
			long totalCost = 0;
			for (OrderDetail detail : order.getOrderDetails()) {
				totalCost += detail.getQuantity() * detail.getProduct().getPrice();
			}
			statistic.setProfit(statistic.getSales() - totalCost);

			statisticRepository.save(statistic);
		} else {
			Statistic statistic1 = new Statistic();
			statistic1.setOrder(order);
			statistic1.setSales(amount);
			statistic1.setQuantity(quantity);

			// Calculate total cost from all order details
			long totalCost = 0;
			for (OrderDetail detail : order.getOrderDetails()) {
				totalCost += detail.getQuantity() * detail.getProduct().getPrice();
			}
			statistic1.setProfit(amount - totalCost);

			statistic1.setCreatedAt(new Timestamp(System.currentTimeMillis()));
			statisticRepository.save(statistic1);
		}
	}

	public void updateStatistic(long amount, int quantity, Order order) {
		Statistic statistic = statisticRepository.findByCreatedAT();
		if (statistic != null) {
			statistic.setOrder(order);
			statistic.setSales(statistic.getSales() - amount);
			statistic.setQuantity(statistic.getQuantity() - quantity);

			// Calculate total cost from all order details
			long totalCost = 0;
			for (OrderDetail detail : order.getOrderDetails()) {
				totalCost += detail.getQuantity() * detail.getProduct().getPrice();
			}
			statistic.setProfit(statistic.getSales() - totalCost);

			statisticRepository.save(statistic);
		}
	}

	@Override
	public void userReturnOrder(long id, long userId, UpdateStatusOrderRequest updateStatusOrderRequest) {
		Optional<Order> rs = orderRepository.findById(id);
		if (rs.isEmpty()) {
			throw new NotFoundExp("Đơn hàng không tồn tại");
		}
		Order order = rs.get();
		if (order.getBuyer().getId() != userId) {
			throw new BadRequestExp("Bạn không phải chủ nhân đơn hàng");
		}
		if (order.getStatus() != Contant.COMPLETED_STATUS) {
			throw new BadRequestExp(
					"Trạng thái đơn hàng không phù hợp để hủy. Vui lòng liên hệ với shop để được hỗ trợ");
		}
		order.setNote(updateStatusOrderRequest.getNote());
		order.setStatus(Contant.RETURNED_STATUS);
		orderRepository.save(order);
	}

	@Override
	public void removeOrderDetail(long orderId, long detailId) {
		Order order = findOrderById(orderId);
		if (order == null) {
			throw new NotFoundExp("Không tìm thấy đơn hàng");
		}

		OrderDetail detailToRemove = null;
		for (OrderDetail detail : order.getOrderDetails()) {
			if (detail.getId() == detailId) {
				detailToRemove = detail;
				break;
			}
		}

		if (detailToRemove == null) {
			throw new NotFoundExp("Không tìm thấy chi tiết đơn hàng");
		}

		order.getOrderDetails().remove(detailToRemove);
		orderDetailRepository.delete(detailToRemove);

		// Recalculate total price
		long totalPrice = 0;
		for (OrderDetail detail : order.getOrderDetails()) {
			totalPrice += (detail.getProductPrice()) * detail.getQuantity();
		}
		order.setTotalPrice(totalPrice);
		orderRepository.save(order);
	}

	private int getTotalQuantity(Order order) {
		return order.getOrderDetails().stream()
				.mapToInt(OrderDetail::getQuantity)
				.sum();
	}

	private boolean isValidProductSize(Product product, int size) {
		// Check if size is within valid range
		if (size < 35 || size > 42) {
			return false;
		}

		// Check if size exists in product sizes
		ProductSize productSize = productSizeRepository.checkProductAndSizeAvailable(
				String.valueOf(product.getId()),
				size);
		return productSize != null;
	}
}

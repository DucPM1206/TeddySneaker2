package com.web.application.repository;

import com.web.application.entity.OrderDetail;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface OrderDetailRepository extends JpaRepository<OrderDetail, Long> {
    @Query("SELECT od FROM OrderDetail od WHERE od.product.id = :productId AND od.size = :size AND od.order.status = :status")
    List<OrderDetail> findByProductIdAndSizeAndOrderStatus(String productId, int size, int status);
}

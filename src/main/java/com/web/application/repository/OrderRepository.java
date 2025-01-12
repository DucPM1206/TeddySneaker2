package com.web.application.repository;

import com.web.application.dto.OrderDetailDTO;
import com.web.application.dto.OrderInfoDTO;
import com.web.application.entity.Order;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface OrderRepository extends JpaRepository<Order, Long> {

        @Query(value = "SELECT o.id, o.total_price, " +
                        "(SELECT JSON_QUERY(" +
                        "    '[' + STRING_AGG(" +
                        "        JSON_QUERY(" +
                        "            JSON_MODIFY(" +
                        "                JSON_MODIFY(" +
                        "                    JSON_MODIFY(" +
                        "                        JSON_MODIFY(" +
                        "                            JSON_MODIFY('{}', '$.productName', p.name)," +
                        "                            '$.productImage', JSON_VALUE(p.images, '$[0]'))," +
                        "                        '$.size', CAST(od.size AS NVARCHAR))," +
                        "                    '$.quantity', CAST(od.quantity AS NVARCHAR))," +
                        "                '$.subtotal', CAST(od.subtotal AS NVARCHAR))" +
                        "        ), ',') + ']'" +
                        "    ) AS items" +
                        " FROM order_details od " +
                        " JOIN Product p ON p.id = od.product_id " +
                        " WHERE od.order_id = o.id) AS items " +
                        "FROM [Orders] o " +
                        "WHERE o.status = ?1 AND o.buyer = ?2 " +
                        "GROUP BY o.id, o.total_price", nativeQuery = true)
        List<Object[]> getListOrderOfPersonByStatus(int status, long userId);

        @Query(value = "SELECT o.id, o.total_price, o.receiver_name, o.receiver_phone, " +
                        "o.receiver_address, o.status, " +
                        "(SELECT '[' + STRING_AGG(" +
                        "    '{' + " +
                        "    '\"productName\":\"' + p.name + '\",' + " +
                        "    '\"productImage\":\"' + JSON_VALUE(p.images, '$[0]') + '\",' + " +
                        "    '\"size\":' + CAST(od.size AS NVARCHAR) + ',' + " +
                        "    '\"quantity\":' + CAST(od.quantity AS NVARCHAR) + ',' + " +
                        "    '\"productPrice\":' + CAST(od.product_price AS NVARCHAR) + ',' + " +
                        "    '\"subtotal\":' + CAST(od.subtotal AS NVARCHAR) + " +
                        "    '}', ',') + ']' " +
                        " FROM order_details od " +
                        " JOIN product p ON p.id = od.product_id " +
                        " WHERE od.order_id = o.id) AS items " +
                        "FROM orders o " +
                        "WHERE o.id = ?1 AND o.buyer = ?2 " +
                        "GROUP BY o.id, o.total_price, o.receiver_name, o.receiver_phone, " +
                        "o.receiver_address, o.status", nativeQuery = true)
        List<Object[]> userGetDetailById(long orderId, long userId);

        @Query(value = "SELECT o FROM Order o " +
                        "LEFT JOIN FETCH o.orderDetails od " +
                        "LEFT JOIN FETCH od.product p " +
                        "WHERE (?1 IS NULL OR CAST(o.id AS string) LIKE %?1%) " +
                        "AND (?2 IS NULL OR LOWER(o.receiverName) LIKE LOWER(CONCAT('%', ?2, '%'))) " +
                        "AND (?3 IS NULL OR o.receiverPhone LIKE %?3%) " +
                        "AND (?4 IS NULL OR CAST(o.status AS string) LIKE %?4%) " +
                        "AND (?5 IS NULL OR EXISTS (SELECT 1 FROM o.orderDetails d WHERE CAST(d.product.id AS string) LIKE %?5%))")
        Page<Order> adminGetListOrders(String id, String name, String phone,
                        String status, String product, Pageable pageable);

        @Query("SELECT COUNT(DISTINCT o) FROM Order o JOIN o.orderDetails od WHERE od.product.id = ?1")
        int countByProductId(String id);
}

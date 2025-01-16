package com.web.application.entity;

import com.web.application.dto.OrderInfoDTO;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import java.util.ArrayList;
import java.util.List;

import java.sql.Timestamp;
import org.hibernate.annotations.JdbcTypeCode;
import org.hibernate.type.SqlTypes;

import com.web.application.dto.OrderDetailDTO;
import jakarta.persistence.CascadeType;
import jakarta.persistence.Column;
import jakarta.persistence.ColumnResult;
import jakarta.persistence.ConstructorResult;
import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.NamedNativeQuery;
import jakarta.persistence.OneToMany;
import jakarta.persistence.PostLoad;
import jakarta.persistence.PrePersist;
import jakarta.persistence.PreUpdate;
import jakarta.persistence.SqlResultSetMapping;
import jakarta.persistence.SqlResultSetMappings;
import jakarta.persistence.Table;
import jakarta.persistence.Transient;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;

import lombok.AllArgsConstructor;

@SqlResultSetMappings(
        value = {
                @SqlResultSetMapping(
                        name = "orderInfoDTO",
                        classes = @ConstructorResult(
                                targetClass = OrderInfoDTO.class,
                                columns = {
                                        @ColumnResult(name = "id", type = Long.class),
                                        @ColumnResult(name = "total_price", type = Long.class),
                                        @ColumnResult(name = "order_details", type = String.class)
                                }
                        )
                ),
                @SqlResultSetMapping(
                        name = "orderDetailDto",
                        classes = @ConstructorResult(
                                targetClass = OrderDetailDTO.class,
                                columns = {
                                        @ColumnResult(name = "id", type = Long.class),
                                        @ColumnResult(name = "total_price", type = Long.class),
                                        @ColumnResult(name = "receiver_name", type = String.class),
                                        @ColumnResult(name = "receiver_phone", type = String.class),
                                        @ColumnResult(name = "receiver_address", type = String.class),
                                        @ColumnResult(name = "status", type = Integer.class),
                                        @ColumnResult(name = "order_details", type = String.class)
                                }
                        )
                ),
                @SqlResultSetMapping(
                        name = "OrderInfoMapping",
                        classes = @ConstructorResult(
                                targetClass = OrderInfoDTO.class,
                                columns = {
                                        @ColumnResult(name = "id", type = Long.class),
                                        @ColumnResult(name = "total_price", type = Long.class),
                                        @ColumnResult(name = "items", type = String.class)
                                }
                        )
                )
        }
)
@NamedNativeQuery(
        name = "getListOrderOfPersonByStatus",
        resultSetMapping = "orderInfoDTO",
        query = "SELECT o.id, o.total_price, " +
                "JSON_ARRAYAGG(JSON_OBJECT(" +
                "'product_name', p.name, " +
                "'product_img', JSON_VALUE(p.images, '$[0]'), " +
                "'size', od.size, " +
                "'quantity', od.quantity, " +
                "'subtotal', od.subtotal" +
                ")) as order_details " +
                "FROM orders o " +
                "INNER JOIN order_details od ON o.id = od.order_id " +
                "INNER JOIN product p ON od.product_id = p.id " +
                "WHERE o.status = ?1 AND o.buyer_id = ?2 " +
                "GROUP BY o.id, o.total_price"
)

@NamedNativeQuery(
        name = "userGetDetailById",
        resultSetMapping = "orderDetailDto",
        query = "SELECT o.id, o.total_price, o.receiver_name, o.receiver_phone, " +
                "o.receiver_address, o.status, " +
                "JSON_ARRAYAGG(JSON_OBJECT(" +
                "'product_name', p.name, " +
                "'product_img', JSON_VALUE(p.images, '$[0]'), " +
                "'size', od.size, " +
                "'quantity', od.quantity, " +
                "'product_price', od.product_price, " +
                "'subtotal', od.subtotal" +
                ")) as order_details " +
                "FROM orders o " +
                "INNER JOIN order_details od ON o.id = od.order_id " +
                "INNER JOIN product p ON od.product_id = p.id " +
                "WHERE o.id = ?1 AND o.buyer_id = ?2 " +
                "GROUP BY o.id, o.total_price, o.receiver_name, o.receiver_phone, o.receiver_address, o.status"
)

@AllArgsConstructor
@NoArgsConstructor
@Setter
@Getter
@Entity
@Table(name = "orders")
public class Order {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private long id;

    @Column(name = "receiver_name", nullable = false)
    private String receiverName;

    @Column(name = "receiver_phone", nullable = false)
    private String receiverPhone;

    @Column(name = "receiver_address", nullable = false)
    private String receiverAddress;

    @Column(name = "note")
    private String note;

    @Column(name = "total_price", nullable = false)
    private long totalPrice;

    @Column(name = "coupon_code", insertable = false, updatable = false)
    private String couponCode;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "coupon_code", referencedColumnName = "coupon_code")
    private Promotion promotion;

    @Column(name = "discount")
    private long discount = 0;

    @Column(name = "status", nullable = false)
    private int status;

    @Column(name = "created_at", nullable = false)
    private Timestamp createdAt;

    @Column(name = "modified_at", nullable = false)
    private Timestamp modifiedAt;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "created_by", nullable = false)
    private User createdBy;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "modified_by", nullable = false)
    private User modifiedBy;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "buyer")
    private User buyer;

    @OneToMany(mappedBy = "order", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<OrderDetail> orderDetails = new ArrayList<>();

    @PrePersist
    @PreUpdate
    private void calculateTotalPrice() {
        long subtotal = 0;
        for (OrderDetail detail : orderDetails) {
            subtotal += detail.getProductPrice() * detail.getQuantity();
        }
        
        if (promotion != null) {
            this.totalPrice = subtotal - this.discount;
        } else {
            this.discount = 0;
            this.totalPrice = subtotal;
        }
    }

    // Helper methods for managing bidirectional relationship
    public void addOrderDetail(OrderDetail detail) {
        orderDetails.add(detail);
        detail.setOrder(this);
    }

    public void removeOrderDetail(OrderDetail detail) {
        orderDetails.remove(detail);
        detail.setOrder(null);
    }
}

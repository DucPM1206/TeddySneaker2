package com.web.application.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.util.List;

@Getter
@Setter
@NoArgsConstructor
public class OrderInfoDTO {
    private long id;
    private String receiverName;
    private String receiverPhone;
    private String receiverAddress;
    private String note;
    private long totalPrice;
    private int status;
    private String items;
    private String couponCode;
    private int discountType;
    private long discountValue;
    private long maximumDiscountValue;
    private List<OrderItemInfo> orderItems;

    public OrderInfoDTO(Long id, Long totalPrice, String items) {
        this.id = id;
        this.totalPrice = totalPrice;
        this.items = items;
    }

    public OrderInfoDTO(Long id, String receiverName, String receiverPhone, String receiverAddress,
                       String note, Long totalPrice, Integer status, String items,
                       String couponCode, Integer discountType, Long discountValue, Long maximumDiscountValue, List<OrderItemInfo> orderItems) {
        this.id = id;
        this.receiverName = receiverName;
        this.receiverPhone = receiverPhone;
        this.receiverAddress = receiverAddress;
        this.note = note;
        this.totalPrice = totalPrice;
        this.status = status;
        this.items = items;
        this.couponCode = couponCode;
        this.discountType = discountType;
        this.discountValue = discountValue;
        this.maximumDiscountValue = maximumDiscountValue;
        this.orderItems = orderItems;
    }

    @Getter
    @Setter
    @NoArgsConstructor
    @AllArgsConstructor
    public static class OrderItemInfo {
        private String productName;
        private String productImage;
        private String size;
        private String quantity;
        private String subtotal;
    }
}
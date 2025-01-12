package com.web.application.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.util.List;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class OrderDetailDTO {
    private long id;
    private long totalPrice;
    private String receiverName;
    private String receiverPhone;
    private String receiverAddress;
    private int status;
    private List<OrderItemDTO> orderItems;

    @Getter
    @Setter
    @NoArgsConstructor
    @AllArgsConstructor
    public static class OrderItemDTO {
        private String productName;
        private String productImage;
        private int size;
        private int quantity;
        private long productPrice;
        private long subtotal;
        private String statusText;
    }
}

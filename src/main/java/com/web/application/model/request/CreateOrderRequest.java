package com.web.application.model.request;

import com.fasterxml.jackson.annotation.JsonProperty;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

import javax.validation.constraints.*;
import java.util.ArrayList;
import java.util.List;

@AllArgsConstructor
@NoArgsConstructor
@Setter
@ToString
@Getter
public class CreateOrderRequest {

    @NotNull(message = "Receiver name cannot be empty")
    @JsonProperty("receiver_name")
    private String receiverName;

    @Pattern(regexp="(09|03|07|08|05)+([0-9]{8})\\b", message = "Điện thoại không hợp lệ")
    @JsonProperty("receiver_phone")
    private String receiverPhone;

    @NotNull(message = "Địa chỉ trống")
    @NotEmpty(message = "Địa chỉ trống")
    @JsonProperty("receiver_address")
    private String receiverAddress;

    private String note;

    @NotEmpty(message = "Order must contain at least one product")
    private List<CartItem> items = new ArrayList<>();  

    @Getter
    @Setter
    @NoArgsConstructor
    @AllArgsConstructor
    @ToString
    public static class CartItem {
        @JsonProperty("productId")
        private String productId;
        
        @JsonProperty("productCode")
        private String productCode;
        
        @JsonProperty("productName")
        private String productName;
        
        @JsonProperty("size")
        private String size;
        
        @JsonProperty("quantity")
        private int quantity;
        
        @JsonProperty("price")
        private long price;

        @JsonProperty("couponCode")
        private String couponCode;

        @JsonProperty("discount")
        private Long discount = 0L;
    }
}

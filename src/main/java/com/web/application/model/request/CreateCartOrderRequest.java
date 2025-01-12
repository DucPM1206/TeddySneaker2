package com.web.application.model.request;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

import javax.validation.constraints.NotEmpty;
import javax.validation.constraints.NotNull;
import javax.validation.constraints.Pattern;
import java.util.List;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@ToString
public class CreateCartOrderRequest {
    @NotEmpty(message = "Họ tên trống")
    @JsonProperty("receiverName")
    private String receiverName;

    @Pattern(regexp="(09|03|07|08|05)+([0-9]{8})\\b", message = "Điện thoại không hợp lệ")
    @JsonProperty("receiverPhone")
    private String receiverPhone;

    @NotNull(message = "Địa chỉ trống")
    @NotEmpty(message = "Địa chỉ trống")
    @JsonProperty("receiverAddress")
    private String receiverAddress;

    @NotNull(message = "Giỏ hàng trống")
    @NotEmpty(message = "Giỏ hàng trống")
    @JsonProperty("items")
    private List<CartItem> items;

    @JsonProperty("note")
    private String note;

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

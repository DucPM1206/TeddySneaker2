package com.web.application.helper;

import org.springframework.stereotype.Component;

@Component
public class OrderStatusHelper {
    
    public String getStatusText(int status) {
        switch (status) {
            case 0:
                return "Chờ xác nhận";
            case 1:
                return "Chờ lấy hàng";
            case 2:
                return "Đang giao hàng";
            case 3:
                return "Đã giao hàng";
            case 4:
                return "Đơn hàng đã trả lại";
            case 5:
                return "Đơn hàng đã hủy";
            default:
                return "Không xác định";
        }
    }
}

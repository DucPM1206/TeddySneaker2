package com.web.application.model.mapper;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.web.application.dto.OrderDetailDTO;
import com.web.application.dto.OrderInfoDTO;

import java.util.ArrayList;
import java.util.List;

public class OrderMapper {
    
    public static List<OrderInfoDTO> mapToOrderInfoDTO(List<Object[]> list) {
        List<OrderInfoDTO> result = new ArrayList<>();
        
        for (Object[] row : list) {
            Long id = row[0] != null ? ((Number) row[0]).longValue() : 0L;
            Long totalPrice = row[1] != null ? ((Number) row[1]).longValue() : 0L;
            String items = row[2] != null ? (String) row[2] : "[]";
            
            OrderInfoDTO dto = new OrderInfoDTO(id, totalPrice, items);
            result.add(dto);
        }
        
        return result;
    }

    public static OrderDetailDTO mapToOrderDetailDTO(List<Object[]> list) {
        if (list == null || list.isEmpty()) {
            return null;
        }

        Object[] row = list.get(0);
        OrderDetailDTO dto = new OrderDetailDTO();
        
        try {
            // Map basic order details
            dto.setId(row[0] != null ? ((Number) row[0]).longValue() : 0L);
            dto.setTotalPrice(row[1] != null ? ((Number) row[1]).longValue() : 0L);
            dto.setReceiverName(row[2] != null ? (String) row[2] : "");
            dto.setReceiverPhone(row[3] != null ? (String) row[3] : "");
            dto.setReceiverAddress(row[4] != null ? (String) row[4] : "");
            dto.setStatus(row[5] != null ? ((Number) row[5]).intValue() : 0);

            // Parse items JSON string into OrderItemDTO list
            String itemsJson = row[6] != null ? (String) row[6] : "[]";
            ObjectMapper mapper = new ObjectMapper();
            List<OrderDetailDTO.OrderItemDTO> items = mapper.readValue(itemsJson, 
                new TypeReference<List<OrderDetailDTO.OrderItemDTO>>() {});
            dto.setOrderItems(items);

        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }

        return dto;
    }
}

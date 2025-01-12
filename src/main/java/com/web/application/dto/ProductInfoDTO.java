package com.web.application.dto;

import lombok.Getter;
import lombok.Setter;

@Setter
@Getter
public class ProductInfoDTO {
    private String id;
    private String productCode;
    private String name;
    private String slug;
    private long price;
    private int views;
    private String images;
    private int totalSold;
    private long promotionPrice;
    private String description;

    public ProductInfoDTO(String id, String productCode, String name, String slug, long price, int views, String images, int totalSold, String description) {
        this.id = id;
        this.productCode = productCode;
        this.name = name;
        this.slug = slug;
        this.price = price;
        this.views = views;
        this.images = images;
        this.totalSold = totalSold;
        this.description = description;
    }
}
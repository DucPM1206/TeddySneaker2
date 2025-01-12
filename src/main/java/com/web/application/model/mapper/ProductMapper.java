package com.web.application.model.mapper;

import com.github.slugify.Slugify;
import com.web.application.dto.ProductDTO;
import com.web.application.entity.Brand;
import com.web.application.entity.Category;
import com.web.application.entity.Product;
import com.web.application.model.request.CreateProductRequest;

import java.util.ArrayList;

public class ProductMapper {
    public static ProductDTO toProductDTO(Product product) {
        ProductDTO productDTO = new ProductDTO();
        productDTO.setId(product.getId());
        productDTO.setName(product.getName());
        productDTO.setPrice(product.getPrice());
        productDTO.setSalePrice(product.getSalePrice());
        productDTO.setDescription(product.getDescription());
        productDTO.setProductImages(new ArrayList<>(product.getImages()));
        productDTO.setFeedbackImages(new ArrayList<>(product.getImageFeedback()));
        productDTO.setTotalSold(product.getTotalSold());
        productDTO.setStatus(product.getStatus());

        return productDTO;
    }

    public static Product toProduct(CreateProductRequest createProductRequest) {
        Product product = new Product();
        product.setName(createProductRequest.getName());
        product.setDescription(createProductRequest.getDescription());
        product.setPrice(createProductRequest.getPrice());
        product.setSalePrice(createProductRequest.getSalePrice());
        product.setImages(createProductRequest.getProductImages());
        product.setImageFeedback(createProductRequest.getFeedbackImages());
        product.setStatus(createProductRequest.getStatus());
        product.setProductCode(createProductRequest.getProductCode());
        //Gen slug
        Slugify slug = new Slugify();
        product.setSlug(slug.slugify(createProductRequest.getName()));
        //Brand
        Brand brand = new Brand();
        brand.setId(createProductRequest.getBrandId());
        product.setBrand(brand);
        //Category
        ArrayList<Category> categories = new ArrayList<>();
        for (Integer id : createProductRequest.getCategoryIds()) {
            Category category = new Category();
            category.setId(id);
            categories.add(category);
        }
        product.setCategories(categories);

        return product;
    }
}

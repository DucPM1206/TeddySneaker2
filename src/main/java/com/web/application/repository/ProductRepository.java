package com.web.application.repository;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import com.web.application.dto.ChartDTO;
import com.web.application.dto.ProductInfoDTO;
import com.web.application.dto.ShortProductInfoDTO;
import com.web.application.entity.Product;

import java.util.List;

@Repository
public interface ProductRepository extends JpaRepository<Product, String> {

    //Lấy sản phẩm theo tên
    Product findByName(String name);

    //Lấy sản phẩm theo mã sản phẩm
    Product findByProductCode(String productCode);

    //Lấy tất cả sản phẩm
    @Query(value = """
            SELECT pro.id, pro.product_code, pro.created_at, pro.description, pro.image_feedback, pro.images, 
                   pro.modified_at, pro.name, pro.price, pro.sale_price, pro.slug, pro.status, 
                   pro.total_sold, pro.product_view, pro.brand_id, 
                   COALESCE(SUM(ps.quantity), 0) AS total_quantity
            FROM product pro
            RIGHT JOIN (
                SELECT DISTINCT p.id, p.product_code, p.created_at, p.description, p.image_feedback, 
                       p.images, p.modified_at, p.name, p.price, p.sale_price, p.slug, p.status, 
                       p.total_sold, p.product_view, p.brand_id
                FROM product p
                INNER JOIN product_category pc ON p.id = pc.product_id
                INNER JOIN category c ON c.id = pc.category_id
                WHERE p.id LIKE CONCAT('%',?1,'%')
                  AND p.name LIKE CONCAT('%',?2,'%')
                  AND c.id LIKE CONCAT('%',?3,'%')
                  AND p.brand_id LIKE CONCAT('%',?4,'%')
            ) AS tb1 ON pro.id = tb1.id
            LEFT JOIN product_size ps ON ps.product_id = pro.id
            GROUP BY pro.id, pro.product_code, pro.name, pro.description, pro.price, pro.sale_price, 
                     pro.slug, pro.images, pro.image_feedback, pro.product_view, 
                     pro.total_sold, pro.status, pro.created_at, pro.modified_at, 
                     pro.brand_id""", nativeQuery = true)
    Page<Product> adminGetListProducts(String id, String name, String category, String brand, Long price, Long sale_price, Pageable pageable);

    //Lấy sản phẩm được bán nhiều
    @Query(nativeQuery = true,name = "getListBestSellProducts")
    List<ProductInfoDTO> getListBestSellProducts(int limit);

    //Lấy sản phẩm mới nhất
    @Query(nativeQuery = true,name = "getListNewProducts")
    List<ProductInfoDTO> getListNewProducts(int limit);

    //Lấy sản phẩm được xem nhiều
    @Query(nativeQuery = true,name = "getListViewProducts")
    List<ProductInfoDTO> getListViewProducts(int limit);

    //Lấy sản phẩm liên quan
    @Query(nativeQuery = true, name = "getRelatedProducts")
    List<ProductInfoDTO> getRelatedProducts(String id, int limit);

    //Lấy sản phẩm
    @Query(name = "getAllProduct", nativeQuery = true)
    List<ShortProductInfoDTO> getListProduct();

    //Lấy sản phẩm có sẵn size
    @Query(nativeQuery = true, name = "getAllBySizeAvailable")
    List<ShortProductInfoDTO> getAvailableProducts();

    //Trừ một sản phẩm đã bán
    @Transactional
    @Modifying
    @Query(value = "UPDATE product SET total_sold = total_sold - 1 WHERE id = ?1", nativeQuery = true)
    void minusOneProductTotalSold(String productId);

    //Cộng một sản phẩm đã bán
    @Transactional
    @Modifying
    @Query(nativeQuery = true, value = "Update product set total_sold = total_sold + 1 where id = ?1")
    void plusOneProductTotalSold(String productId);

    //Tìm kiến sản phẩm theo size
    @Query(nativeQuery = true, name = "searchProductBySize")
    List<ProductInfoDTO> searchProductBySize(List<Long> brands, List<Long> categories, long minPrice, long maxPrice, List<Integer> sizes, int limit, int offset);

    //Đếm số sản phẩm
    @Query(nativeQuery = true, value = "SELECT COUNT(DISTINCT d.id) " +
            "FROM (" +
            "SELECT DISTINCT product.id " +
            "FROM product " +
            "INNER JOIN product_category " +
            "ON product.id = product_category.product_id " +
            "WHERE product.status = 1 AND product.brand_id IN (?1) AND product_category.category_id IN (?2) " +
            "AND product.price > ?3 AND product.price < ?4) as d " +
            "INNER JOIN product_size " +
            "ON product_size.product_id = d.id " +
            "WHERE product_size.size IN (?5)")
    int countProductBySize(List<Long> brands, List<Long> categories, long minPrice, long maxPrice, List<Integer> sizes);

    //Tìm kiến sản phẩm k theo size
    @Query(nativeQuery = true, name = "searchProductAllSize")
    List<ProductInfoDTO> searchProductAllSize(List<Long> brands, List<Long> categories, long minPrice, long maxPrice, int limit, int offset);

    //Đếm số sản phẩm
    @Query(nativeQuery = true, value = "SELECT COUNT(DISTINCT product.id) " +
            "FROM product " +
            "INNER JOIN product_category " +
            "ON product.id = product_category.product_id " +
            "WHERE product.status = 1 AND product.brand_id IN (?1) AND product_category.category_id IN (?2) " +
            "AND product.price > ?3 AND product.price < ?4 ")
    int countProductAllSize(List<Long> brands, List<Long> categories, long minPrice, long maxPrice);

    //Tìm kiến sản phẩm theo tên và tên danh mục
    @Query(nativeQuery = true, name = "searchProductByKeyword")
    List<ProductInfoDTO> searchProductByKeyword(@Param("keyword") String keyword, @Param("limit") int limit, @Param("offset") int offset);

    //Đếm số sản phẩm
    @Query(nativeQuery = true, value = "SELECT count(DISTINCT product.id) " +
            "FROM product " +
            "INNER JOIN product_category " +
            "ON product.id = product_category.product_id " +
            "INNER JOIN category " +
            "ON category.id = product_category.category_id " +
            "WHERE product.status = 1 AND (product.name LIKE CONCAT('%',:keyword,'%') OR category.name LIKE CONCAT('%',:keyword,'%')) ")
    int countProductByKeyword(@Param("keyword") String keyword);

    @Query(name = "getProductOrders",nativeQuery = true)
    List<ChartDTO> getProductOrders(Pageable pageable, Integer moth, Integer year);

    @Query(value = "SELECT p.id, p.product_code, p.name, p.slug, p.sale_price AS price, " +
           "p.product_view AS views, p.total_sold, p.description, " +
           "JSON_VALUE(p.images, '$[0]') AS images " +
           "FROM product p " +
           "INNER JOIN product_category pc ON p.id = pc.product_id " +
           "WHERE p.status = 1 " +
           "AND p.brand_id IN (:brandIds) " +
           "AND pc.category_id IN (:categoryIds) " +
           "AND p.sale_price > :minPrice " +
           "AND p.sale_price < :maxPrice " +
           "GROUP BY p.id, p.product_code, p.name, p.slug, p.sale_price, " +
           "p.product_view, p.total_sold, p.description, p.images " +
           "ORDER BY p.id " +
           "OFFSET :offset ROWS " +
           "FETCH NEXT :limit ROWS ONLY", nativeQuery = true)
    List<Product> findProductsByFilters(@Param("brandIds") List<Long> brandIds,
                                      @Param("categoryIds") List<Long> categoryIds,
                                      @Param("minPrice") long minPrice,
                                      @Param("maxPrice") long maxPrice,
                                      @Param("offset") int offset,
                                      @Param("limit") int limit);
}

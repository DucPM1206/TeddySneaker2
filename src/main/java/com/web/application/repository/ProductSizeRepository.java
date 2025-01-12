package com.web.application.repository;

import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import com.web.application.entity.ProductSize;
import com.web.application.entity.ProductSizeId;

@Repository
public interface ProductSizeRepository extends JpaRepository<ProductSize, ProductSizeId> {

    // Lấy size của sản phẩm
    @Query(nativeQuery = true, value = "SELECT ps.size FROM product_size ps WHERE ps.product_id = ?1 AND ps.quantity > 0")
    List<Integer> findAllSizeOfProduct(String id);

    List<ProductSize> findByProductId(String id);

    @Query("SELECT COALESCE(SUM(ps.quantity), 0) FROM ProductSize ps WHERE ps.productId = :productId")
    public long getTotalQuantityByProductId(@Param("productId") String productId);

    // Kiểm trả size sản phẩm
    @Query(value = "SELECT * FROM product_size WHERE product_id = ?1 AND size = ?2 AND quantity >0", nativeQuery = true)
    ProductSize checkProductAndSizeAvailable(String id, int size);

    // Find by product ID and size
    @Query("SELECT ps FROM ProductSize ps WHERE ps.productId = :productId AND ps.size = :size")
    Optional<ProductSize> findByProductIdAndSize(@Param("productId") String productId, @Param("size") int size);

    // Trừ 1 sản phẩm theo size
    @Transactional
    @Modifying
    @Query(nativeQuery = true, value = "Update product_size set quantity = quantity - 1 where product_id = ?1 and size = ?2")
    public void minusOneProductBySize(String id, int size);

    // Cộng 1 sản phẩm theo size
    @Transactional
    @Modifying
    @Query(nativeQuery = true, value = "Update product_size set quantity = quantity + 1 where product_id = ?1 and size = ?2")
    public void plusOneProductBySize(String id, int size);

    @Transactional
    @Modifying
    @Query(nativeQuery = true, value = "Delete from product_size where product_id = ?1")
    public void deleteByProductId(String id);
}

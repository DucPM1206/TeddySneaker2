package com.web.application.controller.admin;
import java.util.List;
import java.util.stream.Collectors;

import javax.validation.Valid;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;

import com.web.application.config.Contant;
import com.web.application.entity.Brand;
import com.web.application.entity.Category;
import com.web.application.entity.Product;
import com.web.application.entity.ProductSize;
import com.web.application.entity.User;
import com.web.application.model.request.CreateProductRequest;
import com.web.application.model.request.CreateSizeCountRequest;
import com.web.application.model.request.UpdateFeedBackRequest;
import com.web.application.repository.ProductSizeRepository;
import com.web.application.security.CustomUserDetails;
import com.web.application.service.BrandService;
import com.web.application.service.CategoryService;
import com.web.application.service.ImageService;
import com.web.application.service.ProductService;

import jakarta.servlet.ServletContext;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
public class ProductController {

	@Autowired
	private ServletContext context;

	@Autowired
	private ProductService productService;
	@Autowired
	ProductSizeRepository productSizeRepository;

	@Autowired
	private BrandService brandService;

	@Autowired
	private CategoryService categoryService;

	@Autowired
	private ImageService imageService;

    @GetMapping("/admin/products")
    public String homePages(Model model,
                            @RequestParam(defaultValue = "", required = false) String id,
                            @RequestParam(defaultValue = "", required = false) String name,
                            @RequestParam(defaultValue = "", required = false) String category,
                            @RequestParam(defaultValue = "", required = false) String brand,
                            @RequestParam(defaultValue = "", required = false) Long price,
                            @RequestParam(defaultValue = "", required = false) Long sale_price,
                            @RequestParam(defaultValue = "1", required = false) Integer page) {

		// Lấy danh sách nhãn hiệu
		List<Brand> brands = brandService.getListBrand();
		model.addAttribute("brands", brands);
		// Lấy danh sách danh mục
		List<Category> categories = categoryService.getListCategories();
		model.addAttribute("categories", categories);
		// Lấy danh sách sản phẩm
		Page<Product> products = productService.adminGetListProduct(id, name, category, brand, price, sale_price, page);
		products.getContent().stream().peek(product -> {
			long totalQuantity = productSizeRepository.getTotalQuantityByProductId(product.getId());
			product.setTotalQuantity(totalQuantity);
		}).collect(Collectors.toList());
		model.addAttribute("products", products.getContent());
		model.addAttribute("totalPages", products.getTotalPages());
		model.addAttribute("currentPage", products.getPageable().getPageNumber() + 1);

		return "admin/product/list";
	}

	@GetMapping("/admin/products/create")
	public String getProductCreatePage(Model model) {
		// Lấy danh sách anh của user
		User user = ((CustomUserDetails) SecurityContextHolder.getContext().getAuthentication().getPrincipal())
				.getUser();
		List<String> images = imageService.getListImageOfUser(user.getId());
		model.addAttribute("images", images);

		// Lấy danh sách nhãn hiệu
		List<Brand> brands = brandService.getListBrand();
		model.addAttribute("brands", brands);
		// Lấy danh sách danh mục
		List<Category> categories = categoryService.getListCategories();
		model.addAttribute("categories", categories);

		return "admin/product/create";
	}

	@GetMapping("/admin/products/{slug}/{id}")
	public String getProductUpdatePage(Model model, @PathVariable String id) {
		// Get product information
		Product product = productService.getProductById(id);
		System.out.println(product.getId());
		model.addAttribute("product", product);

		// Get product sizes
		List<ProductSize> productSizes = productSizeRepository.findByProductId(id);
		model.addAttribute("productSizes", productSizes);

		// Get brands
		List<Brand> brands = brandService.getListBrand();
		model.addAttribute("brands", brands);

		// Get categories
		List<Category> categories = categoryService.getListCategories();
		model.addAttribute("categories", categories);

		// Get available sizes
		List<Integer> sizeVN = List.of(35, 36, 37, 38, 39, 40, 41, 42, 43);
		model.addAttribute("sizeVN", sizeVN);

		return "admin/product/edit";
	}

    @GetMapping("/api/admin/products")
    public ResponseEntity<Object> getListProducts(@RequestParam(defaultValue = "", required = false) String id,
                                                  @RequestParam(defaultValue = "", required = false) String name,
                                                  @RequestParam(defaultValue = "", required = false) String category,
                                                  @RequestParam(defaultValue = "", required = false) String brand,
                                                  @RequestParam(defaultValue = "", required = false) Long price,
                                                  @RequestParam(defaultValue = "", required = false) Long sale_price,
                                                  @RequestParam(defaultValue = "1", required = false) Integer page) {
        Page<Product> products = productService.adminGetListProduct(id, name, category, brand, price, sale_price, page);
        return ResponseEntity.ok(products);
    }

	@GetMapping("/api/admin/products/{id}")
	public ResponseEntity<Object> getProductDetail(@PathVariable String id) {
		Product rs = productService.getProductById(id);
		return ResponseEntity.ok(rs);
	}

	@PostMapping("/api/admin/products")
	public ResponseEntity<Object> createProduct(@Valid @RequestBody CreateProductRequest createProductRequest) {
		Product product = productService.createProduct(createProductRequest);
		return ResponseEntity.ok(product);
	}

	@PutMapping("/api/admin/products/{id}")
	public ResponseEntity<Object> updateProduct(@Valid @RequestBody CreateProductRequest createProductRequest,
			@PathVariable String id) {
		productService.updateProduct(createProductRequest, id);
		return ResponseEntity.ok("Sửa sản phẩm thành công!");
	}

	@DeleteMapping("/api/admin/products")
	public ResponseEntity<Object> deleteProduct(@RequestBody String[] ids) {
		productService.deleteProduct(ids);
		return ResponseEntity.ok("Xóa sản phẩm thành công!");
	}

	@DeleteMapping("/api/admin/products/{id}")
	public ResponseEntity<Object> deleteProductById(@PathVariable String id) {
		productService.deleteProductById(id);
		return ResponseEntity.ok("Xóa sản phẩm thành công!");
	}

	@PutMapping("/api/admin/products/sizes")
	public ResponseEntity<?> updateSizeCount(@Valid @RequestBody CreateSizeCountRequest createSizeCountRequest) {
		productService.createSizeCount(createSizeCountRequest);

		return ResponseEntity.ok("Cập nhật thành công!");
	}

	@PutMapping("/api/admin/products/{id}/update-feedback-image")
	public ResponseEntity<?> updatefeedBackImages(@PathVariable String id,
			@Valid @RequestBody UpdateFeedBackRequest req) {
		productService.updatefeedBackImages(id, req);

		return ResponseEntity.ok("Cập nhật thành công");
	}
}

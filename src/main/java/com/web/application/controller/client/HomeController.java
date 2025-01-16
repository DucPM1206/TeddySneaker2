package com.web.application.controller.client;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import com.web.application.config.Contant;
import com.web.application.dto.CheckPromotion;
import com.web.application.dto.DetailProductInfoDTO;
import com.web.application.dto.PageableDTO;
import com.web.application.dto.ProductInfoDTO;
import com.web.application.entity.*;
import com.web.application.exception.BadRequestExp;
import com.web.application.exception.NotFoundExp;
import com.web.application.model.request.CreateOrderRequest;
import com.web.application.model.request.FilterProductRequest;
import com.web.application.security.CustomUserDetails;
import com.web.application.service.*;

import javax.validation.Valid;
import java.util.ArrayList;
import java.util.List;

@Controller
public class HomeController {

    @Autowired
    private ProductService productService;

    @Autowired
    private BrandService brandService;

    @Autowired
    private PostService postService;

    @Autowired
    private OrderService orderService;

    @Autowired
    private CategoryService categoryService;

    @Autowired
    private PromotionService promotionService;

    @GetMapping
    public String homePage(Model model) {

        // Lấy 5 sản phẩm mới nhất
        List<ProductInfoDTO> newProducts = productService.getListNewProducts();
        model.addAttribute("newProducts", newProducts);
        // Lấy 5 sản phẩm bán chạy nhất
        List<ProductInfoDTO> bestSellerProducts = productService.getListBestSellProducts();
        model.addAttribute("bestSellerProducts", bestSellerProducts);
        // Lấy 5 sản phẩm có lượt xem nhiều
        List<ProductInfoDTO> viewProducts = productService.getListViewProducts();
        model.addAttribute("viewProducts", viewProducts);
        // Lấy danh sách nhãn hiệu
        List<Brand> brands = brandService.getListBrand();
        model.addAttribute("brands", brands);
        System.out.println("brands");
        // Lấy 5 bài viết mới nhất
        List<Post> posts = postService.getLatesPost();
        model.addAttribute("posts", posts);
        System.out.println("posts");
        return "shop/index";
    }

    @GetMapping("/{slug}/{id}")
    public String getProductDetail(Model model, @PathVariable String id) {

        // Lấy thông tin sản phẩm
        DetailProductInfoDTO product;
        try {
            product = productService.getDetailProductById(id);
            System.out.println(product);
        } catch (NotFoundExp ex) {
            return "error/404";
        } catch (Exception ex) {
            return "error/500";
        }
        model.addAttribute("product", product);

        // Lấy sản phẩm liên quan
        List<ProductInfoDTO> relatedProducts = productService.getRelatedProducts(id);
        model.addAttribute("relatedProducts", relatedProducts);

        // Lấy danh sách nhãn hiệu
        List<Brand> brands = brandService.getListBrand();
        model.addAttribute("brands", brands);

        // Lấy size có sẵn
        List<Integer> availableSizes = productService.getListAvailableSize(id);
        model.addAttribute("availableSizes", availableSizes);

        // Lấy số lượng cho mỗi size
        List<Integer> sizeQuantities = productService.getListSizeQuantities(id);
        model.addAttribute("sizeQuantities", sizeQuantities);

        if (!availableSizes.isEmpty()) {
            model.addAttribute("canBuy", true);
        } else {
            model.addAttribute("canBuy", false);
        }

        // Lấy danh sách size giầy
        model.addAttribute("sizeVn", Contant.SIZE_VN);

        return "shop/detail";
    }

    @GetMapping("/dat-hang")
    public String getCartPage(Model model, @RequestParam String id, @RequestParam int size) {

        // Lấy chi tiết sản phẩm
        DetailProductInfoDTO product;
        try {
            product = productService.getDetailProductById(id);
        } catch (NotFoundExp ex) {
            return "error/404";
        } catch (Exception ex) {
            return "error/500";
        }
        model.addAttribute("product", product);

        // Validate size
        if (size < 35 || size > 42) {
            return "error/404";
        }

        // Lấy danh sách size có sẵn
        List<Integer> availableSizes = productService.getListAvailableSize(id);
        model.addAttribute("availableSizes", availableSizes);
        boolean notFoundSize = true;
        for (Integer availableSize : availableSizes) {
            if (availableSize == size) {
                notFoundSize = false;
                break;
            }
        }
        model.addAttribute("notFoundSize", notFoundSize);

        // Lấy danh sách size
        model.addAttribute("sizeVn", Contant.SIZE_VN);
        model.addAttribute("size", size);

        return "shop/payment";
    }

    // @PostMapping("/api/orders")
    // public ResponseEntity<Object> createOrder(@Valid @RequestBody
    // CreateOrderRequest createOrderRequest) {
    // User user = ((CustomUserDetails)
    // SecurityContextHolder.getContext().getAuthentication().getPrincipal())
    // .getUser();
    // Order order = orderService.createOrder(createOrderRequest, user.getId());

    // return ResponseEntity.ok(order.getId());
    // }

    @GetMapping("/products")
    public ResponseEntity<Object> getListBestSellProducts() {
        List<ProductInfoDTO> productInfoDTOS = productService.getListBestSellProducts();
        return ResponseEntity.ok(productInfoDTOS);
    }

    @GetMapping("/san-pham")
    public String getProductShopPages(Model model) {

        // Lấy danh sách nhãn hiệu
        List<Brand> brands = brandService.getListBrand();
        model.addAttribute("brands", brands);
        List<Long> brandIds = new ArrayList<>();
        for (Brand brand : brands) {
            brandIds.add(brand.getId());
        }
        model.addAttribute("brandIds", brandIds);

        // Lấy danh sách danh mục
        List<Category> categories = categoryService.getListCategories();
        model.addAttribute("categories", categories);
        List<Long> categoryIds = new ArrayList<>();
        for (Category category : categories) {
            categoryIds.add(category.getId());
        }
        model.addAttribute("categoryIds", categoryIds);

        // Danh sách size của sản phẩm
        model.addAttribute("sizeVn", Contant.SIZE_VN);

        // Lấy danh sách sản phẩm
        FilterProductRequest req = new FilterProductRequest(brandIds, categoryIds, new ArrayList<>(), (long) 0,
                Long.MAX_VALUE, 1);
        PageableDTO result = productService.filterProduct(req);
        model.addAttribute("totalPages", result.getTotalPages());
        model.addAttribute("currentPage", result.getCurrentPage());
        model.addAttribute("listProduct", result.getItems());

        return "shop/product";
    }

    @PostMapping("/api/san-pham/loc")
    public ResponseEntity<?> filterProduct(@RequestBody FilterProductRequest req) {
        // Validate
        if (req.getMinPrice() == null) {
            req.setMinPrice((long) 0);
        } else {
            if (req.getMinPrice() < 0) {
                return ResponseEntity.status(HttpStatus.BAD_REQUEST).body("Mức giá phải lớn hơn 0");
            }
        }
        if (req.getMaxPrice() == null) {
            req.setMaxPrice(Long.MAX_VALUE);
        } else {
            if (req.getMaxPrice() < 0) {
                return ResponseEntity.status(HttpStatus.BAD_REQUEST).body("Mức giá phải lớn hơn 0");
            }
        }

        PageableDTO result = productService.filterProduct(req);

        return ResponseEntity.ok(result);
    }

    @GetMapping("/tim-kiem")
    public String searchProduct(Model model, @RequestParam(required = false) String keyword,
            @RequestParam(required = false) Integer page) {

        PageableDTO result = productService.searchProductByKeyword(keyword, page);

        model.addAttribute("totalPages", result.getTotalPages());
        model.addAttribute("currentPage", result.getCurrentPage());
        model.addAttribute("listProduct", result.getItems());
        model.addAttribute("keyword", keyword);
        if (((List<?>) result.getItems()).isEmpty()) {
            model.addAttribute("hasResult", false);
        } else {
            model.addAttribute("hasResult", true);
        }

        return "shop/search";
    }

    @GetMapping("/api/check-hidden-promotion")
    public ResponseEntity<Object> checkPromotion(@RequestParam String code) {
        if (code == null || code == "") {
            throw new BadRequestExp("Mã code trống");
        }

        Promotion promotion = promotionService.checkPromotion(code);
        if (promotion == null) {
            throw new BadRequestExp("Mã code không hợp lệ");
        }
        CheckPromotion checkPromotion = new CheckPromotion();
        checkPromotion.setDiscountType(promotion.getDiscountType());
        checkPromotion.setDiscountValue(promotion.getDiscountValue());
        checkPromotion.setMaximumDiscountValue(promotion.getMaximumDiscountValue());
        return ResponseEntity.ok(checkPromotion);
    }

    @GetMapping("/api/products/{id}/validate-size")
    @ResponseBody
    public ResponseEntity<Object> validateProductSize(@PathVariable String id, @RequestParam int size) {
        try {
            boolean isAvailable = productService.checkProductSizeAvailable(id, size);
            if (isAvailable) {
                return ResponseEntity.ok().build();
            } else {
                return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                    .body("Size " + size + " het hang");
            }
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body("Có lỗi xảy ra khi kiểm tra size");
        }
    }

    @GetMapping("/api/products/{id}/validate-quantity")
    @ResponseBody
    public ResponseEntity<Object> validateProductQuantity(
            @PathVariable String id, 
            @RequestParam int size, 
            @RequestParam int quantity) {
        try {
            ProductSize productSize = productService.getProductSize(id, size);
            if (productSize == null) {
                return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                    .body("Size " + size + " khong ton tai");
            }
            
            if (productSize.getQuantity() < quantity) {
                return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                    .body("Chi con " + productSize.getQuantity() + " san pham size " + size);
            }
            
            return ResponseEntity.ok().build();
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body("Co loi xay ra khi kiem tra so luong");
        }
    }

    @GetMapping("lien-he")
    public String contact() {
        return "shop/lien-he";
    }

    @GetMapping("huong-dan")
    public String buyGuide() {
        return "shop/buy-guide";
    }

    @GetMapping("doi-hang")
    public String doiHang() {
        return "shop/doi-hang";
    }

}

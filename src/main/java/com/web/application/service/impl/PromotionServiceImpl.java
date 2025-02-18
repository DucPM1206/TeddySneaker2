package com.web.application.service.impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Component;

import com.web.application.config.Contant;
import com.web.application.dto.UserDTO;
import com.web.application.entity.Promotion;
import com.web.application.exception.BadRequestExp;
import com.web.application.exception.InternalServerExp;
import com.web.application.exception.NotFoundExp;
import com.web.application.model.request.CreatePromotionRequest;
import com.web.application.repository.PromotionRepository;
import com.web.application.service.EmailService;
import com.web.application.service.PromotionService;
import com.web.application.service.UserService;

import java.sql.Timestamp;
import java.util.List;
import java.util.Optional;

@Component
public class PromotionServiceImpl implements PromotionService {

	@Autowired
	private PromotionRepository promotionRepository;
	@Autowired
	private UserService userService;

	@Autowired
	private EmailService emailService;

	@Override
	public Page<Promotion> adminGetListPromotion(String code, String name, String publish, String active, int page) {
		page--;
		if (page < 0) {
			page = 0;
		}
		int limit = 10;
		Pageable pageable = PageRequest.of(page, limit, Sort.by("created_at").descending());
		return promotionRepository.adminGetListPromotion(code, name, publish, active, pageable);
	}

	@Override
	public Promotion createPromotion(CreatePromotionRequest createPromotionRequest) {
		// Check mã đã tồn tại chưa
		Optional<Promotion> rs = promotionRepository.findByCouponCode(createPromotionRequest.getCode());
		if (rs.isPresent()) {
			throw new BadRequestExp("Mã khuyến mại đã tồn tại!");
		}

		// Check validate
		Timestamp now = new Timestamp(System.currentTimeMillis());
		if (createPromotionRequest.getExpiredDate().before(now)) {
			throw new BadRequestExp("Hạn khuyến mại không hợp lệ");
		}
		if (createPromotionRequest.getDiscountType() == Contant.DISCOUNT_PERCENT) {
			if (createPromotionRequest.getDiscountValue() < 1 || createPromotionRequest.getDiscountValue() > 100) {
				throw new BadRequestExp("Mức giảm giá từ 1% - 100%");
			}
			if (createPromotionRequest.getMaxValue() < 1000) {
				throw new BadRequestExp("Mức giảm giá tối đa phải lớn hơn 1000");
			}
		} else {
			if (createPromotionRequest.getDiscountValue() < 1000) {
				throw new BadRequestExp("Mức giảm giá phải lớn hơn 1000");
			}
		}

		// Check có khuyến mại nào đang chạy hay chưa

		if (createPromotionRequest.isPublic() && createPromotionRequest.isActive()) {
			Promotion alreadyPromotion = promotionRepository.checkHasPublicPromotion();
			if (alreadyPromotion != null) {
				throw new BadRequestExp("Chương trình khuyến mãi công khai \"" + alreadyPromotion.getCouponCode()
						+ "\" đang chạy. Không thể tạo mới");
			}
		}

		Promotion promotion = new Promotion();
		promotion.setCouponCode(createPromotionRequest.getCode());
		promotion.setName(createPromotionRequest.getName());
		promotion.setActive(createPromotionRequest.isActive());
		promotion.setPublic(createPromotionRequest.isPublic());
		promotion.setExpiredAt(createPromotionRequest.getExpiredDate());
		promotion.setDiscountType(createPromotionRequest.getDiscountType());
		promotion.setDiscountValue(createPromotionRequest.getDiscountValue());
		if (createPromotionRequest.getDiscountType() == Contant.DISCOUNT_PERCENT) {
			promotion.setMaximumDiscountValue(createPromotionRequest.getMaxValue());
		} else {
			promotion.setMaximumDiscountValue(createPromotionRequest.getDiscountValue());
		}
		promotion.setCreatedAt(new Timestamp(System.currentTimeMillis()));
		promotionRepository.save(promotion);
		if (createPromotionRequest.getUserIds().size() > 0) {
			createPromotionRequest.getUserIds().forEach(id -> {
				UserDTO userDTO = userService.getUsers(id);
				try {
					emailService.sendEmail(userDTO.getEmail(), "Tặng Khuyến mãi", promotion, userDTO);
				} catch (Exception e) {
					e.printStackTrace();
				}
			});
		}
		return promotion;
	}

	@Override
	public void updatePromotion(CreatePromotionRequest createPromotionRequest, long id) {
		Optional<Promotion> rs = promotionRepository.findById(id);
		if (rs.isEmpty()) {
			throw new NotFoundExp("Khuyến mại không tồn tại");
		}

		// check validate
		Timestamp now = new Timestamp(System.currentTimeMillis());
		if (createPromotionRequest.getExpiredDate().before(now)) {
			throw new BadRequestExp("Hạn khuyến mại không hợp lệ");
		}
		if (createPromotionRequest.getDiscountType() == Contant.DISCOUNT_PERCENT) {
			if (createPromotionRequest.getDiscountValue() < 1 || createPromotionRequest.getDiscountValue() > 100) {
				throw new BadRequestExp("Mức giảm giá từ 1 - 100%");
			}
			if (createPromotionRequest.getMaxValue() < 1000) {
				throw new BadRequestExp("Mức giảm giá tối đa phải lớn hơn 1000");
			}
		} else {
			if (createPromotionRequest.getDiscountValue() < 1000) {
				throw new BadRequestExp("Mức giảm giá phải lớn hơn 1000");
			}
		}

		// Check có khuyến mại nào đang chạy hay không
		if (createPromotionRequest.isActive() && createPromotionRequest.isPublic()) {
			Promotion alreadyPromotion = promotionRepository.checkHasPublicPromotion();
			if (alreadyPromotion != null) {
				throw new BadRequestExp("Chương trình khuyến mãi công khai \"" + alreadyPromotion.getCouponCode()
						+ "\" đang chạy. Không thể tạo mới");
			}
		}

		// Kiểm tra mã code
		rs = promotionRepository.findByCouponCode(createPromotionRequest.getCode());
		if (rs.isPresent() && rs.get().getId() != id) {
			throw new BadRequestExp("Mã code đã tồn tại trong hệ thống");
		}

		Promotion promotion = new Promotion();
		promotion.setCouponCode(createPromotionRequest.getCode());
		promotion.setName(createPromotionRequest.getName());
		promotion.setExpiredAt(createPromotionRequest.getExpiredDate());
		promotion.setDiscountType(createPromotionRequest.getDiscountType());
		promotion.setDiscountValue(createPromotionRequest.getDiscountValue());
		if (createPromotionRequest.getDiscountType() == Contant.DISCOUNT_PERCENT) {
			promotion.setMaximumDiscountValue(createPromotionRequest.getMaxValue());
		} else {
			promotion.setDiscountValue(createPromotionRequest.getDiscountValue());
		}
		promotion.setActive(createPromotionRequest.isActive());
		promotion.setPublic(createPromotionRequest.isPublic());
		promotion.setCreatedAt(rs.get().getCreatedAt());
		promotion.setId(id);

		try {
			promotionRepository.save(promotion);
			if (createPromotionRequest.getUserIds().size() > 0) {
				createPromotionRequest.getUserIds().forEach(x -> {
					UserDTO userDTO = userService.getUsers(x);
					try {
						emailService.sendEmail(userDTO.getEmail(), "Tặng Khuyến mãi", promotion, userDTO);
					} catch (Exception e) {
						e.printStackTrace();
					}
				});
			}
		} catch (Exception ex) {
			throw new InternalServerExp("Lỗi khi cập nhật khuyến mãi");
		}
	}

	@Override
	public void deletePromotion(long id) {
		Optional<Promotion> promotion = promotionRepository.findById(id);
		if (promotion.isEmpty()) {
			throw new BadRequestExp("Khuyến mại không tồn tại");
		}

		try {
			promotionRepository.deleteById(id);
		} catch (Exception e) {
			throw new InternalServerExp("Lỗi khi xóa khuyến mại");
		}
	}

	@Override
	public Promotion findPromotionById(long id) {
		Optional<Promotion> promotion = promotionRepository.findById(id);
		if (promotion.isEmpty()) {
			throw new NotFoundExp("Khuyến mại không tồn tại");
		}
		return promotion.get();
	}

	@Override
	public Promotion checkPublicPromotion() {
		return promotionRepository.checkHasPublicPromotion();
	}

	@Override
	public long calculatePromotionPrice(long price, Promotion promotion) {
		long discountValue = promotion.getMaximumDiscountValue();
		long tmp = promotion.getDiscountValue();
		if (promotion.getDiscountType() == Contant.DISCOUNT_PERCENT) {
			tmp = price * promotion.getDiscountValue() / 100;
		}
		if (tmp < discountValue) {
			discountValue = tmp;
		}
		long promotionPrice = price - discountValue;
		if (promotionPrice < 0) {
			promotionPrice = 0;
		}
		return promotionPrice;
	}

	@Override
	public Promotion checkPromotion(String code) {
		return promotionRepository.checkPromotion(code);
	}

	@Override
	public List<Promotion> getAllValidPromotion() {
		return promotionRepository.getAllValidPromotion();
	}
}

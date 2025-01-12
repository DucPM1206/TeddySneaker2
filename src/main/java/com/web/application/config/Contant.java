package com.web.application.config;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

public class Contant {

    // Thời gian lưu cookie tối đa
    public static final int MAX_AGE_COOKIE = 7 * 24 * 60 * 60;

    //Limit
    public static final int LIMIT_BRAND = 10;
    public static final int LIMIT_CATEGORY = 10;
    public static final int LIMIT_PRODUCT = 10;
    public static final int LIMIT_POST = 10;
    public static final int LIMIT_POST_SHOP = 8;
    public static final int LIMIT_POST_RELATED = 5;
    public static final int LIMIT_USER = 15;
    public static final int LIMIT_ORDER = 10;

    //Product
    public static final int LIMIT_PRODUCT_SELL = 10;
    public static final int LIMIT_PRODUCT_NEW = 8;
    public static final int LIMIT_PRODUCT_VIEW = 8;
    public static final int LIMIT_PRODUCT_RELATED = 8;
    public static final int LIMIT_PRODUCT_SHOP = 20;
    public static final int LIMIT_PRODUCT_SEARCH = 20;

    //Post
    public static final int LIMIT_POST_NEW = 5;

    //Size giày
    public static final List<Integer> SIZE_VN = new ArrayList<>(Arrays.asList(35, 36, 37, 38, 39, 40, 41, 42, 43));

    //Trạng thái post
    public static final int PUBLIC_POST = 1;
    public static final int DRAFT_POST = 0;

    //Trạng thái đơn hàng
    public static final int PENDING_CONFIRM_STATUS = 0;
    public static final int ORDER_STATUS = 1;
    public static final int DELIVERY_STATUS = 2;
    public static final int COMPLETED_STATUS = 3;
    public static final int RETURNED_STATUS = 4;
    public static final int CANCELED_STATUS = 5;
    public static final int COUNTER_STATUS = 6;
    public static final List<Integer> LIST_ORDER_STATUS = new ArrayList<>(Arrays.asList(PENDING_CONFIRM_STATUS, ORDER_STATUS, DELIVERY_STATUS, COMPLETED_STATUS, RETURNED_STATUS, CANCELED_STATUS));

    //Loại khuyến mại
    public static final int DISCOUNT_PERCENT = 1;
//    public static final int DISCOUNT_AMOUNT = 2;
}

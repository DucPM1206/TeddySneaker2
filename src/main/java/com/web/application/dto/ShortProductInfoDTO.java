package com.web.application.dto;

import java.io.IOException;
import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

import java.util.ArrayList;

@Setter
@Getter
@ToString
public class ShortProductInfoDTO {
	private String id;
	
	private String productCode;

	private String name;

	private long price;

	List<Integer> availableSizes;
	
	List<Integer> quantitySizes;

	public ShortProductInfoDTO(String id, String productCode, String name) {
		this.id = id;
		this.productCode = productCode;
		this.name = name;
	}

	public ShortProductInfoDTO(String id, String productCode, String name, long price, Object availableSizes, Object quantitySizes) {
		this.id = id;
		this.productCode = productCode;
		this.name = name;
		this.price = price;
		if (availableSizes != null) {
			try {
				this.availableSizes = Arrays.stream(availableSizes.toString().split(","))
						.map(Integer::parseInt)
						.collect(Collectors.toList());
			} catch (Exception e) {
				this.availableSizes = new ArrayList<>();
			}
		}
		if (quantitySizes != null) {
			try {
				this.quantitySizes = Arrays.stream(quantitySizes.toString().split(","))
						.map(Integer::parseInt)
						.collect(Collectors.toList());
			} catch (Exception e) {
				this.quantitySizes = new ArrayList<>();
			}
		}
	}
}
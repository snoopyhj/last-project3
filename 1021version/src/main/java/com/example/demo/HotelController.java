package com.example.demo;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.example.demo.dao.HotelSearchDAO;
import com.example.demo.dao.RegionSearchDAO;
import com.example.demo.vo.HotelVO;

@Controller
public class HotelController {
	@Autowired
	RegionSearchDAO dao;
	
	@Autowired
	HotelSearchDAO hdao;
	
	@RequestMapping(value = "/regionsearch", method = RequestMethod.GET) 
	public String region_search(String region, String subregion, Model model) {
		  
		HotelVO vo = new HotelVO();
		vo.setRegion(region);
		vo.setSubregion(subregion);
		
		model.addAttribute("hotel_list", dao.select_region(vo));
	  
		return "hotellist";
	}
	
	@RequestMapping(value = "/hoteldetail", method = RequestMethod.GET)
	public String gotohoteldetail(@RequestParam("name") String name, Model model) {
		HotelVO vo = new HotelVO();
		vo.setName(name);
		model.addAttribute("hotel", hdao.select_hotel(vo));
		System.out.println(hdao.select_hotel(vo).getName());
		
		return "hoteldetail";
	}
	
	@RequestMapping(value = "/hotelreservation", method = RequestMethod.GET)
	public String gotoreservation(@RequestParam("name") String name,  
			@RequestParam("roomType") String roomType,
	        @RequestParam("price") String price, Model model) {

		HotelVO hotelInfo = hdao.gotoreservation(name);
	    model.addAttribute("hotelInfo", hotelInfo);
	    
	    model.addAttribute("roomType", roomType);
	    model.addAttribute("price", price);

	    return "hotelreservation";
	}
	
	 @RequestMapping(value = "/hotelbytype", method = RequestMethod.GET)
	 public String gotohotelbytype() {
		 return "hotelbytype";
	 }
	
	 @GetMapping("/hotel/data")
	 @ResponseBody
	 public List<HotelVO> getHotelsByType(@RequestParam("type") String type) {
		 System.out.println(type);
		 List<HotelVO> hotels = hdao.selectHotelsByType(type);
		 System.out.println(hotels.get(0).getName());
		 return hotels;
	 }
	 
	 @ResponseBody
	 @PostMapping("/reservation_clear")
	 public void paymentByImpUid(@RequestBody String imp_uid) {
		 
	 }
}
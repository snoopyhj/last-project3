package com.example.demo.controller;

import java.util.Collections;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.example.demo.dao.FavoritesDAO;
import com.example.demo.dao.HotelDAO;
import com.example.demo.dao.HotelReviewDAO;
import com.example.demo.dao.HotelSearchDAO;
import com.example.demo.dao.RegionSearchDAO;
import com.example.demo.dao.ReservationDAO;
import com.example.demo.vo.HotelReviewVO;
import com.example.demo.vo.HotelVO;
import com.example.demo.vo.RoomTypePrice;

import jakarta.servlet.http.HttpSession;

import org.springframework.web.util.HtmlUtils;
@Controller
public class HotelController {
	@Autowired
	RegionSearchDAO dao;
	//ㅇㄹㅇㄴ
	@Autowired
	HotelSearchDAO hdao;
	@Autowired
	ReservationDAO rdao;
	@Autowired
	private HotelDAO hotelDAO;   // HotelDAO 인스턴스 변수로 선언
	@Autowired
	private HotelReviewDAO hotelReviewDAO;
	@Autowired
	FavoritesDAO fdao;
		
	
	@RequestMapping(value = "/", method = RequestMethod.GET)
	public String main(Model model) {
	    HotelVO vo = new HotelVO();
	    
	    model.addAttribute("hotel_list", dao.select_region4(vo));
	    System.out.println(dao.select_region4(vo));
	    return "mainpage/main";
	}
	@PostMapping("/toggleFavorite")
	@ResponseBody
	public Map<String, Object> toggleFavorite(@RequestBody Map<String, String> payload) {
	    String default_num = payload.get("default_num");
	    String username = payload.get("username");
	    System.out.println("Received defaultNum: " + default_num);
	    System.out.println("User ID from session in toggleFavorite: " + username);

	    if (username == null) {
	        System.out.println("사용자가 로그인하지 않았습니다.");
	        return Collections.singletonMap("favorited", false);
	    }

	    boolean favorited;
	    System.out.println(fdao.isFavorite(default_num, username));
	    if (fdao.isFavorite(default_num, username)) {
	        fdao.deleteFavorite(default_num, username);
	        favorited = false;
	    } else {
	        fdao.insertFavorite(default_num, username);
	        favorited = true;
	    }
	    return Collections.singletonMap("favorited", favorited);
	}

	
	@RequestMapping(value = "/regionsearch", method = RequestMethod.GET) 
	public String region_search(String region, String subregion, Model model) {
		  
		HotelVO vo = new HotelVO();
		vo.setRegion(region);
		vo.setSubregion(subregion);
		
		model.addAttribute("hotel_list", dao.select_region(vo));
	  
		return "hotel/hotellist";
	}
	
	@RequestMapping(value = "/regionsearch2", method = RequestMethod.GET) 
	public String region_search(String region,Model model) {
		  
		HotelVO vo = new HotelVO();
		vo.setRegion(region);
		
		
		model.addAttribute("hotel_list", dao.select_region2(vo));
	  
		return "hotel/hotellist";
	}
	
	@GetMapping("/regionsearch5")
	 public String getHotelDetail(@RequestParam("default_num") String defaultNum, Model model, HttpSession session) {
	     // 호텔 정보 가져오기
	     HotelVO hotel = hotelDAO.getHotelByDefaultNum(defaultNum);
	     // 리뷰 가져오기
	     List<HotelReviewVO> reviews = hotelReviewDAO.getReviewsByHotel(defaultNum);
	     System.out.println("mapx : "+hotel.mapx);
	     System.out.println(hotel.mapy);
	     // 모델에 데이터 추가
	     model.addAttribute("hotel", hotel);
	     model.addAttribute("defaultNum", defaultNum);
	     model.addAttribute("reviews", reviews);
	     int parsedPrice = Integer.parseInt(hotel.suite.replace(",", ""));
			System.out.println("parsedPrice : "+parsedPrice);
			
	     System.out.println("hotel : "+hotel.name);
	     System.out.println("hotel : "+hotel.type);
	     System.out.println("hotel : "+hotel.suite);
	     System.out.println("hotel : "+hotel.suite);
	     return "hotel/hoteldetail";
	 }
	
	
	
	@RequestMapping(value = "/regionsearch3", method = RequestMethod.GET)
	public String region_search3(@RequestParam("search") String search, Model model) {
	    HotelVO vo = new HotelVO();
	    vo.setAddress(search);
	    vo.setName(search);

	    // 데이터베이스에서 검색 결과 가져오기
	    List<HotelVO> hotels = dao.select_region3(vo);
	   System.out.print(hotels);
	    model.addAttribute("hotel_list", hotels);
	    return "hotel/hotellist";  // 호텔 목록 페이지로 이동
	    
	    
	    
	}
	@RequestMapping(value = "/hoteldetail", method = RequestMethod.GET)
	public String gotohoteldetail(@RequestParam("name") String name, Model model,HttpSession session) {
		HotelVO vo = new HotelVO();
		vo.setName(name);
		model.addAttribute("hotel", hdao.select_hotel(vo));

		
		return "hotel/hoteldetail";
	}
	
	
	
	@GetMapping("/hotelreservation")
	public String hotelReservation(HttpSession session, Model model) {
	    String hotelName = (String) session.getAttribute("HotelName");
	    String roomType = (String) session.getAttribute("RoomType");
	    int price = (int) session.getAttribute("Price");
	    String defaultNum = (String) session.getAttribute("defaultNum");
	    HotelVO hotelInfo = hotelDAO.getHotelByDefaultNum(defaultNum);
	    int maxInactiveInterval = session.getMaxInactiveInterval(); // 초 단위
	    long newExpiryTime = System.currentTimeMillis() + (maxInactiveInterval * 1000L);
	    session.setAttribute("sessionExpiryTime", newExpiryTime);
	    model.addAttribute("hotelInfo", hotelInfo);
	    model.addAttribute("roomType", roomType);
	    model.addAttribute("price", price);

	    return "hotel/hotelreservation";
	}

	
	
	 @RequestMapping(value = "/hotelbytype", method = RequestMethod.GET)
	 public String gotohotelbytype() {
		 return "hotel/hotelbytype";
	 }
	
	 @GetMapping("/hotel/data")
	 @ResponseBody
	 public List<HotelVO> getHotelsByType(@RequestParam("type") String type) {
		 System.out.println(type);
		 List<HotelVO> hotels = hdao.selectHotelsByType(type);
		 System.out.println(hotels.get(0).getName());
		 System.out.println(hotels.get(0).getDefault_num());
		 return hotels;
	 }
	 
	 @ResponseBody
	 @PostMapping("/reservation_clear")
	 public void paymentByImpUid(@RequestBody String imp_uid) {
		 
	 }
	 @RequestMapping(value = "/payment_success", method = RequestMethod.POST)
	 public String payment_success(@RequestParam("imp_uid")		 String imp_uid,
			  					   @RequestParam("product_name") String product_name,
			  					   @RequestParam("cost")		 int cost,
			  					   @RequestParam("email")		 String email,
			  					   @RequestParam("name")		 String name,
			  					   @RequestParam("tel")			 String tel,
			  					   @RequestParam("address") 	 String address,
			  					   @RequestParam("dateRange")	 String dateRange,
			  					   @RequestParam("dateStr")		 String dateStr,
			  					   @RequestParam("person")		 String person,
			  					 HttpSession session) {
		 String roomType = (String) session.getAttribute("RoomType");
		 System.out.println(roomType);
		 int expectedPrice = (int) session.getAttribute("Price");
		 System.out.println(expectedPrice);
		 String hotel_name = (String)session.getAttribute("HotelName");
		 rdao.insert_info(imp_uid, hotel_name, expectedPrice, email, name, tel, address, dateRange, dateStr, person);

		 return "redirect:/";
	 }
	 @GetMapping("/session-expired")
	    public String sessionExpired(@RequestParam("name") String name,Model model) {
			model.addAttribute("hotelName", name); // 동적 값 설정
	        return "error/sessionExpired"; // 세션 만료 안내 페이지로 이동
	    }
	 @GetMapping("/session-expired1")
	    public String sessionExpired1(@RequestParam("name") String name,Model model) {
			model.addAttribute("hotelName", name); // 동적 값 설정
	        return "error/sessionExpired1"; // 세션 만료 안내 페이지로 이동
	    }
	 @Autowired
	 HotelReviewDAO reviewDao;

	 @GetMapping("/getReviews")
	 public String getReviews(@RequestParam("default_num") String defaultNum, Model model) {
		 System.out.println("defaultNum : "+defaultNum);
	     List<HotelReviewVO> reviews = reviewDao.getReviewsByHotel(defaultNum);
	     System.out.println("reviews : "+reviews);
	     model.addAttribute("reviews", reviews);
	     return "hotel/hoteldetail";
	 }


	 @PostMapping("/addReview")
	 public String addReview(@RequestParam String username,HotelReviewVO review) {
		 String safeOutput = HtmlUtils.htmlEscape(review.getReviewText());
		 System.out.println("safeOutput : "+safeOutput);
		 if (review.getReviewText().matches("^[a-zA-Z0-9가-힣ㄱ-ㅎㅏ-ㅣ .,!?]*$")) {
			    // 유효한 입력
			} else {
			    throw new IllegalArgumentException("Invalid input");
			}
		 System.out.println("username : "+username);
	     // userId가 없을 경우 "anonymous"로 기본값 설정
	     review.setUserId(username); /* 세션이나 요청에서 userId를 가져오는 로직 */;
	     // 리뷰 저장
	     System.out.println("review123 : "+review.getDefaultNum());
	     System.out.println("review123 : "+review.getReviewText());
	     reviewDao.insertReview(review);
	     System.out.println("review1234 : "+review.getRating());
	     return "redirect:/regionsearch5?default_num=" + review.getDefaultNum();
	 }
	 @PostMapping("/chooseRoom")
	 public String chooseRoom(
	     @RequestParam("roomType") String roomType,
	     @RequestParam("hotelName") String hotelName,
	     @RequestParam("price") String price,
	     @RequestParam("defaultNum") String defaultNum,
	     HttpSession session,
	     Model model
	 ) {
		 System.out.println("chooseRoom");
		 System.out.println(roomType);
		 System.out.println(defaultNum);
		 

	     // 데이터 검증: DB에서 방 타입과 가격 확인
	     int parsedPrice = Integer.parseInt(price.replace(",", ""));
	     System.out.println(parsedPrice);
	     List<RoomTypePrice> roomTypePrices = hdao.getRoomTypesAndPrices(defaultNum);
	     System.out.println(roomTypePrices);

	     boolean valid = roomTypePrices.stream()
	         .anyMatch(rtp -> rtp.getRoomType().equals(roomType) && rtp.getPrice() == parsedPrice);

	     if (!valid) {
	         throw new IllegalArgumentException("Invalid room type or price. Possible tampering detected.");
	     }
	     session.setAttribute("defaultNum", defaultNum);
	     model.addAttribute("RoomType", roomType);
	     model.addAttribute("Price", parsedPrice);
	     // 세션에 선택된 값 저장
	     session.setAttribute("RoomType", roomType);
	     session.setAttribute("Price", parsedPrice);
	     session.setAttribute("HotelName", hotelName);

	     return "redirect:/hotelreservation"; // 예약 페이지로 이동
	 }
	 @PostMapping("/getFavorites")
	 @ResponseBody
	 public List<String> getFavorites(@RequestBody Map<String, String> payload) {
	     String username = payload.get("username");
	     return fdao.getFavoriteDefaultNums(username);
	 }

	 @RequestMapping(value = "/regionsearch6", method = RequestMethod.GET) 
		public String region_search2(String type,Model model) {
		 
			HotelVO vo = new HotelVO();
			vo.setType(type);
			
			model.addAttribute("hotel_list", dao.select_region6(vo));
			
			return "hotel/hotellist";
		}
}
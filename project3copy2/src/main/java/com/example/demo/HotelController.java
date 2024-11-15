package com.example.demo;

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
import com.example.demo.vo.FavoritesVO;
import com.example.demo.vo.HotelReviewVO;
import com.example.demo.vo.HotelVO;

import jakarta.servlet.http.HttpSession;

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
	private HotelDAO hotelDAO; 
	@Autowired
	private HotelReviewDAO hotelReviewDAO;
	@Autowired
	FavoritesDAO fdao;
		
	
	@RequestMapping(value = "/", method = RequestMethod.GET)
	public String main(Model model) {
	    HotelVO vo = new HotelVO();
	    
	    model.addAttribute("hotel_list", dao.select_region4(vo));
	    return "main";
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


    @GetMapping("/contact")
    public String contactPage() {
        return "contact"; 
    }



	@PostMapping("/login")
	public String login(@RequestParam String username, HttpSession session) {
	    // 여기서 사용자 인증 로직을 처리한 뒤에 세션에 username을 저장합니다.
	    session.setAttribute("username", username);
	    return "redirect:/"; // 로그인 후 메인 페이지로 리디렉션
	}

//	@RequestMapping(value = "/insertFavorite", method = RequestMethod.GET)
//	public String favoriesdetail(String id) {
//	    FavoritesVO vo = new FavoritesVO();
//	    vo.setId(id);
//	    fdao.insertFavorite(default_num, username); 
//	    return "hotellist"; 
//	}
//
//	@RequestMapping(value = "/deleteFavorite", method = RequestMethod.GET)
//	public String favorieslist(String id) {
//	    FavoritesVO vo = new FavoritesVO();
//	    vo.setId(id);
//	    fdao.deleteFavorite(vo);
//	    return "hotellist"; 
//	}
	
//	@RequestMapping(value = "/insertFavorite2", method = RequestMethod.GET)
//	public String favoriesdetail2(String id) {
//	    FavoritesVO vo = new FavoritesVO();
//	    vo.setId(id);
//	    fdao.insertFavorite(vo); 
//	    return "hotellist"; 
//	}
//
//	@RequestMapping(value = "/deleteFavorite2", method = RequestMethod.GET)
//	public String favorieslist2(String id) {
//	    FavoritesVO vo = new FavoritesVO();
//	    vo.setId(id);
//	    fdao.deleteFavorite(vo);
//	    return "hoteldetail"; 
//	}

	@RequestMapping(value = "/regionsearch", method = RequestMethod.GET) 
	public String region_search(String region, String subregion, Model model) {
		  
		HotelVO vo = new HotelVO();
		vo.setRegion(region);
		vo.setSubregion(subregion);
		
		model.addAttribute("hotel_list", dao.select_region(vo));
	  
		return "hotellist";
	}
	
	@RequestMapping(value = "/regionsearch2", method = RequestMethod.GET) 
	public String region_search(String region,Model model) {
		HotelVO vo = new HotelVO();
		vo.setRegion(region);
		
		model.addAttribute("hotel_list", dao.select_region2(vo));
	  
		return "hotellist";
	}
	
	@RequestMapping(value = "/regionsearch6", method = RequestMethod.GET) 
	public String region_search2(String type,Model model) {
		HotelVO vo = new HotelVO();
		vo.setType(type);
		
		model.addAttribute("hotel_list", dao.select_region6(vo));
	  
		return "hotellist";
	}
	
	@GetMapping("/regionsearch5")
	 public String getHotelDetail(@RequestParam("default_num") String defaultNum, Model model) {
	     // 호텔 정보 가져오기
	     HotelVO hotel = hotelDAO.getHotelByDefaultNum(defaultNum);
	     // 리뷰 가져오기
	     List<HotelReviewVO> reviews = hotelReviewDAO.getReviewsByHotel(defaultNum);
	     // 모델에 데이터 추가
	     model.addAttribute("hotel", hotel);
	     model.addAttribute("reviews", reviews);
	     return "hoteldetail";
	 }
	
	
	
	@RequestMapping(value = "/regionsearch3", method = RequestMethod.GET)
	public String region_search3(@RequestParam("search") String search, Model model) {
	    HotelVO vo = new HotelVO();
	    vo.setAddress(search);
	    vo.setName(search);

	    // 데이터베이스에서 검색 결과 가져오기
	    List<HotelVO> hotels = dao.select_region3(vo);

	    model.addAttribute("hotel_list", hotels);
	    return "hotellist";  // 호텔 목록 페이지로 이동
	}
	
	@RequestMapping(value = "/hoteldetail", method = RequestMethod.GET)
	public String gotohoteldetail(@RequestParam("name") String name, Model model) {
		HotelVO vo = new HotelVO();
		vo.setName(name);
		model.addAttribute("hotel", hdao.select_hotel(vo));
		System.out.println(hdao.select_hotel(vo).getName());
		
		return "hoteldetail";
	}
	
	@RequestMapping(value = "/hoteldetailbytype", method = RequestMethod.GET)
	public String gotohoteldetailbytype(@RequestParam("name") String name, Model model) {
		HotelVO vo = new HotelVO();
		vo.setName(name);
		model.addAttribute("hotelInfobytype", hdao.gotohoteldetailbytype(name));
		
		return "hoteldetailbytype";
		
	}
	
	@RequestMapping(value = "/hotelreservation", method = RequestMethod.GET)
	public String gotoreservation(@RequestParam("name")		String name,  
								  @RequestParam("roomType") String roomType,
								  @RequestParam("price")	String price,
								  Model model) {
		HotelVO hotelInfobytype = hdao.gotoreservation(name);
		
	    model.addAttribute("hotelInfo", hotelInfobytype);
	    model.addAttribute("roomType", roomType);
	    model.addAttribute("price", price);

	    return "hotelreservation";
	}
	
	@RequestMapping(value = "/hotelreservationbytype", method = RequestMethod.GET)
	public String gotoreservationbytype(@RequestParam("name") String name,  
			@RequestParam("roomType") String roomType,
	        @RequestParam("price") String price, Model model) {

		HotelVO hotelInfo = hdao.gotoreservation(name);
	    model.addAttribute("hotelInfobytpye", hotelInfo);
	    
	    model.addAttribute("roomType", roomType);
	    model.addAttribute("price", price);

	    return "hotelreservationbytype";
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
			  					   @RequestParam("person")		 String person) {
		 rdao.insert_info(imp_uid, product_name, cost, email, name, tel, address, dateRange, dateStr, person);

		 return "main";
	 }
	 @GetMapping("/session-expired")
	    public String sessionExpired(@RequestParam("name") String name,Model model) {
			model.addAttribute("hotelName", name); // 동적 값 설정
	        return "sessionExpired"; // 세션 만료 안내 페이지로 이동
	    }
	 @GetMapping("/session-expired1")
	    public String sessionExpired1(@RequestParam("name") String name,Model model) {
			model.addAttribute("hotelName", name); // 동적 값 설정
	        return "sessionExpired1"; // 세션 만료 안내 페이지로 이동
	    }
	 @Autowired
	 HotelReviewDAO reviewDao;

	 @GetMapping("/getReviews")
	 public String getReviews(@RequestParam("default_num") String defaultNum, Model model) {
		 System.out.println("defaultNum : "+defaultNum);
	     List<HotelReviewVO> reviews = reviewDao.getReviewsByHotel(defaultNum);
	     System.out.println("reviews : "+reviews);
	     model.addAttribute("reviews", reviews);
	     return "hoteldetail";
	 }


	 @PostMapping("/addReview")
	 public String addReview(@RequestParam String username,HotelReviewVO review) {
		 System.out.println("username : "+username);
	     // userId가 없을 경우 "anonymous"로 기본값 설정
	     review.setUserId(username); /* 세션이나 요청에서 userId를 가져오는 로직 */;
	     // 리뷰 저장
	     System.out.println("review123 : "+review.getDefaultNum());
	     System.out.println("review123 : "+review.getRating());
	     reviewDao.insertReview(review);
	     System.out.println("review1234 : "+review.getRating());
	     return "redirect:/regionsearch5?default_num=" + review.getDefaultNum();
	 }
	 

}
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

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import org.springframework.web.util.HtmlUtils;

@Controller
public class HotelController {
	@Autowired
	RegionSearchDAO dao;
	// ㅇㄹㅇㄴ
	@Autowired
	HotelSearchDAO hdao;
	@Autowired
	ReservationDAO rdao;
	@Autowired
	private HotelDAO hotelDAO; // HotelDAO 인스턴스 변수로 선언
	@Autowired
	private HotelReviewDAO hotelReviewDAO;
	@Autowired
	FavoritesDAO fdao;

	@RequestMapping(value = "/", method = RequestMethod.GET)
	public String main(Model model) {
		HotelVO vo = new HotelVO();

		model.addAttribute("hotel_list", dao.select_region4(vo));
		return "mainpage/main";
	}

	@PostMapping("/toggleFavorite")
	@ResponseBody
	public Map<String, Object> toggleFavorite(@RequestBody Map<String, String> payload) {
		String default_num = payload.get("default_num");
		String username = payload.get("username");


		if (username == null) {
			System.out.println("사용자가 로그인하지 않았습니다.");
			return Collections.singletonMap("favorited", false);
		}

		boolean favorited;

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
	public String region_search(String region, Model model) {

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

		// 모델에 데이터 추가
		model.addAttribute("hotel", hotel);
		model.addAttribute("defaultNum", defaultNum);
		model.addAttribute("reviews", reviews);
		int parsedPrice = Integer.parseInt(hotel.suite.replace(",", ""));



		return "hotel/hoteldetail";
	}

	@RequestMapping(value = "/regionsearch3", method = RequestMethod.GET)
	public String region_search3(@RequestParam("search") String search, Model model) {
		HotelVO vo = new HotelVO();
		vo.setAddress(search);
		vo.setName(search);

		// 데이터베이스에서 검색 결과 가져오기
		List<HotelVO> hotels = dao.select_region3(vo);

		model.addAttribute("hotel_list", hotels);
		return "hotel/hotellist"; // 호텔 목록 페이지로 이동

	}

	@RequestMapping(value = "/hoteldetail", method = RequestMethod.GET)
	public String gotohoteldetail(@RequestParam("name") String name, Model model, HttpSession session) {
		HotelVO vo = new HotelVO();
		vo.setName(name);
		model.addAttribute("hotel", hdao.select_hotel(vo));

		return "hotel/hoteldetail";
	}

	@GetMapping("/hotelreservation")
	public String hotelReservation(HttpSession session, Model model, HttpServletResponse response) {
		response.setHeader("Cache-Control", "no-store, no-cache, must-revalidate, max-age=0");
		response.setHeader("Pragma", "no-cache");
		response.setDateHeader("Expires", 0);

		// sessionActive 기본값 설정

		// 나머지 세션 속성 로드 및 검증
		String hotelName = (String) session.getAttribute("HotelName");
		String roomType = (String) session.getAttribute("RoomType");
		Integer price = (Integer) session.getAttribute("Price");
		String defaultNum = (String) session.getAttribute("defaultNum");
		Boolean sessionActive = (Boolean) session.getAttribute("sessionActive");
		if (sessionActive == null) {
			session.setAttribute("sessionActive", false); // 기본값 비활성화 설정
			return "redirect:/session-expired?name=" + defaultNum;
		}

		if (!sessionActive) {
			return "redirect:/session-expired?name=" + defaultNum;
		}
		if (hotelName == null || roomType == null || price == null || defaultNum == null) {
			return "redirect:/session-expired?name=" + defaultNum;
		}

		HotelVO hotelInfo = hotelDAO.getHotelByDefaultNum(defaultNum);
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

		List<HotelVO> hotels = hdao.selectHotelsByType(type);

		return hotels;
	}

	@ResponseBody
	@PostMapping("/reservation_clear")
	public void paymentByImpUid(@RequestBody String imp_uid) {

	}

	@RequestMapping(value = "/payment_success", method = RequestMethod.POST)
	public String payment_success(HttpServletRequest request, @RequestParam("imp_uid") String imp_uid,
			@RequestParam("product_name") String product_name, @RequestParam("cost") int cost,
			@RequestParam("email") String email, @RequestParam("name") String name, @RequestParam("tel") String tel,
			@RequestParam("address") String address, @RequestParam("dateRange") String dateRange,
			@RequestParam("dateStr") String dateStr, @RequestParam("person") String person, HttpSession session) {
		String roomType = (String) session.getAttribute("RoomType");
		String default_num = (String) session.getAttribute("defaultNum");

		int expectedPrice = (int) session.getAttribute("Price");

		String hotel_name = (String) session.getAttribute("HotelName");
		rdao.insert_info(imp_uid, hotel_name, expectedPrice, email, name, tel, address, dateRange, dateStr, person,
				default_num);
		session.setAttribute("defaultNum", default_num);
		return "redirect:/#PAYMENTSUCCESS";
	}

	@GetMapping("/session-expired")
	public String sessionExpired(@RequestParam("name") String name, Model model) {
		model.addAttribute("hotelName", name); // 동적 값 설정
		return "error/sessionExpired"; // 세션 만료 안내 페이지로 이동
	}

	@Autowired
	HotelReviewDAO reviewDao;

	@GetMapping("/getReviews")
	public String getReviews(@RequestParam("default_num") String defaultNum, Model model) {

		List<HotelReviewVO> reviews = reviewDao.getReviewsByHotel(defaultNum);

		model.addAttribute("reviews", reviews);
		return "hotel/hoteldetail";
	}

	@PostMapping("/addReview")
	public String addReview(@RequestParam String username, HotelReviewVO review) {
		String safeOutput = HtmlUtils.htmlEscape(review.getReviewText());

		if (review.getReviewText().matches("^[a-zA-Z0-9가-힣ㄱ-ㅎㅏ-ㅣ .,!?\\n\\r]*$")) {
			// 유효한 입력
		} else {
			throw new IllegalArgumentException("Invalid input");
		}

		// userId가 없을 경우 "anonymous"로 기본값 설정
		review.setUserId(username);
		/* 세션이나 요청에서 userId를 가져오는 로직 */;
		// 리뷰 저장
		

		reviewDao.insertReview(review);

		return "redirect:/regionsearch5?default_num=" + review.getDefaultNum();
	}

	@PostMapping("/chooseRoom")
	public String chooseRoom(@RequestParam("roomType") String roomType, @RequestParam("hotelName") String hotelName,
			@RequestParam("price") String price, @RequestParam("defaultNum") String defaultNum, HttpSession session,
			Model model) {


		// 데이터 검증: DB에서 방 타입과 가격 확인
		int parsedPrice = Integer.parseInt(price.replace(",", ""));

		List<RoomTypePrice> roomTypePrices = hdao.getRoomTypesAndPrices(defaultNum);

		boolean valid = roomTypePrices.stream()
				.anyMatch(rtp -> rtp.getRoomType().equals(roomType) && rtp.getPrice() == parsedPrice);

		if (!valid) {
			throw new IllegalArgumentException("Invalid room type or price. Possible tampering detected.");
		}
		session.setAttribute("sessionActive", true);
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
	public String region_search2(String type, Model model) {

		HotelVO vo = new HotelVO();
		vo.setType(type);

		model.addAttribute("hotel_list", dao.select_region6(vo));

		return "hotel/hotellist";
	}

	// Controller에서 /favicon.ico을 처리하는 메소드에 리턴값이 없게 함(로그인 이후 favicon 파일로 인해 발생하는 문제
	// 처리)
	@GetMapping("/favicon.ico")
	@ResponseBody
	public void returnNoFavicon() {

	}
}
package com.example.demo.vo;

public class RoomTypePrice {
    private String roomType;
    private int price;

    // 기본 생성자
    public RoomTypePrice() {
    }

    // 매개변수 있는 생성자
    public RoomTypePrice(String roomType, int price) {
        this.roomType = roomType;
        this.price = price;
    }

    // Getter와 Setter
    public String getRoomType() {
        return roomType;
    }

    public void setRoomType(String roomType) {
        this.roomType = roomType;
    }

    public int getPrice() {
        return price;
    }

    public void setPrice(int price) {
        this.price = price;
    }

    @Override
    public String toString() {
        return "RoomTypePrice{" +
                "roomType='" + roomType + '\'' +
                ", price=" + price +
                '}';
    }
}

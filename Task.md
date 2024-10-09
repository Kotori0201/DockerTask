## Task 1: Setup 4 server A, B, C, D chạy Ubuntu server 20.04. Trong đó A chạy docker client, B, C và D chạy docker host

## Task 2: Tạo và chỉ dùng user devops để SSH vào 4 server trên bằng key: Host ở server A, connect A to B, C và D

## Task 3: Self-host Docker Registry service trên server B, cổng 5555

## Task 4: Từ server A build image và push lên Docker Registry ở server B với yêu cầu cho image như sau:

    - Base image: Ubuntu 20.04 (nếu lỗi có thể sử dụng version khác)
    - Install Nginx và cấu hình in ra chữ "Hello DO1 team" ở trang chính. Truy cập /v1 in ra chữ "Version 1", /v2 in ra chữ "Version 2". Log được lưu ở 2 file access.log và error.log.
    - Tại đường dẫn /home/user/devops/ phải có file devops.txt có nội dung chính là file html của trang chính.
    - Phải có biến môi trường DEVOPS có giá trị "This is DO1 team"
    - Mount file config từ bên ngoài vào trong server
    - Expose cổng 1234.
    - Docker work directory: /home/okay/workdir
    - Không dùng user root và user mặc định
    - Có healthcheck để determines state của Nginx service
    - Gán label:
        - env: dev
        - name: nginx-service

## Task 5: Từ server A run command tạo container trên server C từ image vừa tạo bằng cách pull từ Docker Registry service. Inspect container vừa tạo và giải thích. Sau đó dọn dẹp sạch container vừa tạo

## Task 6: Trình bày các phương án build để giảm size image và giải thích & demo

## Task 7: Từ server A run command tạo 2 container với image tùy ý (lưu ý phải push lên Docker Registry và pull về) trên server B và C và dùng chung volume (Persistent cho server B và Ephemeral cho server C) và share file qua nhau

## Task 8: Triển khai plan backup data của 2 container ở task 7 sang server D

## Task 9: Dọn dẹp 2 container và data đã tạo ở server B và C. Sau đó restore lại status infra ở task 7: Của C sang B và của B sang C

## Task 10:: Chạy ở server D:

    - Dùng docker compose để triển khai container MySQL 5.7 với username và password
    - Kết nối container chạy ở task 4 vào MYSQL
    - Update docker compose để chạy img ở task 4

## Task 11: Giải thích về networking trong docker và demo từng loại.

## Task 12: (It's a plus for you) Sử dụng Trivy để quét lổ hổng bảo mật image ở Task 4, giải thích và đưa ra phương án fix & demo
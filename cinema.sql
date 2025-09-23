CREATE TABLE korean_movies (
    movie_id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(200) NOT NULL,      -- 영화 제목
    genre VARCHAR(80),                -- 장르
    director VARCHAR(120),            -- 감독
    release_year YEAR,                -- 개봉연도
    runtime_min INT,                  -- 러닝타임(분)
    rating DECIMAL(3,1),              -- 평점 (10점 만점)
    box_office_million BIGINT         -- 흥행 (단위: 만 명 관객 혹은 백만 달러)
) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

INSERT INTO korean_movies
(title, genre, director, release_year, runtime_min, rating, box_office_million)
VALUES
('기생충', 'Thriller', '봉준호', 2019, 132, 8.6, 263),
('살인의 추억', 'Crime', '봉준호', 2003, 131, 8.1, 15),
('괴물', 'Sci-Fi', '봉준호', 2006, 119, 7.1, 89),
('설국열차', 'Sci-Fi', '봉준호', 2013, 126, 7.1, 87),
('올드보이', 'Thriller', '박찬욱', 2003, 120, 8.4, 15),
('아가씨', 'Romance', '박찬욱', 2016, 145, 8.1, 38),
('친절한 금자씨', 'Thriller', '박찬욱', 2005, 115, 7.6, 23),
('신세계', 'Crime', '박훈정', 2013, 134, 7.7, 47),
('범죄와의 전쟁', 'Crime', '윤종빈', 2012, 133, 7.7, 47),
('곡성', 'Horror', '나홍진', 2016, 156, 7.5, 51),
('추격자', 'Thriller', '나홍진', 2008, 125, 7.9, 51),
('황해', 'Crime', '나홍진', 2010, 157, 7.3, 25),
('부산행', 'Action', '연상호', 2016, 118, 7.6, 98),
('반도', 'Action', '연상호', 2020, 116, 5.5, 42),
('변호인', 'Drama', '양우석', 2013, 127, 8.0, 113),
('도둑들', 'Action', '최동훈', 2012, 135, 7.0, 130),
('암살', 'Action', '최동훈', 2015, 140, 7.2, 127),
('명량', 'Action', '김한민', 2014, 128, 7.1, 176),
('한산: 용의 출현', 'Action', '김한민', 2022, 130, 6.7, 57),
('택시운전사', 'Drama', '장훈', 2017, 137, 7.8, 121);

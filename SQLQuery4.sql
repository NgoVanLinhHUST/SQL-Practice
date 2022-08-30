﻿---------
-- NEU LUONG > LTB => KHONG TANG LUONG
-- NEU LUONG < LTB => TANG LUONG
---------
DECLARE @THONGKE TABLE ( PHG VARCHAR , LTB INT)
INSERT INTO @THONGKE SELECT PHG, AVG(LUONG) AS 'LTB' FROM NHANVIEN
GROUP BY PHG

SELECT a.TENNV, a.LUONG, 'TINH TRANG' = IIF(a.LUONG > b.LTB, 'KHONG TANG LUONG', 'TANG LUONG')
FROM NHANVIEN a INNER JOIN @THONGKE b ON a.PHG = b.PHG

DECLARE @THONGKE TABLE ( PHG VARCHAR , LTB INT)
INSERT INTO @THONGKE SELECT PHG, AVG(LUONG) AS 'LTB' FROM NHANVIEN
GROUP BY PHG

SELECT a.TENNV, a.LUONG, 'TINH TRANG' = IIF(a.LUONG > b.LTB, 'KHONG TANG LUONG', 'TANG LUONG')
FROM NHANVIEN a INNER JOIN (SELECT PHG, AVG(LUONG) AS 'LTB' FROM NHANVIEN GROUP BY PHG) b ON a.PHG = b.PHG
---------
-- NEU LUONG > LTB => TRUONG PHONG
-- NEU LUONG < LTB => NHAN VIEN
DECLARE @THONGKE TABLE ( PHG VARCHAR , LTB INT)
INSERT INTO @THONGKE SELECT PHG, AVG(LUONG) AS 'LTB' FROM NHANVIEN
GROUP BY PHG

SELECT a.TENNV, a.LUONG, 'CHUC VU' = IIF(a.LUONG > b.LTB, 'TRUONG PHONG', 'NHAN VIEN')
FROM NHANVIEN a INNER JOIN @THONGKE b ON a.PHG = b.PHG
-----
SELECT * FROM NHANVIEN

SELECT TENNV , 'TEN UPDATE' = IIF( PHAI = 'NỮ' , 'Ms. '+TENNV , 'Mr. ' + TENNV)

FROM NHANVIEN 
--- CHO BIET TEN NV CO MA SO LA SO CHAN
DECLARE @NUM INT, @MAX INT
SET @NUM = 1
SELECT @MAX = MAX(CAST(MANV AS INT)) FROM NHANVIEN
WHILE @NUM <= @MAX
BEGIN

	IF( @NUM %2 =0) 
		SELECT MANV,HONV, TENLOT, TENNV FROM NHANVIEN 
		WHERE CAST(MANV AS INT) = @NUM
	SET @NUM = @NUM + 1
END
-----------
--- CHO BIET TEN NV CO MA SO LA SO CHAN KO LAY SO 4
DECLARE @NUM INT, @MAX INT
SET @NUM = 1
SELECT @MAX = MAX(CAST(MANV AS INT)) FROM NHANVIEN
WHILE @NUM <= @MAX
BEGIN
	IF(@NUM =4)
		BEGIN
		SET @NUM = @NUM + 1
		CONTINUE
		END
	IF( @NUM %2 =0) 
		SELECT MANV,HONV, TENLOT, TENNV FROM NHANVIEN 
		WHERE CAST(MANV AS INT) = @NUM
	SET @NUM = @NUM + 1
END

----PROCEDURE----
-- truy xuat thong tin nhan vien khi nhap nam sinh vao
SELECT * FROM NHANVIEN
CREATE PROCEDURE sp_quertByYearOfBirth @YearOfBirth int 
AS BEGIN 
	SELECT * FROM NHANVIEN
	WHERE DATENAME(YEAR, NGSINH) = @YearOfBirth;
END


EXEC sp_quertByYearOfBirth 1960
---dem so luong nhan than 
SELECT * FROM THANNHAN
SELECT * FROM NHANVIEN


CREATE PROCEDURE sp_quertByEmployeeCode @EmployeeCode nvarchar(9) 
AS BEGIN 
	SELECT MA_NVIEN, COUNT(MA_NVIEN) AS 'SOLUONG'
	FROM THANNHAN
	WHERE MA_NVIEN = @EmployeeCode
	GROUP BY MA_NVIEN
END

EXEC sp_quertByEmployeeCode '005';

------
CREATE PROC sp_tongSoNguyenN @SoNguyen int
AS BEGIN
	DECLARE @N INT, @SUM INT , @COUNT_EVE INT
	SET @SUM =0
	SET @N = 1
	SET @COUNT_EVE = 0
	WHILE @N <= @SONGUYEN
		BEGIN
			IF(@N %2 =0)
			BEGIN
				SET @COUNT_EVE = @COUNT_EVE + 1
				SET @SUM = @SUM + @N
			END
			SET @N = @N+1
		END
		PRINT'TONG SO NGUYEN LA: ' +CAST(@SUM AS VARCHAR) 
		PRINT'TONG SO CHAN LA: ' +CAST(@COUNT_EVE AS VARCHAR)
END

EXEC sp_tongSoNguyenN 6
DROP PROC sp_tongSoNguyenN

---- THEM PHONG BAN -----
CREATE PROCEDURE sp_InsertPhongBan 
	@TENPHG nvarchar(15) ,
	@MAPHG int ,
	@TRPHG nvarchar(9) ,
	@NG_NHANCHUC date 
AS
BEGIN
	SET NOCOUNT ON;
	IF EXISTS ( SELECT * FROM PHONGBAN WHERE MAPHG = @MAPHG)
	BEGIN
		PRINT 'CHEN DU LIEU THAT BAT'
		RETURN;
	END
	INSERT INTO [dbo].[PHONGBAN]
           ([TENPHG]
           ,[MAPHG]
           ,[TRPHG]
           ,[NG_NHANCHUC])
		VALUES
           (@TENPHG,@MAPHG,@TRPHG,@NG_NHANCHUC);
		
		PRINT 'CHEN DU LIEU	THANH CONG'
END

----- execution proceduce phong ban ----
USE [QLDA]
GO

DECLARE	@return_value int

EXEC	@return_value = [dbo].[sp_InsertPhongBan]
		@TENPHG = N'SAN XUAT hang hoa',
		@MAPHG = '004',
		@TRPHG = N'20',
		@NG_NHANCHUC = '2-1-2021'

SELECT	'Return Value' = @return_value

GO
-----xoa proceduce phong ban -------
DROP PROC sp_InsertPhongBan
-----------
-----------
-- PROCEDUCE XIN CHAO NAME 
ALTER PROCEDUCE sp_HELLO
	@TEN NVARCHAR(30)
AS BEGIN
	PRINT ' XIN CHÀO ' + @TEN
END
EXEC  sp_HELLO BÁCH
-----
------
ALTER PROC sp_Tong 
	@S1 INT, @S2 INT 
AS BEGIN 
	DECLARE @TONG INT 
	SET @TONG = @S1+@S2
	PRINT 'TONG CUA ' + CAST (@S1 AS VARCHAR) +' VA ' + CAST(@S2 AS VARCHAR) + ' LA:' + CAST(@TONG AS VARCHAR)
END
EXEC sp_Tong 3,5
-----
ALTER PROC sp_queryEmployeeByID 
	@MANV VARCHAR(9)
AS BEGIN
	SELECT * FROM NHANVIEN 
	WHERE MANV = @MANV
END 
EXEC sp_queryEmployeeByID  '001'
-----
CREATE PROC sp_queryByMaDA
		@MADA INT 
AS BEGIN
	SELECT COUNT(b.MANV) FROM DEAN a JOIN NHANVIEN b ON a.PHONG = b.PHG 
	WHERE a.MADA = @MADA
	GROUP BY MADA
END
EXEC sp_queryByMaDA 30
----KTRA NHAN VIEN CO MA @MANV CO THUOC @MAPB HAY K
ALTER PROC sp_checkNVinPB
	@MANV VARCHAR(9), @MAPB INT
AS BEGIN
	SELECT TENNV, 'CHECK PHONG BAN ' = IIF(@MAPB = ( SELECT c.MAPHG FROM (SELECT a.MANV, b.MAPHG FROM NHANVIEN a
JOIN PHONGBAN b ON b.MAPHG = a.PHG ) c
	WHERE c.MANV = @MANV) , 'YES','NO') FROM NHANVIEN
	WHERE MANV = @MANV
END
EXEC sp_checkNVinPB '001',4



SELECT * FROM PHONGBAN
SELECT * FROM NHANVIEN



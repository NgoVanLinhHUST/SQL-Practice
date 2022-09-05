-------------------
------trigger------
-------------------
--- INSERT AND UPDATE FOR LUONG !< 5000
-----
select * from NHANVIEN
CREATE TRIGGER check_luong on NHANVIEN
FOR insert AS
if ( SELECT luong from INSERTED ) < 5000
BEGIN 
	PRINT N'LUONG PHAI LON HON 5000'
	ROLLBACK TRANSACTION
END

CREATE TRIGGER CHECK_LUONG_UPDATE ON NHANVIEN
FOR UPDATE AS
if ( SELECT luong from INSERTED ) < 5000
BEGIN 
	PRINT N'LUONG PHAI LON HON 5000'
	ROLLBACK TRANSACTION
END
----EXECUTION----
UPDATE NHANVIEN SET LUONG = 3000 WHERE MANV LIKE '005'
DROP TRIGGER CHECK_LUONG
-----
--TRIGGER CANT DELETE EMPLOYEE LIVE IN HCM
SELECT * FROM NHANVIEN

CREATE TRIGGER NOT_DELETE_EMPLOYEE_HCM ON NHANVIEN
FOR DELETE 
AS 
	IF(EXISTS(SELECT DCHI FROM DELETED WHERE DCHI LIKE '%HCM%' OR DCHI LIKE '%HỒ%')) 
BEGIN 
	PRINT 'KHONG THE XOA NHAN VIEN O HCM'
	ROLLBACK TRANSACTION
END

	DELETE FROM NHANVIEN WHERE MANV = '111'
DROP TRIGGER NOT_DELETE_EMPLOYEE_HCM
----
--trigger instead of
------
CREATE TRIGGER trg_DeleteRefEmpl 
ON Nhanvien
INSTEAD OF DELETE
AS
	DELETE FROM THANNHAN WHERE MA_NVIEN IN ( SELECT MANV FROM DELETED)
	DELETE FROM NHANVIEN WHERE MANV IN (SELECT MANV FROM DELETED)
		
	DELETE FROM NHANVIEN WHERE MANV='017'

SELECT *FROM NHANVIEN
---trigger them nhanvien > 15000 va tuoi trong khoang 18 den 65

CREATE TRIGGER trg_AddEmp ON NHANVIEN 
FOR INSERT AS
Begin 
	if ( SELECT Luong from inserted ) < 15000
		print 'luong phai lon hon 15000'
	if (SELECT FLOOR((CAST (GetDate() AS INT) - CAST(ngsinh AS INT)) / 365.25) AS Age from inserted  ) <= 18
	Or (SELECT FLOOR((CAST (GetDate() AS INT) - CAST(ngsinh AS INT)) / 365.25) AS Age from inserted ) >= 65
		print ' tuoi phai nam trong khoang 18 den 65 '	

	rollback transaction
end
select * from nhanvien
delete from nhanvien where tennv = 'linh'
INSERT INTO [dbo].[NHANVIEN]
           ([HONV],[TENLOT],[TENNV],[MANV],[NGSINH],[DCHI],[PHAI],[LUONG],[MA_NQL],[PHG])
     VALUES
           (N'Nguyễn',N'quang',N'linh','095','01-01-2010','ha Noi' ,'nam',13000,'005',4)
GO
-------TRIGGER khong duoc update thong tin nhan vien o HCM
CREATE TRIGGER trg_updateEmp On NHANVIEN
For UPDATE 
as  
	if exists ( select dchi from inserted where dchi like '%hcm%' or dchi like '%hồ%')
	begin
	print 'khong dc cap nhat nhanvien o Ho Chi Minh'
	rollback transaction
	end

UPDATE NHANVIEN 
SET PHAI ='nam'
where MANV = '001'
---------
--ALTER TRIGGER
-------
--- hien thi tong nhan vien nam va nu moi khi them moi nhanvien
CREATE TRIGGER trg_countEmpl
ON NHANVIEN 
AFTER INSERT
AS 
	declare @Male int, @Female int 
	Select @Female = count(manv) from NHANVIEN where phai = N'Nữ'
	Select @Male = count(manv) from NHANVIEN where phai = N'Nam'
	Print N'Tổng số nhân viên nữ là: ' + cast(@Female as varchar)
	Print N'Tổng số nhân viên nam là: ' + cast(@Male as varchar)

SELECT * FROM NHANVIEN

INSERT INTO [dbo].[NHANVIEN]
           ([HONV],[TENLOT],[TENNV],[MANV],[NGSINH],[DCHI],[PHAI],[LUONG],[MA_NQL],[PHG])
     VALUES
           (N'A',N'VV',N'LLL','09','01-01-1999','bacgiang' ,'Nam',35000,'003',1)
GO

select * from DEAN
select * from PHANCONG
CREATE TRIGGER trg_countDeAn ON DEAN
AFTER DELETE
AS
	select  MA_NVIEN, Count(MADA) as N'Tong so de an da tham gia ' from PHANCONG
	group by MA_NVIEN

DELETE FROM DEAN WHERE MADA= 3
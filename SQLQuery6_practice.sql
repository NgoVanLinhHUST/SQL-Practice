select * from nhanvien

declare @thongke table ( tennv nvarchar(10), luong float, phg int )
insert into @thongke 
select tennv, max(luong), phg 
from nhanvien
group by luong, phg, tennv
order by phg asc
select phg, luong, tennv from @thongke
order by phg
------
-- tim nhan vien luong cao nhat moi phong
	select top 1 n1.tennv, max(n1.luong), n1.phg 
	from nhanvien n1 inner join nhanvien n2
	on n1.luong <= n2.luong and n1.phg = n2.phg
	group by n1.luong, n1.phg, n1.tennv
	having count(distinct n1.luong) =1
	order by phg 



SELECT phg, tennv, luong FROM nhanvien WHERE  exists 
(SELECT phg, MAX(luong) FROM nhanvien GROUP BY phg)

 WITH cteRowNum AS 
 (SELECT phg, tennv, luong,
           DENSE_RANK() OVER(PARTITION BY phg ORDER BY luong DESC) AS RowNum
        FROM nhanvien )


SELECT phg, tennv, luong, rownum
    FROM  (SELECT phg, tennv, luong,
           DENSE_RANK() OVER(PARTITION BY phg ORDER BY luong DESC) AS RowNum
        FROM nhanvien) n2
    WHERE RowNum = 1;

SELECT tennv,phg,luong
FROM nhanvien
WHERE luong IN
  (SELECT max(luong) AS luong
   From nhanvien
   GROUP BY phg)




set statistics time on
Select * from orders 
Select * from store
Select getdate();

Select  order_id, max(profit) as 'max_prf' from orders 
where order_date between '2014-01-01' and '2015-01-01'
group by order_id

delete from orders
where row_id in ( 
Select row_id From Orders a
group by row_id
having count(*) >1 )
-----extract day that have profit is more than previous day.
SET STATISTICS TIME ON
select a.order_date from orders a inner join 
orders b on datediff(day,b.order_date, a.order_date) = 1
group by a.order_date
having sum(a.profit)  > sum(b.profit)
order by order_date desc
----
truncate table orders
select * into order2
from orders 
where 1=0
select * from order2

select tennv, phg, luong from nhanvien 
where luong in(
select max(luong) from nhanvien group by phg)

Select tennv, phg, luong from (
SELECT  tennv, phg, luong, DENSE_RANK() OVER(partition by phg ORDER BY luong desc) AS stt FROM nhanvien) n2
where stt = 1

with customers as
(select honv, tenlot, tennv
from nhanvien
where phg = 4)
select * from customers;


Select tennv, phg, luong, stt from (
SELECT  tennv, phg, luong, DENSE_RANK() OVER(partition by phg ORDER BY luong desc) AS stt FROM nhanvien) n2

Select tennv, phg, luong, stt from (
SELECT  tennv, phg, luong, ROW_NUMBER() OVER( ORDER BY luong desc) AS stt FROM nhanvien) n2

Select tennv, phg, luong, stt from (
SELECT  tennv, phg, luong, RANK() OVER( ORDER BY luong desc) AS stt FROM nhanvien) n2


select * from orders
Select row_id FROM orders WHERE row_id <>
(Select max (row_id) from orders b where row_id=b.row_id);
Delete FROM orders WHERE row_id <>
(Select max (row_id) from orders b where row_id=b.row_id);

Select ROW_ID, count (ROW_ID) from ORDERS
Group by ROW_ID 
Having count (ROW_ID)>1 Order by ROW_ID
------------
--function check so chan
-----------
CREATE FUNCTION checkOdd(@Num INT)
RETURNS NVARCHAR(20)
AS 
BEGIN
	IF(@Num % 2 =1) 
		RETURN N'SO LE'
	ELSE 
		RETURN N'SO CHAN'
	RETURN N'KHONG XAC DINH'
END

SELECT dbo.checkOdd(11)


select * from orders

alter function UF_selectOrderByID(@Id int)
returns table
as 	return select * from dbo.orders where row_id = @Id;


select * from dbo.UF_selectOrderByID(4)
select dbo.UF_selectOrderByID(row_id) from dbo.orders

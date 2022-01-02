-- Tạo database Task06
create database Task06
go

use Task06
go

--Tạo bảng PhongBan
create table PhongBan(
    MaPB varchar(7) primary key,
	TenPB Nvarchar(50)
)
go

--Tạo bảng NhanVien
create table NhanVien(
    MaNV varchar(7) primary key,
	TenNV nvarchar(50),
	NgaySinh Datetime check(NgaySinh < getDate()),
	SoCMND char(9) check(SoCMND > 0),
	GioiTinh char(1) check(GioiTinh = 'M' or GioiTinh = 'F') default('M') not null,
    DiaChi nvarchar(100),
	NgayVaoLam Datetime,check((YEAR(NgayVaoLam) - YEAR(NgaySinh)) > 20),
	MaPB varchar(7) foreign key references PhongBan(MaPB)
)
go

--Tạo bảng LuongDA
create table LuongDA(
    MaDA varchar(8),
	MaNV varchar(7) foreign key references NhanVien(MaNV),
	primary key(MaDA, MaNV),
	NgayNhan Datetime not null default(getDate()),
	Sotien money check(Sotien > 0)
)
go

--1
insert into PhongBan values ('PB1', N'Phòng Ban 1'),
                            ('PB2', N'Phòng Ban 2'),
							('PB3', N'Phòng Ban 3'),
							('PB4', N'Phòng Ban 4'),
							('PB5', N'Phòng Ban 5')

insert into NhanVien
values ('NV01', N'Nguyễn Văn A', '1985-01-01', '536412225','M',N'Đông Anh-Hà Nội', '2015-01-25', 'PB2'),
       ('NV02', N'Nguyễn Văn B', '1985-05-09', '136415922','M',N'Đông Anh-Hà Nội', '2015-01-25', 'PB1'),
       ('NV03', N'Nguyễn Văn C', '1988-01-05', '264152229','M',N'Đông Anh-Hà Nội', '2015-01-25', 'PB5'),
       ('NV04', N'Nguyễn Thị G', '1982-06-01', '236425229','F',N'Đông Anh-Hà Nội', '2015-01-25', 'PB4'),
       ('NV05', N'Nguyễn Thị K', '1989-06-20', '256125229','F',N'Đông Anh-Hà Nội', '2015-01-25', 'PB3'),
       ('NV06', N'Nguyễn Thị J', '1990-05-01', '234125119','F',N'Đông Anh-Hà Nội', '2015-01-25', 'PB2')

insert into LuongDA values ('DA1', 'NV01', '', 100000000 ),
                           ('DA2', 'NV02', '', 105665650 ),
						   ('DA3', 'NV03', '', 100522200 ),
						   ('DA4', 'NV04', '', 150000000 ),
						   ('DA5', 'NV05', '', 200000000 ),
						   ('DA6', 'NV06', '', 213000000 ),
						   ('DA7', 'NV05', '', 1000000 )


--2
select * from PhongBan
select * from NhanVien
select * from LuongDA

--3 Các nhân viên giới tính là F
select * from NhanVien
where GioiTinh = 'F'

--4 Hiển thị các dự án mỗi dự án trên 1 dòng 
select MaDA from LuongDA

--5 Tổng lương của từng nhân viên 
select MaNV,SUM(SoTien) as 'TongLuong'   
from LuongDA
group by MaNV

--6 Hiển thị các nhân viên trên 1 phòng ban cho trước 
select * from NhanVien
where MaPB = 'PB2'

--7 Mức lương nhân viên trong phòng hành chính 
select MaNV, SoTien from LuongDA
where MaNV in
(select MaNV from NhanVien
where MaPB = 'PB2')

--8 Hiển thị số lượng nhân viên của từng phòng.
select MaPB, count(*) as 'NV'
from NhanVien
group by MaPB
order by MaPB

--9 Hiển thị những nhân viên mà tham gia ít nhất vào một dự án.
select MaNV, count(MaDA) as N'Số dự án tham gia'  
from LuongDA
group by MaNV
having count(MaDA) > 0

select TenNV  from NhanVien
where MaNV in
(select count(MaDA)
from LuongDA
group by MaDA
having count(MaDA) > 0)

--10 Hiển thị phòng ban có số lượng nhân viên nhiều nhất.
select TenPB from PhongBan
where MaPB in
(select MaPB, sum(MaPB)
from NhanVien
group by MaPB
having max(MaPB))

--11 Tổng số lượng của các nhân viên trong phòng Hành chính.
SELECT COUNT(MaNV) AS 'TongNV'
FROM dbo.NhanVien
WHERE MaPB = 'PB1'
GROUP BY MaNV

--12 Hiển thị tổng lương của các nhân viên có CMT tận cùng là 9
SELECT TenNV, SoCMND, SUM(SoTien) AS 'TongLuong'
FROM dbo.NhanVien 
INNER JOIN dbo.LuongDA ON LuongDA.MaNV = NhanVien.MaNV
WHERE RIGHT(SoCMND,1) = '9'
GROUP BY  TenNV, SoCMND

--13 Nhân viên có số lương cao nhất.
SELECT * FROM
( 
    SELECT MaNV, SUM(SoTien) AS Luong
	FROM dbo.LuongDA
    GROUP BY  MaNV
) AS TongLuong
WHERE TongLuong.Luong = (
    SELECT MAX(TongLuong.Luong) FROM 
    (   
	     SELECT MaNV, SUM(SoTien) AS Luong 
		 FROM dbo.LuongDA
		 GROUP BY MaNV
	) AS Luong
)


--14 Nhân viên ở phòng Hành chính có giới tính bằng ‘F’ và có mức lương > 1200000.
SELECT * FROM dbo.NhanVien
INNER JOIN dbo.LuongDA ON LuongDA.MaNV = NhanVien.MaNV
WHERE dbo.NhanVien.GioiTinh = 'F' AND dbo.LuongDA.Sotien > 1200000 AND dbo.NhanVien.MaPB = 'PB2'

--15 Tìm tổng lương trên từng phòng.
SELECT MaPB, SUM(SoTien) 
FROM dbo.NhanVien 
INNER JOIN dbo.LuongDA ON LuongDA.MaNV = NhanVien.MaNV
GROUP BY MaPB

--16 Liệt kê các dự án có ít nhất 2 người tham gia.
SELECT MaDA, COUNT(MaNV) AS NguoiThamGia
FROM dbo.LuongDA
GROUP BY MaDA
HAVING COUNT(MaNV) >= 1

--17 Liệt kê thông tin chi tiết của nhân viên có tên bắt đầu bằng ký tự ‘N’.
SELECT * FROM dbo.NhanVien
WHERE LEFT(TenNV,1) = 'N'

--18 Thông tin chi tiết của nhân viên được nhận tiền dự án trong năm 2003.
SELECT MaNV,TenNV,NgaySinh,SoCMND,GioiTinh,DiaChi,NgayVaoLam FROM NhanVien
JOIN dbo.LuongDA 
ON NhanVien.MaNV = LuongDA.MaNV
WHERE YEAR(NgayNhan) = 2021

--19 thông tin chi tiết của nhân viên không tham gia bất cứ dự án nào.
SELECT * FROM dbo.NhanVien
WHERE MaNV NOT IN(
SELECT MaNV FROM dbo.LuongDA
)

--20 Xóa dự 1 dự án DA05
DELETE dbo.LuongDA WHERE MaDA = 'DA5'

--21 Xóa nhân viên có tổng lương là 1000000 
DELETE FROM dbo.LuongDA 
WHERE SoTien = 1000000

--22 Cập nhật lương cho DA02 tăng thêm 10% lương
UPDATE LuongDA
SET SoTien = SoTien*110/100
WHERE MaDA = 'DA2';
SELECT * FROM LuongDA

--23 Xóa các nhân viên trong bảng NhanVien khi có dữ liệu trong bảng DA
DELETE FROM NhanVien
WHERE MaNV NOT IN(
SELECT MaNV FROM dbo.LuongDA
)

--24 Đặt lại ngày vào làm của các nhân viên PB01 là 12/02/2020
UPDATE NhanVien 
SET NgayVaoLam = '2020-02-12'
WHERE MaPB = 'PB1'



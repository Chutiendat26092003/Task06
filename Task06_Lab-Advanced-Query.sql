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
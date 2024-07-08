Use master
Go

Create database SaleManagementSystem
Go

use SaleManagementSystem
Go

-- Create table Group Management
If OBJECT_ID('GroupManagement') IS NULL
	BEGIN
		Create table GroupManagement
		(
			GroupID nvarchar(50) primary key,
			GroupName nvarchar(MAX),
			GroupDescription nvarchar(MAX),
			UpdateTime datetime,
			UpdateBy nvarchar(50)
		)

	END
Go

-- Store procedure Get Group Management List
Create or alter procedure GetGroupManagementList
AS
	Begin
		Select GroupID, GroupName, GroupDescription, UpdateTime, UpdateBy
		From GroupManagement
	End
Go

--Store procedure to Insert Group Management
create or alter proc InsertGroupManagement 
@groupID nvarchar(50), @groupName nvarchar(50), @groupDescription nvarchar(MAX), @updateBy nvarchar (50)
as
	begin
		Insert into GroupManagement (GroupID,GroupName,GroupDescription,UpdateTime,UpdateBy)
		values (@groupID,@groupName,@groupDescription,GETDATE(),@updateBy)
	end
go

--Store procedure to Update Group Management 
create or alter proc UpdateGroupManagement
@groupID nvarchar(50), @groupName nvarchar(50), @groupDescription nvarchar(MAX), @updateBy nvarchar (50)
as 
	begin
		update GroupManagement
		set groupName = @groupName,
			GroupDescription =@groupDescription,
			UpdateTime = GETDATE(),
			UpdateBy = @updateBy
		where groupID = @groupID 
	end
go

--Store procedure to Delete Group Management
create or alter proc DeleteGroupManagement
@groupID nvarchar(50)
as
	begin
		delete GroupManagement
		where GroupID = @groupID
	end
go

-- create Table account

if OBJECT_ID('AccountManagement') is null
	begin
		create table AccountManagement
		(	
			AccountUser nvarchar (50) primary key,
			AccountPass nvarchar(50),
			AccountFullName nvarchar(MAX),
			UpdateTime datetime,
			UpdateBy nvarchar(50),
			GroupID nvarchar (50),
			foreign key (GroupID) references GroupManagement(GroupID)
		)
	end
go

-- store procedure to GetAccountManagement 
create or alter proc GetAccountManagementList 
as
	begin
		select AccountUser, AccountPass,AccountFullName,UpdateTime,UpdateBy,GroupID
		from AccountManagement
	end
go


-- store procedure to CreateAccount
create or alter proc CreateAccount
@AccountUser nvarchar(50), @AccountPass nvarchar(50), @AccountFullName nvarchar(MAX),@UpdateBy nvarchar(50), @GroupID nvarchar (50)
as
	begin
		insert into AccountManagement (AccountUser,AccountPass,AccountFullName,UpdateTime,UpdateBy,GroupID)
		values (@AccountUser,@AccountPass,@AccountFullName,GETDATE(),@UpdateBy,@GroupID)
	end
go

-- store procedure to change account password
create or alter proc ChangePassword
@AccountUser nvarchar(50),@NewAccountPass nvarchar(50)
as
	begin
		update AccountManagement
		set
			AccountPass=@NewAccountPass
		where AccountUser=@AccountUser
	end
go

-- store procedure to DeleteAccount
create or alter proc DeleteAccount
@AccountUser nvarchar(50)
as
	begin
		delete AccountManagement 
		where AccountUser = @AccountUser
	end
go

-- store procedure UpdateAccount
create or alter proc UpdateAccount
@AccountUser nvarchar(50), @AccountPass nvarchar(50), @AccountFullName nvarchar(MAX),@UpdateBy nvarchar(50),@GroupID nvarchar (50)
as
	begin
	update AccountManagement
	set 
		AccountPass = @AccountPass,
		AccountFullName = @AccountFullName,
		UpdateTime =GETDATE (),
		UpdateBy = @UpdateBy,
		GroupID = @GroupID
	where AccountUser = @AccountUser
	end
go


-- create table Function Management
if OBJECT_ID('FunctionManagement') is null
	begin
		create table FunctionManagement  
		(
			FunctionID nvarchar(50) primary key,
			FunctionName nvarchar(MAX),
		)
	end
go
-- **********  NOTE  ****************
-- Thêm Chay

--create table Group Function Management
if OBJECT_ID ('GroupFunction') is null
	begin
		create table GroupFunction
		(
			GroupID nvarchar(50),
			FunctionID nvarchar(50),
			isEnable bit default 'false',
			foreign key (GroupID) references GroupManagement (GroupID),
			foreign key (FunctionID) references FunctionManagement (FunctionID)
		)
	end
go

-- Store Procedure to Get Group Function List
create or alter proc GetGroupFunctionList
@groupID nvarchar (50)
as
	begin
		select fm.FunctionID, fm.FunctionName, rs.isEnable
		from FunctionManagement fm left join (select * from GroupFunction gp where GroupID =@groupID) as rs on fm.FunctionID = rs.FunctionID

	end
go

-- Store Procedure to Insert Group Function
create or alter proc InsertGroupFunction
@GroupID nvarchar (50), @FunctionID nvarchar(50), @isEnable bit
as 
	begin
		if not exists (Select * from GroupFunction where GroupID = @GroupID and FunctionID = @FunctionID)
			Begin
				insert into GroupFunction(GroupID, FunctionID,isEnable)
				values (@GroupID,@FunctionID,@isEnable)
			End
		else
			BEGIN
				Update GroupFunction
				Set isEnable = @isEnable
				where GroupID = @GroupID and FunctionID = @FunctionID
			END
	end
go

-- Store Procedure to Delete Group Function
create or alter proc DeleteGroupFunction 
@GroupID nvarchar (50)
as
	begin
	delete GroupFunction
	where GroupID = @GroupID
	end
go


--Store Procedure to Update Group Function
create or alter proc UpdateGroupFunction 
@GroupID nvarchar (50), @FunctionID nvarchar(50), @isEnable bit
as 
	begin
		update GroupFunction
		set
			isEnable = @isEnable
		where GroupID = @GroupID and FunctionID = @FunctionID
	end
go

-- create table Customers List
if OBJECT_ID('Customers') is null
	begin
		create table Customers  
		(
			CustomerID nvarchar(50) primary key,
			CustomerName nvarchar (MAX),
			CustomerAddress nvarchar (MAX),
			CustomerNumber nvarchar(50),
			UpdateTime Datetime,
			UpdateBy nvarchar(50)
		)
	end
go



--Store procedure to Get Customer List
create or alter proc GetCustomersList
as
	begin
		select CustomerID,CustomerName,CustomerAddress,CustomerNumber,UpdateTime, UpdateBy
		from Customers
	end
go

-- Store Procedure to Insert Customer 
create or alter proc InsertCustomer
@CustomerID nvarchar(50), @CustomerName nvarchar(MAX), @CustomerAddress nvarchar(MAX), @CustomerNumber nvarchar (50), @UpdateBy nvarchar(50)
as 
	begin
		insert into Customers (CustomerID,CustomerName,CustomerAddress,CustomerNumber,UpdateTime,UpdateBy)
		values (@CustomerID,@CustomerName,@CustomerAddress,@CustomerName,GETDATE(),@UpdateBy)
	end
go
--exec InsertCustomer '1','binh','vutung','0123'
-- Store procedure to Update Customer
create or alter proc UpdateCustomer
@CustomerID nvarchar(50), @CustomerName nvarchar(MAX), @CustomerAddress nvarchar(MAX), @CustomerNumber nvarchar (50), @UpdateBy nvarchar(50)
as 
	begin
		update Customers
		set	CustomerName = @CustomerName,
			CustomerAddress = @CustomerAddress,
			CustomerNumber = @CustomerNumber,
			UpdateTime = getdate(),
			UpdateBy = @UpdateBy
		where CustomerID = @CustomerID
	end
go

-- Store procedure to Delete Customer 
create or alter proc DeleteCustomer
@CustomerID nvarchar(50)
as
	begin
		delete Customers
		where CustomerID = @CustomerID
	end
go

-- create table Suppliers
if OBJECT_ID('Suppliers') is null
	begin
		create table Suppliers
		 (
			SupplierID nvarchar (50) primary key,
			SupplierName nvarchar (MAX),
			SupplierAddress nvarchar(MAX),
			SupplierNumber nvarchar (50),
			UpdateTime datetime,
			UpdateBy nvarchar(50)
			
		 )
	end
go



-- Store Procedure to Get Supplier list
create or alter proc GetSuppliersList
as
	begin
		select SupplierID, SupplierName, SupplierAddress, SupplierNumber,UpdateTime, UpdateBy
		from Suppliers
	end
go

-- Store Procedure to Insert Supplier
create or alter proc InsertSupplier
@SupplierID nvarchar (50), @SupplierName nvarchar (MAX), @SupplierAddress nvarchar(MAX), @SupplierNumber nvarchar (50),@UpdateBy nvarchar(50)
as
	begin
		insert into Suppliers (SupplierID, SupplierName, SupplierAddress, SupplierNumber,UpdateTime,UpdateBy)
		values (@SupplierID,@SupplierName,@SupplierAddress,@SupplierNumber,GETDATE(),@UpdateBy)
	end
go
--exec InsertSupplier '1','tuan','binhthanh','0123'


-- Store procedure to Update Supplier
create or alter proc UpdateSupplier
@SupplierID nvarchar (50), @SupplierName nvarchar (MAX), @SupplierAddress nvarchar(MAX), @SupplierNumber nvarchar (50),@UpdateBy nvarchar(50)
as
	begin
		update Suppliers
		set SupplierName = @SupplierName,
			SupplierAddress = @SupplierAddress,
			SupplierNumber = @SupplierNumber,
			UpdateTime= getdate	(),
			UpdateBy= @UpdateBy
		where SupplierID = @SupplierID
	end
go	

-- store procedure to Delete Supplier
create or alter proc DeleteSupplier 
@SupplierID nvarchar (50)
as
	begin
		delete Suppliers
		where SupplierID = @SupplierID
	end
go

-- create table Products
if OBJECT_ID ('Products') is null
	begin
		create table Products 
		(
			ProductID nvarchar(50) primary key,
			ProductName nvarchar (MAX),
			ProductUnit nvarchar(50),
			SupplierID nvarchar(50),
			foreign key (SupplierID) references Suppliers (SupplierID),
			UpdateTime datetime,
			UpdateBy nvarchar(50)
		)
	end
go

-- Store procedure to GetProductsList
create or alter proc GetProductsList 
as 
	begin
		select ProductID, ProductName, ProductUnit ,SupplierID, UpdateTime, UpdateBy
		from Products
	end
go

-- Store procedure to InsertProduct
create or alter proc InsertProduct 
@ProductID nvarchar(50), @ProductName nvarchar (MAX), @ProductUnit nvarchar(50), @SupplierID nvarchar(50), @UpdateBy nvarchar(50)
as
	begin
		insert into Products (ProductID, ProductName, ProductUnit ,SupplierID, UpdateTime, UpdateBy)
		values (@ProductID,@ProductName,@ProductUnit,@SupplierID,GETDATE(),@UpdateBy)
	end
go
--exec InsertProduct '1','caphe','ly','1','binh'

-- Store procedure to UpdateProduct
create or alter proc UpdateProduct
@ProductID nvarchar(50), @ProductName nvarchar (MAX), @ProductUnit nvarchar(50), @SupplierID nvarchar(50), @UpdateBy nvarchar(50)
as 
	begin
		update Products
		set	ProductName = @ProductName,
			ProductUnit = @ProductUnit,
			SupplierID = @SupplierID,
			UpdateTime = GETDATE(),
			UpdateBy = @UpdateBy
		where ProductID = @ProductID
	end
go

-- Store procedure to DeleteProduct
create or alter proc DeleteProduct
@ProductID nvarchar(50)
as 
	begin
		delete Products
		where ProductID = @ProductID
	end
go	



--create table Stock In List
if OBJECT_ID ('StockIn') is null
	begin
	create table StockIn 
		(
			StockInID nvarchar(50) primary key,
			SupplierID nvarchar(50),
			StockInDate datetime,
			TotalSum float default '0',
			UpdateTime datetime,
			UpdateBy nvarchar(50)
			foreign key (SupplierID) references Suppliers (SupplierID)
			
		)
	end
go


-- Store procedure to get Stock In list 
create or alter proc GetStockInList 
as
	begin
		select StockInID, SupplierID, StockInDate, TotalSum,UpdateTime, UpdateBy
		from StockIn
	end
go

-- store procedure to Insert Stock In
 create or alter proc InsertStockIn
 @StockInID nvarchar(50), @SupplierID nvarchar(50), @StockInDate datetime, @UpdateBy nvarchar (50)
 as 
	begin
		insert into StockIn (StockInID, SupplierID, StockInDate, UpdateTime, UpdateBy)
		values (@StockInID, @SupplierID, @StockInDate, GETDATE(),@UpdateBy)
	end
go	
--exec InsertStockIn '1','1','2024-05-05','4','5'
--exec GetStockInList

--****************** NOTE ****************
-- Nhập đúng định dạng ngày default của SQL (yyyy-MM-dd)
-- *********************************************


-- store procedure to update stock in
create or alter proc UpdateStockIn
 @StockInID nvarchar(50), @SupplierID nvarchar(50), @StockInDate datetime, @UpdateBy nvarchar (50)
 as
	begin
	update StockIn 
	set SupplierID = @SupplierID,
		StockInDate = @StockInDate,
		UpdateTime =GETDATE(),
		UpdateBy = @UpdateBy
	where StockInID = @StockInID
	end
go

-- store proc to delete stock in
create or alter proc DeleteStockIn
@StockInID nvarchar(50)
as
	begin
		delete StockIn
		where StockInID = @StockInID
	end
go

-- create table Stock In Detail
if OBJECT_ID ('StockInDetail') is null
	begin
		create table StockInDetail
			(
				StockInID nvarchar(50),
				ProductID nvarchar (50),
				Amount float,
				UnitPrice float,
				UnitSum float,
				UpdateTime datetime,
				UpdateBy nvarchar(50),
				primary key (StockInID, ProductID), 
				foreign key (StockInID) references StockIn (StockInID),
				foreign key (ProductID) references Products (ProductID),
			)
	end
go
 
--create store procedure get Stock In Detail List
create or alter proc GetStockInDetailList
as
	begin
		select StockInID, ProductID, Amount, UnitPrice, UnitSum, UpdateTime, UpdateBy
		from StockInDetail
	end
go

--exec GetStockInList

-- create store procedure to Insert Stock In Detail
create or alter proc InsertStockInDetail
@StockInID nvarchar(50), @ProductID nvarchar (50), @Amount float, @UnitPrice float , @UpdateBy nvarchar(50)
as
	begin
		insert into StockInDetail (StockInID, ProductID, Amount, UnitPrice, UnitSum, UpdateTime, UpdateBy)
		values (@StockInID, @ProductID, @Amount, @UnitPrice,@Amount * @UnitPrice, GETDATE(), @UpdateBy)
	end
go
--exec InsertStockInDetail '1','1','2','20','nhat'
--exec GetStockInDetailList
-- create store procedure to Update Stock In Detail
create or alter proc UpdateStockInDetail
@StockInID nvarchar(50), @ProductID nvarchar (50), @Amount float, @UnitPrice float, @UpdateBy nvarchar(50)
as
	begin
		update StockInDetail
		set 
			Amount = @Amount,
			UnitPrice = @UnitPrice,
			UnitSum = @Amount * @UnitPrice,
			UpdateTime = GETDATE(),
			UpdateBy = @UpdateBy
		where StockInID = @StockInID and ProductID = @ProductID
	end
go
--exec UpdateStockInDetail '1'2','nhat'
--exec GetStockInDetailList

-- create store procedure to delete stock in detail
create or alter proc DeleteStockInDetail
@StockInID nvarchar(50),@ProductID nvarchar(50)
as
	begin
		delete from StockInDetail
		where StockInID=@StockInID and ProductID = @ProductID
	end
go
--create table StockOut,'1','121','
if OBJECT_ID ('StockOut') is null
	begin
		create table StockOut
			(
			StockOutID nvarchar(50),
			CustomerID nvarchar(50),
			StockOutDate datetime,
			TotalSum float default'0',
			UpdateTime datetime,
			UpdateBy nvarchar(50),
			primary key(StockOutID),
			foreign key(CustomerID) references Customers (CustomerID)
			)
	end
go
--create store procdure to Get Stock Out
create or alter proc GetStockOutList 
as
	begin
		select StockOutID,CustomerID,StockOutDate,TotalSum,UpdateTime,UpdateBy
		from StockOut
	end
go
--create store procdure to Insert Stock Out
create or alter proc InsertStockOut
@StockOutID nvarchar(50),@CustomerID nvarchar(50),@StockOutDate datetime,@TotalSum float,@UpdateBy nvarchar(50)
as
	begin
		insert into StockOut(StockOutID,CustomerID,StockOutDate,TotalSum,UpdateTime,UpdateBy)
		values (@StockOutID,@CustomerID,@StockOutDate,@TotalSum,GETDATE(),@UpdateBy)
	end
go
--exec InsertStockOut '1','1','2023-05-05','10','binh'
 --exec InsertStockOut'2','1','2024-05-05','10','binh'
--create store procdure to Update Stock Out
create or alter proc UpdateStockOut
@StockOutID nvarchar(50),@CustomerID nvarchar(50),@StockOutDate datetime,@UpdateBy nvarchar(50)
as
	begin
		update StockOut
		set CustomerID=@CustomerID,
			StockOutDate=@StockOutDate,
			UpdateTime=GETDATE(),
			UpdateBy=@UpdateBy
		where StockOutID=@StockOutID
	end
go
--create store procdure to Delete Stock Out
create or alter proc DeleteStockOut
@StockOutID nvarchar(50)
as
	begin
		delete from StockOut
		where StockOutID=@StockOutID 
	end
go



--create table StockOutDetail
if OBJECT_ID ('StockOutDetail') is null
	begin
		create table StockOutDetail
			(
				StockOutID nvarchar(50),
				ProductID nvarchar (50),
				Amount float,
				UnitPrice float,
				UnitSum float,
				UpdateTime datetime,
				UpdateBy nvarchar(50),
				primary key (StockOutID, ProductID), 
				foreign key (StockOutID) references StockOut (StockOutID),
				foreign key (ProductID) references Products (ProductID)
			)
	end
go

--create store procedure get Stock Out Detail List
create or alter proc GetStockOutDetailList
as
	begin
		select StockOutID, ProductID, Amount, UnitPrice, UnitSum, UpdateTime, UpdateBy
		from StockOutDetail
	end
go

--exec GetStockInList

-- create store procedure to Insert Stock Out Detail
create or alter proc InsertStockOutDetail
@StockOutID nvarchar(50), @ProductID nvarchar (50), @Amount float, @UnitPrice float , @UpdateBy nvarchar(50)
as
	begin
		insert into StockOutDetail (StockOutID, ProductID, Amount, UnitPrice, UnitSum, UpdateTime, UpdateBy)
		values (@StockOutID, @ProductID, @Amount, @UnitPrice,@Amount * @UnitPrice, GETDATE(), @UpdateBy)
	end
go


-- create store procedure to Update Stock out Detail
create or alter proc UpdateStockOutDetail
@StockOutID nvarchar(50), @ProductID nvarchar (50), @Amount float, @UnitPrice float, @UpdateBy nvarchar(50)
as
	begin
		update StockOutDetail
		set ProductID = @ProductID,
			Amount = @Amount,
			UnitPrice = @UnitPrice,
			UnitSum = @Amount * @UnitPrice,
			UpdateTime = GETDATE(),
			UpdateBy = @UpdateBy
		where StockOutID = @StockOutID 
	end
go



-- create store procedure to delete stock in detail
create or alter proc DeleteStockOutDetail
@StockOutID nvarchar(50) , @ProDuctID nvarchar (50)
as
	begin
		delete from StockOutDetail
		where StockOutID=@StockOutID and ProductID = @ProDuctID
	end
go

INSERT [dbo].[AccountManagement] ([AccountUser], [AccountPass], [AccountFullName], [UpdateTime], [UpdateBy], [GroupID]) VALUES (N'admin', N'0707', N'Trần Quang Tuấn', CAST(N'2024-05-16T08:45:44.460' AS DateTime), N'System', N'Admin')
INSERT [dbo].[AccountManagement] ([AccountUser], [AccountPass], [AccountFullName], [UpdateTime], [UpdateBy], [GroupID]) VALUES (N'hoangphuc', N'123', N'Nguyễn Hoàng Phúc', CAST(N'2024-05-19T09:35:45.567' AS DateTime), N'User', N'User')
INSERT [dbo].[AccountManagement] ([AccountUser], [AccountPass], [AccountFullName], [UpdateTime], [UpdateBy], [GroupID]) VALUES (N'nhatquang', N'1410', N'Châu Quang Nhật', CAST(N'2024-05-16T09:33:24.100' AS DateTime), N'User', N'User')
INSERT [dbo].[AccountManagement] ([AccountUser], [AccountPass], [AccountFullName], [UpdateTime], [UpdateBy], [GroupID]) VALUES (N'phucnguyen', N'123', N'Nguyễn Hoàng Phúc', CAST(N'2024-05-18T21:48:47.073' AS DateTime), N'Student', N'Student')
go

INSERT [dbo].[Customers] ([CustomerID], [CustomerName], [CustomerAddress], [CustomerNumber], [UpdateTime], [UpdateBy]) VALUES (N'KH01', N'Trần Thị Như Quỳnh', N'361/19/22e Bến Bình Ðông P15 Q8', N'0931586231', CAST(N'2024-05-09T17:52:05.830' AS DateTime), N'Admin')
INSERT [dbo].[Customers] ([CustomerID], [CustomerName], [CustomerAddress], [CustomerNumber], [UpdateTime], [UpdateBy]) VALUES (N'KH02', N'Trần Quang Tuấn 1', N'184/43 Bãi Sậy P4 Q8', N'0707857393', CAST(N'2024-05-12T16:26:18.407' AS DateTime), N'User')
INSERT [dbo].[Customers] ([CustomerID], [CustomerName], [CustomerAddress], [CustomerNumber], [UpdateTime], [UpdateBy]) VALUES (N'KH03', N'Nguyễn Hồng Phúc', N'Phạm Văn Hai', N'Nguyễn Hồng Phúc', CAST(N'2024-05-18T15:56:48.740' AS DateTime), N'User')
GO

INSERT [dbo].[FunctionManagement] ([FunctionID], [FunctionName]) VALUES (N'mnuChangePass', N'Đổi Mật Khẩu')
INSERT [dbo].[FunctionManagement] ([FunctionID], [FunctionName]) VALUES (N'mnuQLDanhMucChung', N'Quản lý Danh mục chung')
INSERT [dbo].[FunctionManagement] ([FunctionID], [FunctionName]) VALUES (N'mnuQLNhapXuat', N'Quản lý Nhập Xuất')
INSERT [dbo].[FunctionManagement] ([FunctionID], [FunctionName]) VALUES (N'mnuQTHeThong', N'Quản Trị Hệ Thống')
GO

INSERT [dbo].[GroupManagement] ([GroupID], [GroupName], [GroupDescription], [UpdateTime], [UpdateBy]) VALUES (N'Admin', N'Admin', N'Full Permission', CAST(N'2024-05-16T08:49:24.187' AS DateTime), N'ADMIN')
INSERT [dbo].[GroupManagement] ([GroupID], [GroupName], [GroupDescription], [UpdateTime], [UpdateBy]) VALUES (N'Student', N'Student Group', N'One Permission', CAST(N'2024-05-18T21:47:33.557' AS DateTime), N'System')
INSERT [dbo].[GroupManagement] ([GroupID], [GroupName], [GroupDescription], [UpdateTime], [UpdateBy]) VALUES (N'User', N'User Admintrator', N'No Permission', CAST(N'2024-05-19T09:39:20.137' AS DateTime), N'ADMIN')
GO

INSERT [dbo].[GroupFunction] ([GroupID], [FunctionID], [isEnable]) VALUES (N'Admin', N'mnuChangePass', 1)
INSERT [dbo].[GroupFunction] ([GroupID], [FunctionID], [isEnable]) VALUES (N'Admin', N'mnuQLDanhMucChung', 0)
INSERT [dbo].[GroupFunction] ([GroupID], [FunctionID], [isEnable]) VALUES (N'Admin', N'mnuQLNhapXuat', 0)
INSERT [dbo].[GroupFunction] ([GroupID], [FunctionID], [isEnable]) VALUES (N'User', N'mnuQLDanhMucChung', 1)
INSERT [dbo].[GroupFunction] ([GroupID], [FunctionID], [isEnable]) VALUES (N'User', N'mnuQLNhapXuat', 1)
INSERT [dbo].[GroupFunction] ([GroupID], [FunctionID], [isEnable]) VALUES (N'User', N'mnuQTHeThong', 0)
INSERT [dbo].[GroupFunction] ([GroupID], [FunctionID], [isEnable]) VALUES (N'Student', N'mnuChangePass', 1)
INSERT [dbo].[GroupFunction] ([GroupID], [FunctionID], [isEnable]) VALUES (N'Student', N'mnuQLDanhMucChung', 1)
INSERT [dbo].[GroupFunction] ([GroupID], [FunctionID], [isEnable]) VALUES (N'Student', N'mnuQLNhapXuat', 0)
INSERT [dbo].[GroupFunction] ([GroupID], [FunctionID], [isEnable]) VALUES (N'Admin', N'mnuQTHeThong', 1)
INSERT [dbo].[GroupFunction] ([GroupID], [FunctionID], [isEnable]) VALUES (N'User', N'mnuChangePass', 1)
INSERT [dbo].[GroupFunction] ([GroupID], [FunctionID], [isEnable]) VALUES (N'Student', N'mnuQTHeThong', 0)
GO

INSERT [dbo].[Suppliers] ([SupplierID], [SupplierName], [SupplierAddress], [SupplierNumber], [UpdateTime], [UpdateBy]) VALUES (N'NCC01', N'Chợ Bình Tiên', N'184/43 Bãi Sậy P4 Q6', N'0938064544', CAST(N'2024-05-09T16:37:13.080' AS DateTime), N'Student')
INSERT [dbo].[Suppliers] ([SupplierID], [SupplierName], [SupplierAddress], [SupplierNumber], [UpdateTime], [UpdateBy]) VALUES (N'NCC02', N'Phúc Lộc Thọ 1', N'0938064544', N'0938064544', CAST(N'2024-05-12T16:27:44.750' AS DateTime), N'User')
INSERT [dbo].[Suppliers] ([SupplierID], [SupplierName], [SupplierAddress], [SupplierNumber], [UpdateTime], [UpdateBy]) VALUES (N'NCC03', N'tuấn', N'Bến Bình Đông', N'0707857393', CAST(N'2024-05-18T15:57:43.543' AS DateTime), N'User')
GO

INSERT [dbo].[Products] ([ProductID], [ProductName], [ProductUnit], [SupplierID], [UpdateTime], [UpdateBy]) VALUES (N'HH01', N'Cá', N'Kg', N'NCC01', CAST(N'2024-05-18T15:55:26.487' AS DateTime), N'User')
INSERT [dbo].[Products] ([ProductID], [ProductName], [ProductUnit], [SupplierID], [UpdateTime], [UpdateBy]) VALUES (N'HH02', N'Rau Cải', N'Kg', N'NCC01', CAST(N'2024-05-09T22:06:28.793' AS DateTime), N'System')
INSERT [dbo].[Products] ([ProductID], [ProductName], [ProductUnit], [SupplierID], [UpdateTime], [UpdateBy]) VALUES (N'HH03', N'Thịt', N'Kg', N'NCC01', CAST(N'2024-05-19T09:20:35.563' AS DateTime), N'User')
INSERT [dbo].[Products] ([ProductID], [ProductName], [ProductUnit], [SupplierID], [UpdateTime], [UpdateBy]) VALUES (N'HH04', N'Nhà', N'Cái', N'NCC01', CAST(N'2024-05-19T10:42:51.847' AS DateTime), N'User')
INSERT [dbo].[Products] ([ProductID], [ProductName], [ProductUnit], [SupplierID], [UpdateTime], [UpdateBy]) VALUES (N'HH05', N'Máy Tính', N'Cái', N'NCC03', CAST(N'2024-05-19T10:44:34.137' AS DateTime), N'User')
INSERT [dbo].[Products] ([ProductID], [ProductName], [ProductUnit], [SupplierID], [UpdateTime], [UpdateBy]) VALUES (N'HH06', N'Điện Thoại', N'Cái', N'NCC03', CAST(N'2024-05-19T10:52:04.310' AS DateTime), N'User')
GO
INSERT [dbo].[StockOut] ([StockOutID], [CustomerID], [StockOutDate], [TotalSum], [UpdateTime], [UpdateBy]) VALUES (N'PX01', N'KH03', CAST(N'2024-05-01T16:00:49.000' AS DateTime), 0, CAST(N'2024-05-18T16:00:58.980' AS DateTime), N'User')
INSERT [dbo].[StockOut] ([StockOutID], [CustomerID], [StockOutDate], [TotalSum], [UpdateTime], [UpdateBy]) VALUES (N'PX02', N'KH02', CAST(N'2024-05-02T15:43:17.000' AS DateTime), 0, CAST(N'2024-05-19T15:43:24.060' AS DateTime), N'User')
GO

INSERT [dbo].[StockIn] ([StockInID], [SupplierID], [StockInDate], [TotalSum], [UpdateTime], [UpdateBy]) VALUES (N'PN01', N'NCC03', CAST(N'2024-05-01T15:58:37.000' AS DateTime), 0, CAST(N'2024-05-18T15:58:43.667' AS DateTime), N'User')
INSERT [dbo].[StockIn] ([StockInID], [SupplierID], [StockInDate], [TotalSum], [UpdateTime], [UpdateBy]) VALUES (N'PN02', N'NCC01', CAST(N'2024-05-01T09:43:23.000' AS DateTime), 0, CAST(N'2024-05-19T09:44:00.090' AS DateTime), N'User')
INSERT [dbo].[StockIn] ([StockInID], [SupplierID], [StockInDate], [TotalSum], [UpdateTime], [UpdateBy]) VALUES (N'PN03', N'NCC01', CAST(N'2024-05-02T14:56:21.000' AS DateTime), 0, CAST(N'2024-05-19T14:56:27.463' AS DateTime), N'User')
INSERT [dbo].[StockIn] ([StockInID], [SupplierID], [StockInDate], [TotalSum], [UpdateTime], [UpdateBy]) VALUES (N'PN04', N'NCC02', CAST(N'2024-05-28T17:10:35.000' AS DateTime), 0, CAST(N'2024-05-11T21:19:48.480' AS DateTime), N'Admin')
INSERT [dbo].[StockIn] ([StockInID], [SupplierID], [StockInDate], [TotalSum], [UpdateTime], [UpdateBy]) VALUES (N'PN05', N'NCC01', CAST(N'2024-05-04T15:29:11.000' AS DateTime), 0, CAST(N'2024-05-19T15:29:58.610' AS DateTime), N'User')
INSERT [dbo].[StockIn] ([StockInID], [SupplierID], [StockInDate], [TotalSum], [UpdateTime], [UpdateBy]) VALUES (N'PN06', N'NCC03', CAST(N'2024-05-11T15:31:33.000' AS DateTime), 0, CAST(N'2024-05-19T15:31:40.543' AS DateTime), N'User')
GO

INSERT [dbo].[StockInDetail] ([StockInID], [ProductID], [Amount], [UnitPrice], [UnitSum], [UpdateTime], [UpdateBy]) VALUES (N'PN01', N'HH01', 5, 10, 50, CAST(N'2024-05-18T16:00:11.617' AS DateTime), N'System')
INSERT [dbo].[StockInDetail] ([StockInID], [ProductID], [Amount], [UnitPrice], [UnitSum], [UpdateTime], [UpdateBy]) VALUES (N'PN01', N'HH02', 10, 10, 100, CAST(N'2024-05-18T15:58:54.160' AS DateTime), N'System')
INSERT [dbo].[StockInDetail] ([StockInID], [ProductID], [Amount], [UnitPrice], [UnitSum], [UpdateTime], [UpdateBy]) VALUES (N'PN04', N'HH01', 10, 10, 100, CAST(N'2024-05-18T15:58:12.553' AS DateTime), N'System')
GO


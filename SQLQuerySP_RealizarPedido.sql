CREATE PROCEDURE SP_RealizarPedido
	@CustomerID NCHAR(5),
	@EmployeeID INT,
	@OrderDate DATETIME,
	@RequiredDate DATETIME,
	@ShippedDate DATETIME,
	@ShipVia INT,
	@Freight MONEY,
	@ShipName NVARCHAR(40),
	@ShipAddress NVARCHAR(60),
	@ShipCity NVARCHAR(15),
	@ShipRegion NVARCHAR(15),
	@ShipPostalCode NVARCHAR(10),
	@ShipCountry NVARCHAR(15),
	@ProductID INT,
	@Quantity INT
AS
BEGIN
	IF NOT EXISTS (SELECT 1 FROM [dbo].[Products] WHERE [ProductID]=@ProductID)
	BEGIN
		PRINT 'ESTE PRODUCTO NO EXISTE';
		RETURN;
	END

	DECLARE @UnitsInStock INT;
	SELECT @UnitsInStock=[UnitsInStock] FROM [dbo].[Products] WHERE [ProductID]=@ProductID;

	IF @Quantity > @UnitsInStock
	BEGIN
		PRINT 'EXISTENCIA DEL PRODUCTO INSUFICIENTE';
		RETURN;
	END

	INSERT INTO [dbo].[Orders] (
		CustomerID, EmployeeID, OrderDate, RequiredDate, ShippedDate, ShipVia, Freight, ShipName, ShipAddress, ShipCity, ShipRegion, ShipPostalCode, ShipCountry
	)
	VALUES (
		@CustomerID, @EmployeeID, @OrderDate, @RequiredDate, @ShippedDate, @ShipVia, @Freight, @ShipName, @ShipAddress, @ShipCity, @ShipRegion, @ShipPostalCode, @ShipCountry
	);

	DECLARE @OrderID INT
	SET @OrderID = SCOPE_IDENTITY();

	INSERT INTO [dbo].[Order Details] (
		OrderID, ProductID, UnitPrice, Quantity, Discount
	)
	SELECT @OrderID, @ProductID, UnitPrice, @Quantity, 0
	FROM [dbo].[Products]
	WHERE ProductID=@ProductID;

	UPDATE [dbo].[Products]
	SET UnitsInStock=UnitsInStock - @Quantity
	WHERE ProductID=@ProductID;
	PRINT 'PEDIDO REALIZADO EXITOSAMENTE';
END

-- Hacer pedido con Procedimiento Almacenado
EXEC SP_RealizarPedido
	@CustomerID = 'ALFKI',
    @EmployeeID = 5,
    @OrderDate = '2024-05-19',
    @RequiredDate = '2024-05-25',
    @ShippedDate = NULL,
    @ShipVia = 2,
    @Freight = 25.50,
    @ShipName = 'Empresa XYZ',
    @ShipAddress = '123 Calle Principal',
    @ShipCity = 'Ciudad ABC',
    @ShipRegion = 'Región XYZ',
    @ShipPostalCode = '12345',
    @ShipCountry = 'El Salvador',
    @ProductID = 78,
    @Quantity = 5;
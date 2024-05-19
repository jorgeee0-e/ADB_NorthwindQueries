CREATE PROCEDURE SP_IngresarProductos
	@ProductID INT,
	@ProductName NVARCHAR(40),
	@SupplierID INT,
	@CategoryID INT,
	@QuantityPerUnit NVARCHAR(20),
	@UnitPrice MONEY,
	@UnitsInStock SMALLINT,
	@UnitsOnOrder SMALLINT,
	@ReorderLevel SMALLINT,
	@Discontinued BIT
AS
BEGIN
	IF EXISTS (SELECT 1 FROM [dbo].[Products] WHERE [ProductID]=@ProductID OR [ProductName]=@ProductName)
	BEGIN
		PRINT 'ESTE PRODUCTO YA HA SIDO INGRESADO';
	END
	ELSE
	BEGIN
		SET IDENTITY_INSERT [dbo].[Products] ON;
		INSERT INTO [dbo].[Products] (
			ProductID, ProductName, SupplierID, CategoryID, QuantityPerUnit, UnitPrice, UnitsInStock, UnitsOnOrder, ReorderLevel, Discontinued
		)
		VALUES (
			@ProductID, @ProductName, @SupplierID, @CategoryID,	@QuantityPerUnit, @UnitPrice, @UnitsInStock, @UnitsOnOrder,	@ReorderLevel,	@Discontinued
		);
		SET IDENTITY_INSERT [dbo].[Products] OFF;
		PRINT 'PRODUCTO INGRESADO EXITOSAMENTE';
	END
END;

-- Agregar Productos con Procedimiento Almacenado
EXEC SP_IngresarProductos
	@ProductID=78,
	@ProductName='Producto X',
	@SupplierID=1,
	@CategoryID=1,
	@QuantityPerUnit='1 kg',
	@UnitPrice=12.50,
	@UnitsInStock=12,
	@UnitsOnOrder=0,
	@ReorderLevel=30,
	@Discontinued=1;
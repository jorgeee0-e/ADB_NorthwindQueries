IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id=OBJECT_ID(N'[dbo].[BITACORA]') AND type IN (N'U'))
BEGIN
	CREATE TABLE Bitacora (
		id INT PRIMARY KEY IDENTITY,
		Accion NVARCHAR(50),
		Usuario NVARCHAR(50),
		Fecha DATETIME,
		Producto NVARCHAR(40)
	);
END
GO

CREATE TRIGGER TR_Productos_Bitacora
ON [dbo].[Products]
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
	DECLARE @Accion NVARCHAR(50);
	DECLARE @Usuario NVARCHAR(50);
	DECLARE @Fecha DATETIME;
	DECLARE @Producto NVARCHAR(40);

	IF EXISTS (SELECT * FROM inserted)
	BEGIN
		IF EXISTS (SELECT * FROM deleted)
		BEGIN
			SET @Accion='Actualizar';
		END
		ELSE
		BEGIN
			SET @Accion='Insertar';
		END
	END
	ELSE
	BEGIN
		SET @Accion='Eliminar';
	END

	SET @Usuario=SUSER_NAME();

	SET @Fecha=GETDATE();

	IF @Accion='Eliminar'
	BEGIN
		SELECT @Producto=ProductName FROM deleted;
	END
	ELSE
	BEGIN
		SELECT @Producto=ProductName FROM inserted;
	END

	IF @@ROWCOUNT > 1
    BEGIN
        SELECT @Producto = COALESCE(@Producto + ', ', '') + ProductName FROM inserted;
    END

	INSERT INTO Bitacora (Accion, Usuario, Fecha, Producto)
	VALUES(@Accion, @Usuario, @Fecha, @Producto);

END;
GO

-- Agregar Productos con Procedimiento Almacenado
EXEC SP_IngresarProductos
	@ProductID=79,
	@ProductName='Peras',
	@SupplierID=1,
	@CategoryID=1,
	@QuantityPerUnit='1 kg',
	@UnitPrice=12.50,
	@UnitsInStock=12,
	@UnitsOnOrder=0,
	@ReorderLevel=30,
	@Discontinued=1;

-- Actualizar dato de Products
UPDATE [dbo].[Products]
SET UnitPrice = 21.99
WHERE ProductID = 79;


-- Borrar dato de Products
DELETE FROM [dbo].[Products]
WHERE ProductID = 79;
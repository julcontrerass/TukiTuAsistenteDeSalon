------------------------------------------------
-- CREAR BASE DE DATOS
------------------------------------------------
USE master;
GO

CREATE DATABASE TUKI_DB
COLLATE Latin1_General_CI_AI;
GO

USE TUKI_DB;
GO

------------------------------------------------
-- TABLAS
------------------------------------------------

CREATE TABLE USUARIO(
    UsuarioId INT IDENTITY(1,1) PRIMARY KEY,
    NombreUsuario VARCHAR(50) NOT NULL,
    Contrasenia VARCHAR(100) NOT NULL,
    Rol VARCHAR(20) NOT NULL,
    Email VARCHAR(50)
);

CREATE TABLE MESERO(
    MeseroId INT IDENTITY(1,1) PRIMARY KEY,
    Nombre VARCHAR(50) NOT NULL,
    Apellido VARCHAR(50),
    Activo BIT NOT NULL,
    UsuarioId INT NOT NULL,
    CONSTRAINT FK_MESERO_USUARIO FOREIGN KEY (UsuarioId) REFERENCES USUARIO(UsuarioId)
);

CREATE TABLE GERENTE(
    GerenteId INT IDENTITY(1,1) PRIMARY KEY,
    Nombre VARCHAR(50) NOT NULL,
    Apellido VARCHAR(50),
    Activo BIT NOT NULL,
    UsuarioId INT NOT NULL,
    CONSTRAINT FK_GERENTE_USUARIO FOREIGN KEY (UsuarioId) REFERENCES USUARIO(UsuarioId)
);

CREATE TABLE MESA(
    MesaId INT IDENTITY(1,1) PRIMARY KEY,
    NumeroMesa VARCHAR(50),
    Ubicacion VARCHAR(50),
    Estado VARCHAR(50),
    PosicionX INT DEFAULT 0,
    PosicionY INT DEFAULT 0,
    Activo BIT NOT NULL DEFAULT 1
);

CREATE TABLE ASIGNACIONMESA(
    AsignacionId INT IDENTITY(1,1) PRIMARY KEY,
    FechaAsignacion DATETIME,
    MeseroId INT NOT NULL,
    MesaId INT NOT NULL,
    Activa BIT NOT NULL,
    CONSTRAINT FK_ASIGNACION_MESERO FOREIGN KEY (MeseroId) REFERENCES MESERO(MeseroId),
    CONSTRAINT FK_ASIGNACION_MESA FOREIGN KEY (MesaId) REFERENCES MESA(MesaId)
);

CREATE TABLE CATEGORIA(
    CategoriaId INT IDENTITY(1,1) PRIMARY KEY,
    Nombre VARCHAR(50) NOT NULL,
    Descripcion VARCHAR(100),
    Activa BIT NOT NULL
);

CREATE TABLE PRODUCTO(
    ProductoId INT IDENTITY(1,1) PRIMARY KEY,
    Nombre VARCHAR(50) NOT NULL,
    Precio DECIMAL(10,2) NOT NULL,
    Stock INT NOT NULL,
    Disponible BIT NOT NULL,
    CategoriaId INT NOT NULL,
    CONSTRAINT FK_PRODUCTO_CATEGORIA FOREIGN KEY (CategoriaId) REFERENCES CATEGORIA(CategoriaId)
);

CREATE TABLE PEDIDO(
    PedidoId INT IDENTITY(1,1) PRIMARY KEY,
    FechaApertura DATETIME NOT NULL,
    FechaCierre DATETIME NULL,
    Estado BIT NOT NULL,
    Total DECIMAL(10,2) NOT NULL,
    AsignacionId INT NULL,
    CantidadPersonas INT NULL,
    EsMostrador BIT NOT NULL DEFAULT 0,
    CONSTRAINT FK_PEDIDO_ASIGNACION FOREIGN KEY (AsignacionId) REFERENCES ASIGNACIONMESA(AsignacionId)
);

CREATE TABLE DETALLEPEDIDO(
    DetalleId INT IDENTITY(1,1) PRIMARY KEY,
    PedidoId INT NOT NULL,
    ProductoId INT NOT NULL,
    Cantidad INT NOT NULL,
    PrecioUnitario DECIMAL(10,2) NOT NULL,
    Estado BIT NOT NULL,
    Subtotal DECIMAL(10,2) NOT NULL,
    CONSTRAINT FK_DETALLE_PEDIDO FOREIGN KEY (PedidoId) REFERENCES PEDIDO(PedidoId),
    CONSTRAINT FK_DETALLE_PRODUCTO FOREIGN KEY (ProductoId) REFERENCES PRODUCTO(ProductoId)
);

CREATE TABLE VENTA(
    VentaId INT IDENTITY(1,1) PRIMARY KEY,
    PedidoId INT NOT NULL,
    FechaVenta DATETIME NOT NULL,
    MontoTotal DECIMAL(10,2) NOT NULL,
    MetodoPago VARCHAR(50) NOT NULL,
    MontoRecibido DECIMAL(10,2),
    GerenteId INT NULL,
    CONSTRAINT FK_VENTA_PEDIDO FOREIGN KEY (PedidoId) REFERENCES PEDIDO(PedidoId),
    CONSTRAINT FK_VENTA_GERENTE FOREIGN KEY (GerenteId) REFERENCES GERENTE(GerenteId)
);

------------------------------------------------
-- DATOS INICIALES
------------------------------------------------

INSERT INTO CATEGORIA (Nombre, Descripcion, Activa) VALUES
('Comida', 'Platos principales y entradas', 1),
('Bebidas', 'Bebidas frías y calientes', 1),
('Postres', 'Postres y dulces', 1);
GO

INSERT INTO PRODUCTO (Nombre, Precio, Stock, Disponible, CategoriaId) VALUES
('Hamburguesa', 1500.00, 100, 1, 1),
('Pizza', 2000.00, 50, 1, 1),
('Ensalada', 1200.00, 80, 1, 1),
('Milanesa con Papas', 1800.00, 60, 1, 1),
('Bondiola', 1600.00, 70, 1, 1),
('Coca Cola', 500.00, 200, 1, 2),
('Americano', 300.00, 150, 1, 2),
('Jugo de Naranja', 400.00, 100, 1, 2),
('Agua', 250.00, 300, 1, 2),
('Flat white', 600.00, 150, 1, 2),
('Flan con Dulce de Leche', 800.00, 40, 1, 3),
('Tiramisu', 900.00, 30, 1, 3),
('Helado', 700.00, 60, 1, 3),
('Cheesecake', 950.00, 25, 1, 3);
GO


INSERT INTO USUARIO (NombreUsuario, Contrasenia, Email, Rol) VALUES
('admin', '$2a$11$hAspyF47MuqRuHfd5Dupl.pj6bS8IoxVUvlqRLwIwG2iU6zCt8o9i', 'admin@tuki.com', 'gerente'),
('juanperez', '$2a$11$qzTwKKGw74c9OvPQJCYKO.Vs/dxqh5UNHKGAE7Cva0GIzCMHP7uj2', 'juanperez@tuki.com', 'mesero'),
('mariagonzalez', '$2a$11$FedSDRp/VEJSdMT9YwlshO7HBR9HDUeZufXa9WqZPjosrrGYscgYS', 'mariagonzalez@tuki.com', 'mesero'),
('carlosrodriguez', '$2a$11$0kkzDpSQj.xF8uAZrbouZOeUTVG6kzUBRo5nbrEkD.mJaZXz8Gzxa', 'carlosrodriguez@tuki.com', 'mesero'),
('anamartinez', '$2a$11$QgWTq.SD.CWmWFYJycD0ruVoveb440XtFqHF97VlhTpFJjjPOuHye', 'anamartinez@tuki.com', 'mesero')
GO
INSERT INTO GERENTE (Nombre, Apellido, Activo, UsuarioId) VALUES
('admin' , 'admin', 1, 1)
GO

INSERT INTO MESERO (Nombre, Apellido, Activo, UsuarioId) VALUES
('Juan', 'Perez', 1, 2),
('Maria', 'Gonzalez', 1, 3),
('Carlos', 'Rodriguez', 1, 4),
('Ana', 'Martinez', 1, 5)
GO
select * from USUARIO
INSERT INTO MESA (NumeroMesa, Ubicacion, Estado, PosicionX, PosicionY) VALUES
('1', 'salon', 'libre', 20, 20),
('2', 'salon', 'libre', 190, 20),
('3', 'salon', 'libre', 360, 20),
('4', 'salon', 'libre', 530, 20),
('5', 'salon', 'libre', 20, 190),
('6', 'salon', 'libre', 190, 190),
('7', 'salon', 'libre', 360, 190),
('8', 'salon', 'libre', 530, 190),
('1', 'patio', 'libre', 20, 20),
('2', 'patio', 'libre', 190, 20),
('3', 'patio', 'libre', 360, 20),
('4', 'patio', 'libre', 20, 190),
('5', 'patio', 'libre', 190, 190),
('6', 'patio', 'libre', 360, 190);
GO

------------------------------------------------
-- FUNCIÓN (DEBE SER PRIMERA EN SU LOTE)
------------------------------------------------
CREATE FUNCTION dbo.fn_CalcularTurno (@Fecha DATETIME)
RETURNS VARCHAR(20)
AS
BEGIN
    DECLARE @Hora TIME = CAST(@Fecha AS TIME);

    RETURN CASE
        WHEN @Hora BETWEEN '10:00' AND '16:00' THEN 'Almuerzo'
        WHEN @Hora >= '19:00' OR @Hora <= '03:00' THEN 'Cena'
        ELSE 'Fuera de turno'
    END;
END;
GO

------------------------------------------------
-- PROCEDIMIENTOS ALMACENADOS
------------------------------------------------

-- Reporte de Mesas
CREATE PROCEDURE sp_ReporteMesas(
    @Turno VARCHAR(20) = 'Todos',
    @Cantidad VARCHAR(10) = 'Mas',
    @FechaDesde DATE,
    @FechaHasta DATE,
    @Ubicacion VARCHAR(20) = 'Todos',
    @OrdenPor VARCHAR(20)
)
AS
BEGIN
    IF (@Turno NOT IN ('Todos', 'Almuerzo', 'Cena') 
        OR @Cantidad NOT IN ('Mas', 'Menos') 
        OR @FechaDesde IS NULL 
        OR @FechaHasta IS NULL 
        OR @OrdenPor NOT IN ('Facturacion', 'Ocupacion') 
        OR @Ubicacion NOT IN('Todos', 'Salon', 'Patio'))
    BEGIN
        RAISERROR('Faltan parámetros obligatorios', 16, 1);
        RETURN;
    END

    SELECT 
        M.MesaId,
        M.NumeroMesa,
        M.Ubicacion,
        SUM(DP.Subtotal) AS Facturacion,
        COUNT(DISTINCT PE.PedidoId) AS Ocupacion
    FROM MESA M
    INNER JOIN ASIGNACIONMESA AM ON AM.MesaId = M.MesaId
    INNER JOIN PEDIDO PE ON PE.AsignacionId = AM.AsignacionId
    INNER JOIN DETALLEPEDIDO DP ON PE.PedidoId = DP.PedidoId
    WHERE PE.FechaApertura >= @FechaDesde 
        AND PE.FechaApertura < DATEADD(DAY, 1, @FechaHasta)
        AND (@Turno = 'Todos' OR dbo.fn_CalcularTurno(PE.FechaApertura) = @Turno)
        AND (@Ubicacion = 'Todos' OR M.Ubicacion = @Ubicacion)
    GROUP BY M.MesaId, M.NumeroMesa, M.Ubicacion
    ORDER BY 
        CASE 
            WHEN @Cantidad = 'Mas' AND @OrdenPor = 'Facturacion' THEN SUM(DP.Subtotal)
            WHEN @Cantidad = 'Mas' AND @OrdenPor = 'Ocupacion' THEN COUNT(DISTINCT PE.PedidoId)
        END DESC,
        CASE 
            WHEN @Cantidad = 'Menos' AND @OrdenPor = 'Facturacion' THEN SUM(DP.Subtotal)
            WHEN @Cantidad = 'Menos' AND @OrdenPor = 'Ocupacion' THEN COUNT(DISTINCT PE.PedidoId)
        END ASC;
END;
GO

-- Reporte de Meseros
CREATE PROCEDURE sp_ReporteMeseros(
    @Turno VARCHAR(20) = 'Todos',
    @Cantidad VARCHAR(10) = 'Mas',
    @FechaDesde DATE,
    @FechaHasta DATE,
    @Ubicacion VARCHAR(20) = 'Todos',
    @OrdenPor VARCHAR(20)
)
AS
BEGIN
    IF (@Turno NOT IN ('Todos', 'Almuerzo', 'Cena') 
        OR @Cantidad NOT IN ('Mas', 'Menos') 
        OR @FechaDesde IS NULL 
        OR @FechaHasta IS NULL 
        OR @OrdenPor NOT IN ('Facturacion', 'Mesas Atendidas') 
        OR @Ubicacion NOT IN('Todos', 'Salon', 'Patio'))
    BEGIN
        RAISERROR('Faltan parámetros obligatorios', 16, 1);
        RETURN;
    END

    SELECT 
        ME.Nombre + ' ' + ME.Apellido AS NombreApellido,
        ME.MeseroId,
        SUM(DP.Subtotal) AS Facturacion,
        COUNT(DISTINCT PE.PedidoId) AS MesasAtendidas
    FROM MESA M
    INNER JOIN ASIGNACIONMESA AM ON AM.MesaId = M.MesaId
    INNER JOIN PEDIDO PE ON PE.AsignacionId = AM.AsignacionId
    INNER JOIN DETALLEPEDIDO DP ON PE.PedidoId = DP.PedidoId
    INNER JOIN MESERO ME ON ME.MeseroId = AM.MeseroId
    WHERE PE.FechaApertura >= @FechaDesde 
        AND PE.FechaApertura < DATEADD(DAY, 1, @FechaHasta)
        AND (@Turno = 'Todos' OR dbo.fn_CalcularTurno(PE.FechaApertura) = @Turno)
        AND (@Ubicacion = 'Todos' OR M.Ubicacion = @Ubicacion)
    GROUP BY ME.Nombre, ME.Apellido, ME.MeseroId
    ORDER BY 
        CASE 
            WHEN @Cantidad = 'Mas' AND @OrdenPor = 'Facturacion' THEN SUM(DP.Subtotal)
            WHEN @Cantidad = 'Mas' AND @OrdenPor = 'Mesas Atendidas' THEN COUNT(DISTINCT PE.PedidoId)
        END DESC,
        CASE 
            WHEN @Cantidad = 'Menos' AND @OrdenPor = 'Facturacion' THEN SUM(DP.Subtotal)
            WHEN @Cantidad = 'Menos' AND @OrdenPor = 'Mesas Atendidas' THEN COUNT(DISTINCT PE.PedidoId)
        END ASC;
END;
GO

-- Reporte de Productos
CREATE PROCEDURE sp_ReporteProducto(
    @Turno VARCHAR(20) = 'Todos',
    @FechaDesde DATE,
    @FechaHasta DATE,
    @Ubicacion VARCHAR(20) = 'Todos',
    @CantidadProductos INT = 10,
    @MasOMenos VARCHAR(10) = 'Mas',
    @OrdenPor VARCHAR(20),
    @CategoriaProducto VARCHAR(50)
)
AS
BEGIN
    IF (@Turno NOT IN ('Todos', 'Almuerzo', 'Cena') 
        OR @MasOMenos NOT IN ('Mas', 'Menos') 
        OR @FechaDesde IS NULL 
        OR @FechaHasta IS NULL 
        OR @CantidadProductos IS NULL 
        OR @OrdenPor NOT IN ('Facturacion', 'Ventas') 
        OR @Ubicacion NOT IN('Todos', 'Salon', 'Patio') 
        OR @CategoriaProducto IS NULL)
    BEGIN
        RAISERROR('Faltan parámetros obligatorios', 16, 1);
        RETURN;
    END

    SELECT TOP (@CantidadProductos)
        P.Nombre,
        C.Nombre AS Categoria,
        SUM(DP.Subtotal) AS Facturacion,
        SUM(DP.Cantidad) AS CantidadVendida
    FROM DETALLEPEDIDO DP
    INNER JOIN PEDIDO PE ON PE.PedidoId = DP.PedidoId
    INNER JOIN ASIGNACIONMESA AM ON AM.AsignacionId = PE.AsignacionId
    INNER JOIN MESA M ON M.MesaId = AM.MesaId
    INNER JOIN PRODUCTO P ON P.ProductoId = DP.ProductoId
    INNER JOIN CATEGORIA C ON C.CategoriaId = P.CategoriaId
    WHERE PE.FechaApertura >= @FechaDesde 
        AND PE.FechaApertura < DATEADD(DAY, 1, @FechaHasta)
        AND (@Turno = 'Todos' OR dbo.fn_CalcularTurno(PE.FechaApertura) = @Turno)
        AND (@Ubicacion = 'Todos' OR M.Ubicacion = @Ubicacion)
        AND (@CategoriaProducto = 'Todos' OR C.Nombre = @CategoriaProducto)
    GROUP BY P.Nombre, C.Nombre
    ORDER BY 
        CASE 
            WHEN @MasOMenos = 'Mas' AND @OrdenPor = 'Facturacion' THEN SUM(DP.Subtotal)
            WHEN @MasOMenos = 'Mas' AND @OrdenPor = 'Ventas' THEN SUM(DP.Cantidad)
        END DESC,
        CASE 
            WHEN @MasOMenos = 'Menos' AND @OrdenPor = 'Facturacion' THEN SUM(DP.Subtotal)
            WHEN @MasOMenos = 'Menos' AND @OrdenPor = 'Ventas' THEN SUM(DP.Cantidad)
        END ASC;
END;
GO

-- Reporte de Ventas
CREATE PROCEDURE sp_ReporteVentas(
    @Turno VARCHAR(20) = 'Todos',
    @FechaDesde DATE,
    @FechaHasta DATE,
    @Ubicacion VARCHAR(20) = 'Todos',
    @TipoPago VARCHAR(50) = 'Todos'
)
AS
BEGIN
    IF (@Turno NOT IN ('Todos', 'Almuerzo', 'Cena')
        OR @FechaDesde IS NULL
        OR @FechaHasta IS NULL
        OR @Ubicacion NOT IN('Todos', 'Salon', 'Patio', 'Mostrador')
        OR @TipoPago IS NULL)
    BEGIN
        RAISERROR('Faltan parámetros obligatorios', 16, 1);
        RETURN;
    END

    SELECT
        V.VentaId,
        V.FechaVenta AS Fecha,
        CASE
            WHEN PE.EsMostrador = 1 THEN 'Mostrador'
            ELSE ISNULL(M.NumeroMesa, 'N/A')
        END AS NumeroMesa,
        CASE
            WHEN PE.EsMostrador = 1 THEN 'N/A'
            ELSE ISNULL(ME.Nombre + ' ' + ME.Apellido, 'N/A')
        END AS Mesero,
        V.MetodoPago AS TipoPago,
        V.MontoTotal,
        dbo.fn_CalcularTurno(V.FechaVenta) AS Turno
    FROM VENTA V
    INNER JOIN PEDIDO PE ON V.PedidoId = PE.PedidoId
    LEFT JOIN ASIGNACIONMESA AM ON PE.AsignacionId = AM.AsignacionId
    LEFT JOIN MESA M ON AM.MesaId = M.MesaId
    LEFT JOIN MESERO ME ON AM.MeseroId = ME.MeseroId
    WHERE V.FechaVenta >= @FechaDesde
        AND V.FechaVenta < DATEADD(DAY, 1, @FechaHasta)
        AND (@Turno = 'Todos' OR dbo.fn_CalcularTurno(V.FechaVenta) = @Turno)
        AND (@Ubicacion = 'Todos'
            OR (@Ubicacion = 'Mostrador' AND PE.EsMostrador = 1)
            OR (@Ubicacion <> 'Mostrador' AND M.Ubicacion = @Ubicacion))
        AND (@TipoPago = 'Todos' OR V.MetodoPago = @TipoPago)
    ORDER BY V.FechaVenta DESC;
END;
GO

-- Reporte de Balance General
CREATE PROCEDURE sp_ReporteBalance(
    @Turno VARCHAR(20) = 'Todos',
    @FechaDesde DATE,
    @FechaHasta DATE,
    @Ubicacion VARCHAR(20) = 'Todos'
)
AS
BEGIN
    IF (@Turno NOT IN ('Todos', 'Almuerzo', 'Cena')
        OR @FechaDesde IS NULL
        OR @FechaHasta IS NULL
        OR @Ubicacion NOT IN('Todos', 'Salon', 'Patio'))
    BEGIN
        RAISERROR('Faltan parámetros obligatorios', 16, 1);
        RETURN;
    END

    -- Total de ventas y cantidad
    DECLARE @TotalVentas DECIMAL(18,2);
    DECLARE @CantidadVentas INT;
    DECLARE @CantidadClientes INT;
    DECLARE @ProductosVendidos INT;

    SELECT
        @TotalVentas = ISNULL(SUM(V.MontoTotal), 0),
        @CantidadVentas = COUNT(DISTINCT V.VentaId),
        @CantidadClientes = COUNT(DISTINCT PE.AsignacionId)
    FROM VENTA V
    INNER JOIN PEDIDO PE ON V.PedidoId = PE.PedidoId
    LEFT JOIN ASIGNACIONMESA AM ON PE.AsignacionId = AM.AsignacionId
    LEFT JOIN MESA M ON AM.MesaId = M.MesaId
    WHERE V.FechaVenta >= @FechaDesde
        AND V.FechaVenta < DATEADD(DAY, 1, @FechaHasta)
        AND (@Turno = 'Todos' OR dbo.fn_CalcularTurno(V.FechaVenta) = @Turno)
        AND (@Ubicacion = 'Todos' OR M.Ubicacion = @Ubicacion OR PE.EsMostrador = 1);

    -- Total de productos vendidos
    SELECT @ProductosVendidos = ISNULL(SUM(DP.Cantidad), 0)
    FROM DETALLEPEDIDO DP
    INNER JOIN PEDIDO PE ON DP.PedidoId = PE.PedidoId
    INNER JOIN VENTA V ON V.PedidoId = PE.PedidoId
    LEFT JOIN ASIGNACIONMESA AM ON PE.AsignacionId = AM.AsignacionId
    LEFT JOIN MESA M ON AM.MesaId = M.MesaId
    WHERE V.FechaVenta >= @FechaDesde
        AND V.FechaVenta < DATEADD(DAY, 1, @FechaHasta)
        AND (@Turno = 'Todos' OR dbo.fn_CalcularTurno(V.FechaVenta) = @Turno)
        AND (@Ubicacion = 'Todos' OR M.Ubicacion = @Ubicacion OR PE.EsMostrador = 1);

    -- Resultado
    SELECT
        @TotalVentas AS TotalVentas,
        @CantidadVentas AS CantidadVentas,
        @CantidadClientes AS CantidadClientes,
        CASE WHEN @CantidadVentas > 0 THEN @TotalVentas / @CantidadVentas ELSE 0 END AS TicketPromedio,
        @ProductosVendidos AS ProductosVendidos;
END;
GO

-- Reporte de Ventas por Forma de Pago
CREATE PROCEDURE sp_ReporteVentasPorFormaPago(
    @Turno VARCHAR(20) = 'Todos',
    @FechaDesde DATE,
    @FechaHasta DATE,
    @Ubicacion VARCHAR(20) = 'Todos'
)
AS
BEGIN
    IF (@Turno NOT IN ('Todos', 'Almuerzo', 'Cena')
        OR @FechaDesde IS NULL
        OR @FechaHasta IS NULL
        OR @Ubicacion NOT IN('Todos', 'Salon', 'Patio'))
    BEGIN
        RAISERROR('Faltan parámetros obligatorios', 16, 1);
        RETURN;
    END

    DECLARE @TotalGeneral DECIMAL(18,2);

    SELECT @TotalGeneral = ISNULL(SUM(V.MontoTotal), 0)
    FROM VENTA V
    INNER JOIN PEDIDO PE ON V.PedidoId = PE.PedidoId
    LEFT JOIN ASIGNACIONMESA AM ON PE.AsignacionId = AM.AsignacionId
    LEFT JOIN MESA M ON AM.MesaId = M.MesaId
    WHERE V.FechaVenta >= @FechaDesde
        AND V.FechaVenta < DATEADD(DAY, 1, @FechaHasta)
        AND (@Turno = 'Todos' OR dbo.fn_CalcularTurno(V.FechaVenta) = @Turno)
        AND (@Ubicacion = 'Todos' OR M.Ubicacion = @Ubicacion OR PE.EsMostrador = 1);

    SELECT
        V.MetodoPago AS FormaPago,
        SUM(V.MontoTotal) AS Monto,
        COUNT(*) AS Cantidad,
        CASE WHEN @TotalGeneral > 0
            THEN (SUM(V.MontoTotal) * 100.0 / @TotalGeneral)
            ELSE 0
        END AS Porcentaje
    FROM VENTA V
    INNER JOIN PEDIDO PE ON V.PedidoId = PE.PedidoId
    LEFT JOIN ASIGNACIONMESA AM ON PE.AsignacionId = AM.AsignacionId
    LEFT JOIN MESA M ON AM.MesaId = M.MesaId
    WHERE V.FechaVenta >= @FechaDesde
        AND V.FechaVenta < DATEADD(DAY, 1, @FechaHasta)
        AND (@Turno = 'Todos' OR dbo.fn_CalcularTurno(V.FechaVenta) = @Turno)
        AND (@Ubicacion = 'Todos' OR M.Ubicacion = @Ubicacion OR PE.EsMostrador = 1)
    GROUP BY V.MetodoPago
    ORDER BY Monto DESC;
END;
GO

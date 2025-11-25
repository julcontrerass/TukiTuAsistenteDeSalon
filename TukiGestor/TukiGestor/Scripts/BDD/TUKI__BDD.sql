------------------------------------------------
-- CREAR BASE DE DATOS
------------------------------------------------
USE master;
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
    Contrasenia VARCHAR(50) NOT NULL,
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

INSERT INTO CATEGORIA VALUES
('Comida','Platos principales',1),
('Bebidas','Bebidas frías y calientes',1),
('Postres','Dulces y postres',1);

INSERT INTO PRODUCTO VALUES
('Hamburguesa',1500,100,1,1),
('Pizza',2000,50,1,1),
('Coca Cola',500,200,1,2),
('Agua',250,300,1,2),
('Flan',800,40,1,3);

INSERT INTO USUARIO VALUES
('robertocarlos','123456','rc@tuki.com'),
('cacho','123456','cacho@tuki.com');

INSERT INTO MESERO VALUES
('Juan','Perez',1,1),
('Maria','Gomez',1,2);

------------------------------------------------
-- FUNCIÓN (DEBE SER PRIMERA EN SU LOTE)
------------------------------------------------
GO
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
-- PROCEDIMIENTO ALMACENADO
------------------------------------------------
CREATE PROCEDURE sp_ReporteMesas(
    @Turno VARCHAR(20) = 'Todos',
    @Cantidad VARCHAR(10) = 'Mas',
    @FechaDesde DATE,
    @FechaHasta DATE,
    @Ubicacion VARCHAR(20) = 'Todos',
    @OrdenPor VARCHAR(20) = 'Mesa'
)
AS
BEGIN
    SELECT 
        M.NumeroMesa,
        M.Ubicacion,
        COUNT(P.PedidoId) AS CantidadPedidos
    FROM MESA M
    LEFT JOIN ASIGNACIONMESA A ON M.MesaId = A.MesaId
    LEFT JOIN PEDIDO P ON A.AsignacionId = P.AsignacionId
    WHERE CAST(P.FechaApertura AS DATE) BETWEEN @FechaDesde AND @FechaHasta
    GROUP BY M.NumeroMesa, M.Ubicacion
    ORDER BY M.NumeroMesa;
END;
GO



use master 
go
create database TUKI_DB
COLLATE Latin1_General_CI_AI
go
use TUKI_DB
go

CREATE TABLE [dbo].[USUARIO](
	[UsuarioId] [int] IDENTITY(1,1) NOT NULL,
	[NombreUsuario] [varchar](50) NOT NULL,
	[Contrasenia] [varchar](50) NOT NULL,
	[Email] [varchar](50) NULL,
	--[FechaAlta] [DATETIME] NOT NULL DEFAULT GETDATE(), 
	--[FechaBaja] [DATETIME] NULL,
	--[Activo] [BIT] NOT NULL DEFAULT(1),
 CONSTRAINT [PK_USUARIO] PRIMARY KEY CLUSTERED
(
	[UsuarioId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
)ON [PRIMARY]
GO

CREATE TABLE [dbo].[MESERO](
	[MeseroId] [int] IDENTITY(1,1) NOT NULL,
	[Nombre] [varchar](50) NOT NULL,
	[Apellido] [varchar] (50) NULL,
	[Activo] [bit] NOT NULL,
	[UsuarioId] [int] NOT NULL,
CONSTRAINT [PK_MESERO] PRIMARY KEY CLUSTERED
(
	[MeseroId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
CONSTRAINT [FK_MESERO_USUARIO] FOREIGN KEY ([UsuarioId])
REFERENCES [dbo].[USUARIO]([UsuarioId])
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[GERENTE](
	[GerenteId] [int] IDENTITY(1,1) NOT NULL,
	[Nombre] [varchar](50) NOT NULL,
	[Apellido] [varchar] (50) NULL,
	[Activo] [bit] NOT NULL,
	[UsuarioId] [int] NOT NULL,
CONSTRAINT [PK_GERENTE] PRIMARY KEY CLUSTERED
(
	[GerenteId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
CONSTRAINT [FK_GERENTE_USUARIO] FOREIGN KEY ([UsuarioId])
REFERENCES [dbo].[USUARIO]([UsuarioId])
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[MESA](
	[MesaId] [int] IDENTITY (1,1) NOT NULL,
	[NumeroMesa] [varchar](50) NULL,
	[Ubicacion] [varchar](50) NULL,
	[Estado] [varchar](50) NULL, -- CHECK (Estado IN ('Libre', 'Ocupada', 'Reservada'))
	--[Capacidad] [int] NOT NULL,
CONSTRAINT [PK_MESA] PRIMARY KEY CLUSTERED
(
	[MesaId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[ASIGNACIONMESA](
	[AsignacionId] [int] IDENTITY (1,1) NOT NULL,
	[FechaAsignacion] [datetime] NULL,
	[MeseroId] [int] NOT NULL,
	[MesaId] [int] NOT NULL,
	[Activa] [bit] NOT NULL,
	--[FechaCierre] [DATETIME] NULL, 
CONSTRAINT [PK_ASIGNACIONMESA] PRIMARY KEY CLUSTERED 
(
	[AsignacionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
CONSTRAINT [FK_ASIGNACIONMESA_MESERO] FOREIGN KEY ([MeseroId])
REFERENCES [dbo].[MESERO]([MeseroId]),
CONSTRAINT [FK_ASIGNACIONMESA_MESA] FOREIGN KEY ([MesaId])
REFERENCES [dbo].[MESA]([MesaId])
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[CATEGORIA](
	[CategoriaId] [int] IDENTITY (1,1) NOT NULL,
	[Nombre] [varchar](50) NOT NULL,
	[Descripcion] [varchar](100) NULL,
	[Activa] [bit] NOT NULL
CONSTRAINT [PK_CATEGORIA] PRIMARY KEY CLUSTERED ([CategoriaId] ASC)
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[PRODUCTO](
	[ProductoId] [int] IDENTITY (1,1) NOT NULL,
	[Nombre] [varchar](50) NOT NULL,
	[Precio] [decimal](10,2) NOT NULL,
	[Stock] [int] NOT NULL,
	[Disponible] [bit] NOT NULL,
	[CategoriaId] [int] NOT NULL,
CONSTRAINT [PK_PRODUCTO] PRIMARY KEY CLUSTERED ([ProductoId] ASC),
CONSTRAINT [FK_PRODUCTO_CATEGORIA] FOREIGN KEY ([CategoriaId])
REFERENCES [dbo].[CATEGORIA]([CategoriaId])
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[PEDIDO](
	[PedidoId] [int] IDENTITY(1,1) NOT NULL,
	[FechaApertura] [datetime] NOT NULL,
	[FechaCierre] [datetime] NULL,
	[Estado] [bit] NOT NULL, --CHECK(Estado in ('Abierto','Cerrado','Cancelado')),
	[Total] [decimal](10,2) NOT NULL,
	[AsignacionId] [int] NULL, 
	[CantidadPersonas] [int] NULL,
	[EsMostrador] [bit] NOT NULL DEFAULT 0,
CONSTRAINT [PK_PEDIDO] PRIMARY KEY CLUSTERED ([PedidoId] ASC),
CONSTRAINT [FK_PEDIDO_ASIGNACIONMESA] FOREIGN KEY ([AsignacionId])
REFERENCES [dbo].[ASIGNACIONMESA]([AsignacionId])
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[DETALLEPEDIDO](
	[DetalleId] [int] IDENTITY(1,1) NOT NULL,
	[PedidoId] [int] NOT NULL,
	[ProductoId] [int] NOT NULL,
	[Cantidad] [int] NOT NULL,
	[PrecioUnitario] [decimal](10,2) NOT NULL,
	[Estado] [bit] NOT NULL,
	[Subtotal] [decimal](10,2) NOT NULL,
CONSTRAINT [PK_DETALLEPEDIDO] PRIMARY KEY CLUSTERED ([DetalleId] ASC),
CONSTRAINT [FK_DETALLEPEDIDO_PEDIDO] FOREIGN KEY ([PedidoId])
REFERENCES [dbo].[PEDIDO]([PedidoId]),
CONSTRAINT [FK_DETALLEPEDIDO_PRODUCTO] FOREIGN KEY ([ProductoId])
REFERENCES [dbo].[PRODUCTO]([ProductoId])
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[VENTA](
	[VentaId] [int] IDENTITY(1,1) NOT NULL,
	[PedidoId] [int] NOT NULL,
	[FechaVenta] [datetime] NOT NULL,
	[MontoTotal] [decimal](10,2) NOT NULL,
	[MetodoPago] [varchar](50) NOT NULL,
	[MontoRecibido] [decimal](10,2) NULL,
	[GerenteId] [int] NULL,
CONSTRAINT [PK_VENTA] PRIMARY KEY CLUSTERED ([VentaId] ASC),
CONSTRAINT [FK_VENTA_PEDIDO] FOREIGN KEY ([PedidoId])
    REFERENCES [dbo].[PEDIDO]([PedidoId]),
CONSTRAINT [FK_VENTA_GERENTE] FOREIGN KEY ([GerenteId])
    REFERENCES [dbo].[GERENTE]([GerenteId])
) ON [PRIMARY]
GO
-- No estamos usando la tabla venta por ahora


-- ============================================
-- DATOS INICIALES PARA MESAS.ASPX
-- ============================================
INSERT INTO CATEGORIA (Nombre, Descripcion, Activa)
VALUES
('Comida', 'Platos principales y entradas', 1),
('Bebidas', 'Bebidas frías y calientes', 1),
('Postres', 'Postres y dulces', 1);
GO

INSERT INTO PRODUCTO (Nombre, Precio, Stock, Disponible, CategoriaId)
VALUES
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

INSERT INTO USUARIO (NombreUsuario, Contrasenia, Email)
VALUES
('robertocarlos', '123456', 'robertocarlos@tuki.com'),
('cacho', '123456', 'cacho@tuki.com'),
('ruperto', '123456', 'ruperto@tuki.com'),
('alla', '123456', 'alla@tuki.com'),
('aca', '123456', 'aca@tuki.com');
GO

INSERT INTO MESERO (Nombre, Apellido, Activo, UsuarioId)
VALUES
('Juan', 'Perez', 1, 1),
('Maria', 'Gonzalez', 1, 2),
('Carlos', 'Rodriguez', 1, 3),
('Ana', 'Martinez', 1, 4),
('Luis', 'Fernandez', 1, 5);
GO

INSERT INTO MESA (NumeroMesa, Ubicacion, Estado)
VALUES
('1', 'salon', 'libre'),
('2', 'salon', 'libre'),
('3', 'salon', 'libre'),
('4', 'salon', 'libre'),
('5', 'salon', 'libre'),
('6', 'salon', 'libre'),
('7', 'salon', 'libre'),
('8', 'salon', 'libre');
GO

INSERT INTO MESA (NumeroMesa, Ubicacion, Estado)
VALUES
('1', 'patio', 'libre'),
('2', 'patio', 'libre'),
('3', 'patio', 'libre'),
('4', 'patio', 'libre'),
('5', 'patio', 'libre'),
('6', 'patio', 'libre');
GO

-- ============================================
-- CONSULTAS DE VERIFICACION
-- ============================================
select * from ASIGNACIONMESA
select * from CATEGORIA
select * from DETALLEPEDIDO
select * from GERENTE
select * from MESA
select * from MESERO
select * from PEDIDO
select * from PRODUCTO
select * from USUARIO

DELETE FROM MESA

select * from PEDIDO

select * from DETALLEPEDIDO DP
join PRODUCTO P on DP.ProductoId = p.ProductoId


select * from PEDIDO where PedidoId = 1
select * from DETALLEPEDIDO
select * from ASIGNACIONMESA
select * from VENTA
select * from PEDIDO

select * from MESA where mesaId = 13


CREATE FUNCTION dbo.fn_CalcularTurno (@Fecha DATETIME)
RETURNS VARCHAR(20)
AS
BEGIN
    DECLARE @Hora TIME = CAST(@Fecha AS TIME);
    RETURN (
        CASE
            WHEN @Hora BETWEEN '10:00' AND '16:00'
                THEN 'Almuerzo'          
          
            WHEN @Hora >= '19:00'
                THEN 'Cena'

            WHEN @Hora <= '03:00'
                THEN 'Cena'

            ELSE 'Fuera de turno'
        END
    );
END
GO

SELECT * FROM MEsa


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
	SELECT
		M.MesaId,
		M.NumeroMesa,
		M.Ubicacion,
		SUM(DP.Subtotal) AS Total,
		COUNT(DISTINCT PE.PedidoId) AS Ocupacion
	FROM MESA M
		INNER JOIN ASIGNACIONMESA AM ON AM.MesaId = M.MesaId
		INNER JOIN PEDIDO PE ON PE.AsignacionId = AM.AsignacionId
		INNER JOIN DETALLEPEDIDO DP ON PE.PedidoId = DP.PedidoId
	WHERE
		PE.FechaApertura >= @FechaDesde
		AND PE.FechaApertura < DATEADD(DAY, 1, @FechaHasta)
		AND (
        @Turno = 'Todos'
		OR dbo.fn_CalcularTurno(PE.FechaApertura) = @Turno
    )
		AND (
        @Ubicacion = 'Todos'
		OR M.Ubicacion = @Ubicacion
    )
	GROUP BY M.MesaId,M.NumeroMesa, M.Ubicacion
	ORDER BY
	CASE 
            WHEN @Cantidad = 'Mas' AND @OrdenPor = 'Facturacion' THEN SUM(DP.Subtotal)
            WHEN @Cantidad = 'Mas' AND @OrdenPor = 'Ocupacion'   THEN COUNT(DISTINCT PE.PedidoId)
        END DESC,
        CASE 
            WHEN @Cantidad = 'Menos' AND @OrdenPor = 'Facturacion' THEN SUM(DP.Subtotal)
            WHEN @Cantidad = 'Menos' AND @OrdenPor = 'Ocupacion'   THEN COUNT(DISTINCT PE.PedidoId)
        END ASC;
END
GO

drop PROCEDURE sp_FiltrarPorMesas

EXEC sp_FiltrarPorMesas 'Todos', 


SELECT  M.NumeroMesa, M.Ubicacion, COUNT(PE.PedidoId) AS Ocupacion FROM PEDIDO PE 
INNER JOIN ASIGNACIONMESA AM ON AM.AsignacionId = PE.AsignacionId
INNER JOIN MESA M ON M.MesaId = AM.MesaId
GROUP BY M.NumeroMesa, M.Ubicacion
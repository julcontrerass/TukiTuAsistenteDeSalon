<%@ Page Title="Stock" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Stock.aspx.cs" Inherits="TukiGestor.Stock" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <style>
        .container.body-content {
            padding: 0 !important;
            margin: 0 !important;
            margin-bottom: 0 !important;
            max-width: 100% !important;
            width: 100% !important;
            flex: 1 !important;
            overflow: visible !important;
        }

        .stock-container {
            position: fixed;
            left: calc(50vw + 140px);
            top: 40px;
            transform: translateX(-50%);
            z-index: 100;
            width: 90%;
            max-width: 1200px;
            padding: 20px;
            padding-bottom: 120px;
        }

        .sidebar.collapsed ~ .main-wrapper .stock-container {
            left: calc(50vw + 40px);
        }

        .input-group-text {
            border: none;
            background-color: #E2D9D0 !important;
            color: #000 !important;
        }

        .form-control:focus {
            box-shadow: 0 0 8px rgba(226, 217, 208, 0.7);
            border-color: #E2D9D0;
        }

        .btn-custom {
            background-color: #E2D9D0 !important;
            border: none;
            color: #000 !important;
        }

        .btn-custom:hover {
            background-color: #d8cfc7 !important;
        }

        .modal-header,
        .modal-footer {
            background-color: #E2D9D0 !important;
            color: #000 !important;
        }

        .btn-link.text-danger {
            text-decoration: none;
            font-size: 1.3rem;
        }

        .btn-link.text-danger:hover {
            color: #b30000 !important;
            transform: scale(1.2);
            transition: 0.2s ease;
        }


    </style>

    <div class="stock-container">
        <h2 class="text-center mb-4">Gestión de Stock</h2>

        <!-- 🔍 BUSCADOR -->
        <div class="d-flex justify-content-center mb-4">
            <div class="input-group" style="width: 400px;">
                <span class="input-group-text">
                    <i class="bi bi-search"></i>
                </span>
                <asp:TextBox ID="TextBox1" runat="server" CssClass="form-control" placeholder="Buscar producto..."></asp:TextBox>
            </div>
        </div>

        <table class="table table-striped table-hover text-center shadow-lg">
            <thead class="table-dark">
                <tr>
                    <th>Categoría</th>
                    <th>Nombre</th>
                    <th>Descripción</th>
                    <th>Cantidad</th>
                    <th>Precio</th>
                    <th>Eliminar</th>
                </tr>
            </thead>
            <tbody>
                <tr>
                    <td>Comida</td>
                    <td>Papas Fritas</td>
                    <td>Porción de papas medianas</td>
                    <td>25</td>
                    <td>$20</td>
                    <td>
                        <button type="button" class="btn btn-link text-danger">
                            <i class="bi bi-trash-fill"></i>
                        </button>
                    </td>
                </tr>
                <tr>
                    <td>Bebida</td>
                    <td>Cerveza Artesanal</td>
                    <td>Botella 500ml</td>
                    <td>48</td>
                    <td>$15</td>
                    <td>
                        <button type="button" class="btn btn-link text-danger">
                            <i class="bi bi-trash-fill"></i>
                        </button>
                    </td>
                </tr>
                <tr>
                    <td>Comida</td>
                    <td>Hamburguesa Clásica</td>
                    <td>Carne, lechuga, tomate y pan</td>
                    <td>12</td>
                    <td>$25</td>
                    <td>
                        <button type="button" class="btn btn-link text-danger">
                            <i class="bi bi-trash-fill"></i>
                        </button>
                    </td>
                </tr>
            </tbody>
        </table>

        <!-- BOTONES -->
        <div class="d-flex justify-content-center gap-3 mt-4">
            <button type="button" class="btn btn-custom btn-lg px-4 shadow-sm" data-bs-toggle="modal" data-bs-target="#nuevoProductoModal">
                Nuevo producto
            </button>
        </div>
    </div>

    <!-- 🌟 VENTANA EMERGENTE NUEVO PRODUCTO -->
    <div class="modal fade" id="nuevoProductoModal" tabindex="-1" aria-labelledby="nuevoProductoModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content shadow-lg rounded-4">
                <div class="modal-header">
                    <h5 class="modal-title" id="nuevoProductoModalLabel">Agregar nuevo producto</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Cerrar"></button>
                </div>

                <div class="modal-body bg-light">
                    <div class="mb-3">
                        <label for="txtNombre" class="form-label">Nombre del producto</label>
                        <asp:TextBox ID="txtNombre" runat="server" CssClass="form-control" placeholder="Ej: Pizza Napolitana"></asp:TextBox>
                    </div>

                    <div class="mb-3">
                        <label for="txtDescripcion" class="form-label">Descripción</label>
                        <asp:TextBox ID="txtDescripcion" runat="server" CssClass="form-control" placeholder="Ej: Masa fina, tomate, mozzarella"></asp:TextBox>
                    </div>

                    <div class="mb-3">
                        <label for="txtCantidad" class="form-label">Cantidad</label>
                        <asp:TextBox ID="txtCantidad" runat="server" CssClass="form-control" TextMode="Number" placeholder="Ej: 50"></asp:TextBox>
                    </div>
                </div>

                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
                    <asp:Button ID="btnGuardar" runat="server" Text="Guardar" CssClass="btn btn-custom" OnClick="btnGuardar_Click" />
                </div>
            </div>
        </div>
    </div>
</asp:Content>
